//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Testbench for instruction decoder
// Author: Michael Geuze
// Version: v0
// Date: 07.11.2023
//----------------------------------------------------------

module tb_cpu();

    //IO Ports
        // IO ports
    logic                           rst_n,
    logic                           clk50m,
    logic                           en25m,
    logic       [DW-1 : 0]          instr,
    logic       [DW-1 : 0]          inM,

    logic                           writeM,
    logic       [DW-1 : 0]          outM,
    logic       [AW-1 : 0]          addressM,
    logic       [PW-1 : 0]          pc

    //instatiate dut
    cpu dut (.*);

    /* COPY FROM DEMUXER */
    //pack all command types 
    assign cmd_out_j        = {cmd_j1, cmd_j2, cmd_j3};
    assign cmd_out_d        = {cmd_d1, cmd_d2, cmd_d3};
    assign cmd_out_c        = {cmd_c1, cmd_c2, cmd_c3, cmd_c4, cmd_c5, cmd_c6};
    assign cmd_out_a        = cmd_a;

    //pack packed command types to full command
    assign cmd_out_chk_dc_zero          = {1'b0, 1'b0, cmd_out_a, cmd_out_c, cmd_out_d, cmd_out_j}; 
    //first two bits are dont-care bits, here set to zero
    //used to easily check for all commands to be zero

    assign cmd_out_chk_dc_one           = {1'b1, 1'b1, cmd_out_a, cmd_out_c, cmd_out_d, cmd_out_j}; 
    //first two bits are dont-care bits, here set to 1 
    //used to easily check for all commands to have the right value

    //For all c-instructions the syntax is as follows:
    //1xx_a_cccccc_ddd_jjj 
    //the dont-care-bits are always set to one as specified.

    /* CONSTANT DEFINITIONS*/
    //Define commands to be set to the input of the decoder        
    localparam logic [DW-1:0]       LOAD_MAX_VAL_TO_A                   = 16'b0111_1111_1111_1111;
    localparam logic [DW-1:0]       LOAD_ZERO_TO_A                      = 16'b0000_0000_0000_0000;
    localparam logic [DW-1:0]       SET_D_TO_ONE                        = 16'b111_0_111111_010_000;
    localparam logic [DW-1:0]       ADD_D_A_STORE_IN_D                  = 16'b111_0_000010_010_000;
    localparam logic [DW-1:0]       INC_A_STORE_IN_M                    = 16'b111_0_110111_001_000;

    //Define constants for readability; These are the values with which the outputs get tested
    localparam int                  MAX_VAL_OF_A                        = (2**15-1);                      //maximum  value of A
    localparam logic [DW-2:0]       CHK_TO_SET_D_TO_ONE                 = 15'b11_0_111111_010_000;    //Check value to set do to one
    localparam logic [DW-2:0]       CHK_TO_ADD_D_STR_D                  = 15'b11_0_000010_010_000;    //Check value to add A to D and store result in D
    localparam logic [DW-2:0]       CHK_TO_INC_A_STR_M                  = 15'b11_0_110111_001_000;    //Check value to inc a and store result in M
    localparam logic                A_INSTR                             = 1'b0;
    localparam logic                C_INSTR                             = 1'b1;
    /* ENDCOPY */
 
    string action = "Starting Testbench tb_cpu...";
    int err_cnt = 0;
    int pass_cnt = 0;

    initial begin
        $display(action);


        if(err_cnt > 0) begin
            $display("Passed %0d/%0d tests.", pass_cnt, pass_cnt + err_cnt);
            $display("%0d tests have failed.", err_cnt);
        end else if (err_cnt == 0) begin
            $display("All %0d tests passed.", pass_cnt);
        end 
        $display("tb_instr_demux finished.");
    end

endmodule