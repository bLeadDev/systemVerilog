//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Wiring for the CPU with all modules
// Author: Michael Geuze
// Version: v0
// Date: 07.11.2023
//----------------------------------------------------------

module cpu#(
    parameter DW = 16,               //data width
    parameter AW = 15,               //address width
    parameter PW = 15                //program counter width
)
(
    // IO ports
    input       logic                           rst_n,
    input       logic                           clk50m,
    input       logic                           en25m,
    input       logic       [DW-1 : 0]          instr,
    input       logic       [DW-1 : 0]          inM,
    
    output      logic                           writeM,
    output      logic       [DW-1 : 0]          outM,
    output      logic       [AW-1 : 0]          addressM,
    output      logic       [PW-1 : 0]          pc
);

/* DEFINING WIRES */


/* INSTANTIATE ALL MODULES*/
alu #(.W(16)) alu (
    //inputs

    //outputs
); 

dreg #(.W(16)) a (
    //inputs

    //outputs
);

dreg #(.W(16)) d (
    //inputs

    //outputs
);

pcount #(.W(15)) pcount(
    //inputs

    //outputs
);

//no width defined here; standard is used
instr_demux instr_demux(
    //inputs
    .instr(instr),
    //outputs

);

jmp_ctrl jmp_ctrl(
    //inputs

    //outputs

);


endmodule