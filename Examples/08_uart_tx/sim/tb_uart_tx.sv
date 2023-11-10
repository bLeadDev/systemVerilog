//************************************************
//  Project: tb_uart_tx.sv
//  Purpose: Implementation of the testbench for a UART transmitter 
//  Author: Michael Geuze
//  Version: v0
//  Date: 03.11.2023
//************************************************


module tb_uart_tx();
    logic               rst_n;              //active low reset
    logic               clk;                //clock
    logic       [7:0]   tx_data;            //data payload
    logic               tx_start;           //starts data frame
    logic               tx;                 //uart tx line
    logic               tx_idle;             //indicates module is idle, new frame can be sent

    parameter           TB_BAUD        = 1_000_000;       //symbols per second
    parameter           TB_FCLK        = 50_000_000;   //clk frequency

// DUT wiring
uart_tx #(.BAUD(TB_BAUD), .FCLK(TB_FCLK)) dut ( .*);


logic run_sim = 1'b1;
int pass_cnt = 0;
int err_cnt = 0;
string action = "INIT"; //use action string to indicate the ongoing action
//can be seen in wave form

//create 50MHz clock
initial begin
    clk = 1'b0;
    while (run_sim) begin
        clk = ~clk;
        #10ns;
    end
end

initial begin
    $display("POR tb_uart_tx");
    rst_n       = 1'b0;
    tx_data     = 1'b0;
    tx_start    = 1'b0;
    #200ns;
    rst_n       = 1'b1;
    $display("Starting test procedure...");
    //send data 0xFF 
    @(negedge clk);
    tx_data     = 8'hff;
    tx_start    = 1'b1;
    @(negedge clk);
    tx_start    = 1'b0;
    @(posedge tx_idle);

    //send data 0x00
    @(negedge clk);
    tx_data     = 8'h00;
    tx_start    = 1'b1;
    @(negedge clk);
    tx_start    = 1'b0;
    @(posedge tx_idle);
  
    //send data 0xa5
    @(negedge clk);
    tx_data     = 8'ha5;
    tx_start    = 1'b1;
    @(negedge clk);
    tx_start    = 1'b0;
    @(posedge tx_idle);

    //send data 0x5a
    @(negedge clk);
    tx_data     = 8'h5a;
    tx_start    = 1'b1;
    @(negedge clk);
    tx_start    = 1'b0;
    @(posedge tx_idle);

    run_sim = 0'b0;
    $display("tb_uart_tx test finished.");
end



endmodule

