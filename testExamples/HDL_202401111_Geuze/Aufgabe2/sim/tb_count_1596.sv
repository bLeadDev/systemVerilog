//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------


module tb_count_1596();

    // (1) DUT wiring
    logic                           rst_n;
    logic                           clk5m;
    logic                           en;
    logic                           load;
    logic                           updn;
    logic       [9 : 0]             data_in;
    logic       [9 : 0]             cnt;

    // (2) Place an instance of the DUT
    count_1596  dut (.*);

    logic run_sim = 1'b1;

    initial begin //clock generator
        clk5m = 1'b0;
        while(run_sim) begin
            #100ns;
            clk5m = ~clk5m;
        end
    end

    int pass_cnt = 0;
    int err_cnt = 0;

    initial begin
        $display("tb_count_1596 starts");
        rst_n       = 1'b0;
        en          = 1'b0;
        updn        = 1'b0;
        load        = 1'b0;
        data_in     = '0;

        #70ns;
        $display("POR");
        rst_n = 1'b1;

        #100ns;               // # waits for a time
        en = 1'b1;             // enable counter
        for (int i = 0; i < 16; i ++) begin
            @(negedge clk5m); // count up to 15
        end

        updn = 1'b1;
        for (int i = 0; i < 15; i ++) begin
            @(negedge clk5m); // count down to 0
        end
        
        en = 1'b0;
        for (int i = 0; i < 16; i ++) begin
            @(negedge clk5m); // do not count
        end

        data_in = 10'd42;
        load = 1'b1;
        @(negedge clk5m); // load 42 into counter

        load = 1'b0;
        en = 1'b1;
        for (int i = 0; i < 16; i ++) begin
            @(negedge clk5m); // go down from 42 
        end

        #50ns;               

        run_sim = 1'b0;

        $display("tb_count_1596 finished.");
    end
endmodule 