//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Testbench for cpu
// Author: Michael Geuze
// Version: v0
// Date: 07.11.2023
//----------------------------------------------------------

module tb_cpu();
    localparam DW = 16;
    localparam AW = 15;
    localparam PW = 15;
    
    //IO Ports
    logic                           rst_n;
    logic                           clk50m;
    logic                           en25m;
    logic       [DW-1 : 0]          instr;
    logic       [DW-1 : 0]          inM;

    logic                           writeM;
    logic       [DW-1 : 0]          outM;
    logic       [AW-1 : 0]          addressM;
    logic       [PW-1 : 0]          pc;

    //instatiate dut
    cpu dut (.*);

    //For all c-instructions the syntax is as follows:
    //1xx_a_cccccc_ddd_jjj 
    //the dont-care-bits are always set to one as specified.

    /* CONSTANT DEFINITIONS*/
    //Define commands to be set to the input of the decoder        
    localparam logic [DW-1:0]       LOAD_MAX_VAL_TO_A                   = 16'b0111_1111_1111_1111;
    localparam logic [DW-1:0]       LOAD_ZERO_TO_A                      = 16'b0000_0000_0000_0000;
    localparam logic [DW-1:0]       LOAD_42_TO_A                        = 16'b0000_0000_0010_1010;
    localparam logic [DW-1:0]       SET_D_TO_ONE                        = 16'b111_0_111111_010_000;
    localparam logic [DW-1:0]       ADD_D_A_STORE_IN_D                  = 16'b111_0_000010_010_000;
    localparam logic [DW-1:0]       INC_A_STORE_IN_M                    = 16'b111_0_110111_001_000;

    //Define check constants
    localparam int                  MAX_VAL_OF_A                        = (2**15-1);   

    string action = "Starting Testbench tb_cpu...";
    int err_cnt = 0;
    int pass_cnt = 0;
    int run_sim = 1;

    initial begin
        rst_n = 1'b1;
        instr = '0;
        inM = '0;

        $display(action);
        #10ns;
        action = "Initiating POR";
        $display(action);
        rst_n = 1'b0;
        #40ns;
        rst_n = 1'b1;
        #40ns;

/* TEST BLOCK */
        action = "LOAD_MAX_VAL_TO_A";
        @(negedge en25m);
        $display(action);
        instr = LOAD_MAX_VAL_TO_A;
        @(negedge en25m);
        if (dut.a_u1.q  == MAX_VAL_OF_A && writeM == 1'b0) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/
/* TEST BLOCK */
        action = "LOAD_ZERO_TO_A";
        @(negedge en25m);
        $display(action);
        instr = LOAD_ZERO_TO_A;
        @(negedge en25m);
        if (dut.a_u1.q  == '0 && writeM == 1'b0) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/
/* TEST BLOCK */
        action = "LOAD_42_TO_A";
        @(negedge en25m);
        $display(action);
        instr = LOAD_42_TO_A;
        @(negedge en25m);
        if (dut.a_u1.q  == 16'd42 && writeM == 1'b0) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/
/* TEST BLOCK */
        action = "SET_D_TO_ONE";
        @(negedge en25m);
        $display(action);
        instr = SET_D_TO_ONE;
        @(negedge en25m);
        if (dut.d_u1.q  == 16'd1 && writeM == 1'b0) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/
/* TEST BLOCK */
        action = "ADD_D_A_STORE_IN_D";
        @(negedge en25m);
        $display(action);
        instr = ADD_D_A_STORE_IN_D;
        @(negedge en25m);
        if (dut.d_u1.q  == 16'd43 && writeM == 1'b0) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/
/* TEST BLOCK */
        action = "INC_A_STORE_IN_M";
        @(negedge en25m);
        $display(action);
        instr = INC_A_STORE_IN_M;
        @(negedge en25m);
        if (dut.outM  == 16'd43 && writeM == 1'b1) begin
            pass_cnt++;
        end else begin
            err_cnt++;
            $error(action);
        end
        @(negedge en25m);
/* BLOCK END*/

        if(err_cnt > 0) begin
            $display("Passed %0d/%0d tests.", pass_cnt, pass_cnt + err_cnt);
            $display("%0d tests have failed.", err_cnt);
        end else if (err_cnt == 0) begin
            $display("All %0d tests passed.", pass_cnt);
        end 
        $display("tb_cpu finished.");
        run_sim = 0;
    end
// Clock generation
    initial begin
        clk50m = 1'b0;
        while (run_sim) begin
            clk50m = ~clk50m;
            #10ns;
        end
    end

    initial begin
        en25m = 1'b0;
        while (run_sim) begin
            en25m = ~en25m;
            #20ns;
        end
    end


endmodule