//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Testbench for the data memory module
// Author: Michael Geuze
// Version: v0
// Date: 24.11.2023
//----------------------------------------------------------

`timescale 10 ns / 10 ns

module tb_data_mem();
    localparam AW = 15;
    localparam DW = 16;

// TEST STEPS
// 1) R and W RAM
// 2) R and W outputs
// 3) R inputs

// DUT wiring
    logic               rst_n;      // asynchronous reset     
    logic               clk50m;     // 50MHz clock
    logic               we;         // write enable
    logic  [DW-1 : 0]   data_in;    // data to be written
    logic  [AW-1 : 0]   addr;       // address to be set
    logic  [DW-1 : 0]   reg0x7400;  // input from the keys
    logic  [DW-1 : 0]   reg0x7401;  // input from the keys
    logic  [DW-1 : 0]   reg0x7402;  // input form the keys  
    logic  [DW-1 : 0]   reg0x7000;  // output leds
    logic  [DW-1 : 0]   reg0x7001;  // output leds
    logic  [DW-1 : 0]   reg0x7002;  // output leds
    logic  [DW-1 : 0]   data_out;

data_mem #(.AW(AW), .DW(DW)) dut (.*);

int run_sim = 1;

initial begin
    clk50m = 1'b0;
    while (run_sim) begin
        #10ns;
        clk50m = ~clk50m;
    end
end

int err_cnt = 0;
int pass_cnt = 0;

string action = "POR";
initial begin
    rst_n       = 1'b0;
    we          = 1'b0;
    data_in     = '0;
    addr        = '0;
    reg0x7400   = '0; 
    reg0x7401   = '0;
    reg0x7402   = '0;
    #100ns;
    rst_n       = 1'b1;
    action = "POR done";
    $display(action);
    #100ns;
    action = "write to ram";
    $display(action);
    for (int i = 0; i < 16; i++) begin
        @(negedge clk50m);
        addr = i;
        data_in = 100+i;
        we = 1'b1;
    end
    @(negedge clk50m); // write last val
    action = "read from ram";
    $display(action);
    we = 1'b0;
    for (int i = 0; i < 16; i++) begin
        @(negedge clk50m);
        addr = i;
        @(negedge clk50m);
        @(negedge clk50m);
        if (data_out != 100+i) begin
            err_cnt++;
            $error(action);
            $error("Read at addr %h, value was %h, should be %h", i, data_out, 100 + i);
        end 
        else begin
            pass_cnt++;
            $display("Pass at addr %d", i);
        end
    end
    $display("Testing RAM done!");

    $display("Testing outputs");
    action = "write to outputs";
    $display(action);
    we = 1'b1;
    addr = 15'h7000;
    data_in = 16'd100;
    @(negedge clk50m);
    we = 1'b1;
    addr = 15'h7001;
    data_in = 16'd101;
    @(negedge clk50m);
    we = 1'b1;
    addr = 15'h7002;
    data_in = 16'd102;
    @(negedge clk50m);

    action = "read from outputs";
    $display(action);
    we = 1'b0;
    addr = 15'h7000;
    @(negedge clk50m);
    if (data_out != 16'd100) begin
        err_cnt++;
        $error(action);
    end
    else begin
        pass_cnt++;
        $display("Passed test");
    end

    @(negedge clk50m);
    addr = 15'h7001;
    @(negedge clk50m);
    if (data_out != 16'd101) begin
        err_cnt++;
        $error(action);
    end
    else begin
        pass_cnt++;
        $display("Passed test");
    end

    @(negedge clk50m);
    addr = 15'h7002;
    @(negedge clk50m);
    if (data_out != 16'd102) begin
        err_cnt++;
        $error(action);
    end
    else begin
        pass_cnt++;
        $display("Passed test");
    end
    @(negedge clk50m);

    $display("Testing outputs done!");

    $display("Read inputs");
    action = "reading from inputs";
    $display(action);
    @(negedge clk50m);
    we = 1'b1;
    addr = 15'h7400;
    for (int i = 0; i < 16; i++) begin
        reg0x7400 = i + 5;
        @(negedge clk50m);
        if (data_out != i + 5) begin
            err_cnt++;
            $error(action);
        end 
        else begin
            $display("Pass at val %d", i);
        end
    end
    addr = 15'h7401;
    we = 1'b1;
    for (int i = 0; i < 16; i++) begin
        reg0x7401 = i + 5;
        @(negedge clk50m);
        if (data_out != i + 5) begin
            err_cnt++;
            $error(action);
        end 
        else begin
            $display("Pass at val %d", i);
        end
    end
    addr = 15'h7402;
    for (int i = 0; i < 16; i++) begin
        reg0x7402 = i + 5;
        @(negedge clk50m);
        if (data_out != i + 5) begin
            err_cnt++;
            $error(action);
        end 
        else begin
            $display("Pass at val %d", i);
        end
    end

    $display("Testing outputs done!");

    if(err_cnt > 0) begin
        $display("Passed %0d/%0d tests.", pass_cnt, pass_cnt + err_cnt);
        $display("%0d tests have failed.", err_cnt);
    end else if (err_cnt == 0) begin
        $display("All %0d tests passed.", pass_cnt);
    end 
    $display("tb_cpu finished.");
    run_sim = 0;

end

endmodule