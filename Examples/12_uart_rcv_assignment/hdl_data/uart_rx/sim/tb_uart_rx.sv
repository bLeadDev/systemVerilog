/////////////////////////////////////////////////////////////////////
//  Project:    HDL Assignments ETD
//  Author:     Michael Geuze
//  Purpose:    Testbench for implementation for a uart reciver
//  Date:       28.11.2023
//
/////////////////////////////////////////////////////////////////////


module tb_uart_rx ();

localparam fclk         = 50_000_000;
localparam baud         = 115_200;
localparam bit_period   = 8680;         // A bit period with the given timing is about ~8680 ns

// Global lines
logic           rst_n;          // Active low reset
logic           clk50m;         // 50MHz clock

// Rx Module lines
logic           rx;             // Input of Rx Module
logic   [7:0]   rx_data;        // Read data output of Rx Module
logic           rx_ready;       // New data is ready to read
logic           rx_error;       // Error reading data frame 
logic           rx_idle;        // Indicates idle state of Rx Module 

// Tx Module lines
logic [7:0]     tx_data;        // Data input of Tx module
logic           tx_start;       // To start data frame of Tx Module

// Wires for connection with Tx Module and forced Rx input
logic           rx_mod;         // Line from Tx Module to Rx Module
logic           rx_forced;      // Line for forced input to Rx Module
logic           mod_active;     // Switch to connect Tx Module on Rx Line

uart_rx dut (.*);
uart_tx #(
    .FCLK(fclk),
    .BAUD(baud)
)
    tx_mod (    
 .rst_n(rst_n),                 //active low reset
 .clk(clk50m),                  //clock
 .tx_data(tx_data),             //data payload
 .tx_start(tx_start),           //starts data frame
 .tx(rx_mod),                   //uart tx line
 .tx_idle()                     //indicates module is idle, new frame can be sent, unused here!
);
int run_sim = 1;

int     err_cnt = 0;
int     pass_cnt = 0;
string  action = "Starting tb_uart_rx with POR";    // String for ongoing action   
string  check = "";                                 // String for ongoing check
string  error_msg = "";                             // String to write detailed error message to!

logic  [7:0]    testdata [0:3]; 

initial begin
    mod_active = 1'b0;      // Decativate the uart tx module, use forced inputs for rx

    rst_n       = 1'b0;
    rx_forced   = 1'b0;
    #1000ns;
    rst_n       = 1'b1;
    rx_forced   = 1'b1;
    action = "POR done";
    $display(action);
    #1000ns;
    // POR DONE
    
    // TESTBLOCK: sending legal bit sequence
    action = "Sending start bit";
    $display(action);
    rx_forced   = 1'b0;
    #bit_period;


    action = "Sending bit sequence [7:0] 10101010";
    $display(action);
    rx_forced   = 1'b0;
    #bit_period;
    
    for (int i = 0; i < 7; i++) begin
        rx_forced    = ~rx;
        #bit_period;
    end
    action = "Sending stop bit";
    $display(action);
    rx_forced    = 1'b1; 
    #bit_period;

    #2000ns;
    check = "Checking bit sequence [7:0] b101_01010, data ready, idle and no error flags";
    if (rx_data == 8'b1010_1010 && rx_ready == 1'b1 && rx_idle == 1'b1 && rx_error == 1'b0) begin
        pass_cnt++;
    end
    else begin
        err_cnt++;
        $error(check);
    end
    #100ns;
    // END TESTBLOCK

    // TESTBLOCK: sending illegal bit sequence, error at stop bit for 2 cycles
    action = "Sending start bit";
    $display(action);
    rx_forced    = 1'b0;
    #8670ns;


    action = "Sending bit sequence [7:0] 01010101 0x55";
    $display(action);

    for (int i = 0;i < 8; i++) begin
        rx_forced   = ~rx;
        #bit_period;
    end
    action = "Sending stop bit";
    $display(action);
    rx_forced    = 1'b1;
    #2000ns;
    rx_forced    = 1'b0; // RX low for 2 cycles, error should be activated
    @(negedge clk50m);
    @(negedge clk50m);
    rx_forced   = 1'b1;  // Keep RX high after that
    #bit_period;

    check = "Checking illegal bit sequence data ready, idle and no error flags";
    if (rx_ready == 1'b1 && rx_idle == 1'b1 && rx_error == 1'b1) begin
        pass_cnt++;
    end
    else begin
        err_cnt++;
        $error(check);
        $error("rdy: %d, idle: %d, err: %d", rx_ready, rx_idle, rx_error);
    end
    #100ns;
    // END TESTBLOCK
    #2us;
    // STARTING TX_MODULE TESTS
    mod_active = 1'b1;

    testdata [0:3] = {8'hA5, 8'h5A, 8'hFF, 8'h00};

    for (int run_cnt = 0; run_cnt < 4; run_cnt++) begin
        action = "Starting tests with Rx Tx connected";
        $display("Starting run %d with testdata 0x%x", 
                run_cnt, testdata[run_cnt]);
        // Setting testdata
        tx_data = testdata[run_cnt];
        #100ns;
        // Start dataframe
        tx_start = 1'b1;
        #100ns;
        // Wait for ready signal at the receiver and reset start signal
        tx_start = 1'b0;
        @(posedge rx_ready);
        // Check data validity
        check = "Checking testdata with tx and rx connected.";
        if (rx_data == testdata[run_cnt]) begin
            $display("Run %0d successful", run_cnt);
            pass_cnt++;
        end
        else begin
            err_cnt++;
            $error(
                "Error: check=%s, \ndata received: 0x%x\ntestdata sent: 0x%x\n rdy: %0d, idle: %0d, err: %0d", 
                check, rx_data, testdata[run_cnt], rx_ready, rx_idle, rx_error);
        end
        #100ns;
    end
    // END TX_MODULE TEST

    // EVALUATE TESTS
    if(err_cnt > 0) begin
        $display("Passed %0d/%0d tests.", pass_cnt, pass_cnt + err_cnt);
        $display("%0d tests have failed.", err_cnt);
    end else if (err_cnt == 0) begin
        $display("All %0d tests passed.", pass_cnt);
    end 
    $display("tb_cpu finished.");
    run_sim = 0;


end

// Multiplexer to set signals for forced testing or connection of Tx module
always_comb begin
    if (~mod_active) begin
        rx = rx_forced;
    end
    else begin
        rx = rx_mod;
    end
end

// 50MHz clock generation
initial begin
    clk50m = 1'b0;
    while (run_sim) begin
        clk50m = ~clk50m;
        #10ns;
    end
end


endmodule