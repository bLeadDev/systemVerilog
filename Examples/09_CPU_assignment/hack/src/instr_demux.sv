//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement instruction decoder
// Author: Michael Geuze
// Version: v0
// Date: 07.11.2023
//----------------------------------------------------------

module instr_demux
#(
    parameter DW = 16         //bit width of the instruction
)
(
    // IO ports
    input       logic       [DW-1 : 0]          instr,

    output      logic                           instr_type,
    output      logic       [DW-1 : 0]          instr_v,
    output      logic                           cmd_a,
    output      logic                           cmd_c1,
    output      logic                           cmd_c2,
    output      logic                           cmd_c3,
    output      logic                           cmd_c4,
    output      logic                           cmd_c5,
    output      logic                           cmd_c6,
    output      logic                           cmd_d1,
    output      logic                           cmd_d2,
    output      logic                           cmd_d3,
    output      logic                           cmd_j1,
    output      logic                           cmd_j2,
    output      logic                           cmd_j3
);

const bit A_INSTR = 1'b0;
const bit C_INSTR = 1'b1;

always_comb begin 
    instr_type              = instr[DW-1];
    instr_v [DW-1]          = 1'b0;
    instr_v [DW-2:0]        = instr[DW-2:0];
    if (instr_type == C_INSTR) begin
        cmd_j3              = instr[0];
        cmd_j2              = instr[1];
        cmd_j1              = instr[2];
        cmd_d3              = instr[3];
        cmd_d2              = instr[4];
        cmd_d1              = instr[5];
        cmd_c6              = instr[6];
        cmd_c5              = instr[7];
        cmd_c4              = instr[8];
        cmd_c3              = instr[9];
        cmd_c2              = instr[10];
        cmd_c1              = instr[11];
        cmd_a               = instr[12];
    end
    else begin
        cmd_j3              = 1'b0;
        cmd_j2              = 1'b0;
        cmd_j1              = 1'b0;
        cmd_d3              = 1'b0;
        cmd_d2              = 1'b0;
        cmd_d1              = 1'b0;
        cmd_c6              = 1'b0;
        cmd_c5              = 1'b0;
        cmd_c4              = 1'b0;
        cmd_c3              = 1'b0;
        cmd_c2              = 1'b0;
        cmd_c1              = 1'b0;
        cmd_a               = 1'b0;
    end
end 
    
endmodule