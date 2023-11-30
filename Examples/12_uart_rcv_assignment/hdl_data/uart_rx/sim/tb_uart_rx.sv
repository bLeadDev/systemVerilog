/////////////////////////////////////////////////////////////////////
//  Project:    HDL Assignments ETD
//  Author:     Michael Geuze
//  Purpose:    Testbench for implementation for a uart reciver
//  Date:       28.11.2023
//
/////////////////////////////////////////////////////////////////////


module tb_uart_rx ();

localparam fclk = 50_000_000;
localparam baud = 115_200;
localparam bit_period =  1_000_000_000/baud; // ~8680 ns

logic           rst_n;
logic           clk50m;
logic           rx;
logic   [7:0]   rx_data;
logic           rx_ready;
logic           rx_error;
logic           rx_idle;


uart_rx dut (.*);

int run_sim = 1;

int err_cnt = 0;
int pass_cnt = 0;
string action = "Starting tb_uart_rx with POR";
string check = "";

initial begin
    rst_n       = 1'b0;
    rx          = 1'b0;
    #100ns;
    rst_n       = 1'b1;
    rx          = 1'b1;
    action = "POR done";
    $display(action);
    #100ns;
    // POR DONE
    
    // TESTBLOCK: sending legal bit sequence
    action = "Sending start bit";
    $display(action);
    rx          = 1'b0;
    #8670ns;


    action = "Sending bit sequnce [7:0] 01010101";
    $display(action);

    for (int i = 0;i < 8; i++) begin
        rx          = ~rx;
        #8670ns;
    end
    action = "Sending stop bit";
    $display(action);
    rx              = 1'b1; 
    #8600ns;

    // Wait for a bit to settle down. Timing bit period is not 100% accurate.
    #1000ns;
    
    #100ns;
    check = "Checking bit sequence [7:0] b0101_0101, data ready, idle and no error flags";
    if (rx_data == 8'b0101_0101 && rx_data == 1'b1 && rx_idle == 1'b1 && rx_error == 1'b0) begin
        pass_cnt++;
    end
    else begin
        err_cnt++;
        $error(check);
    end
    // END TESTBLOCK

    // TESTBLOCK: sending illegal bit sequence, error at stop bit for 2 cycles
    action = "Sending start bit";
    $display(action);
    rx          = 1'b0;
    #8670ns;


    action = "Sending bit sequnce [7:0] 01010101";
    $display(action);

    for (int i = 0;i < 8; i++) begin
        rx          = ~rx;
        #8670ns;
    end
    action = "Sending stop bit";
    $display(action);
    rx              = 1'b1;
    #2000ns;
    rx              = 1'b0; // RX low for 2 cycles, error should be activated
    @(negedge clk50m);
    @(negedge clk50m);
    #8600ns;

    // Wait for a bit to settle down. Timing bit period is not 100% accurate.
    #1000ns;
    
    #100ns;
    check = "Checking illegal bit sequence data ready, idle and no error flags";
    if (rx_data == 1'b0 && rx_idle == 1'b1 && rx_error == 1'b1) begin
        pass_cnt++;
    end
    else begin
        err_cnt++;
        $error(check);
    end
    // END TESTBLOCK

    if(err_cnt > 0) begin
        $display("Passed %0d/%0d tests.", pass_cnt, pass_cnt + err_cnt);
        $display("%0d tests have failed.", err_cnt);
    end else if (err_cnt == 0) begin
        $display("All %0d tests passed.", pass_cnt);
    end 
    $display("tb_cpu finished.");
    run_sim = 0;


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