//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Wiring for the CPU with all modules
// Author: Michael Geuze
// Version: v0
// Date: 07.11.2023
//----------------------------------------------------------

module cpu#(
    parameter DW = 16,               // data width
    parameter AW = 15,               // address width
    parameter PW = 15                // program counter width
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
// Used most of the outputs defined in the module name. Module name is comment.  
// From instruction demuxer
logic                           instr_type;
logic       [DW-1 : 0]          instr_v;
logic                           cmd_a;
logic                           cmd_c1;
logic                           cmd_c2;
logic                           cmd_c3;
logic                           cmd_c4;
logic                           cmd_c5;
logic                           cmd_c6;
logic                           cmd_d1;
logic                           mload;  //name changed
logic                           dload;  //name changed
logic                           cmd_j1;
logic                           cmd_j2;
logic                           cmd_j3;
// pcount
logic                           aload;
// a reg
logic       [DW-1 : 0]          a;
logic       [DW-1 : 0]          ad;
// d reg
logic       [DW-1 : 0]          d;
// alu
logic       [DW-1 : 0]          y;
logic       [DW-1 : 0]          alu_out;
logic                           alu_zr;
logic                           alu_ng;
// jmp ctrl
logic                           pc_load;
logic                           pc_inc;
// misc
logic       [DW-1 : 0]          m;



/* INSTANTIATE AND INTERCONNECT ALL MODULES*/
alu #(.W(16)) alu_u1 (
    // inputs
    .x(d),
    .y(y),
    .zx(cmd_c1),
    .nx(cmd_c2), 
    .zy(cmd_c3),
    .ny(cmd_c4),
    .f(cmd_c5),
    .no(cmd_c6),
    // outputs
    .out(alu_out),
    .zr(alu_zr),
    .ng(alu_ng)
); 

dreg #(.W(16)) a_u1 (
    // inputs
    .rst_n(rst_n),
    .clk50m(clk50m),
    .en(en25m),
    .load(aload),
    .d(ad),
    // outputs
    .q(a)
);

dreg #(.W(16)) d_u1 (
    // inputs
    .rst_n(rst_n),
    .clk50m(clk50m),
    .en(en25m),
    .load(dload),
    .d(alu_out),
    // outputs
    .q(d)
);

pcount #(.W(15)) pcount_u1(
    // inputs
    .rst_n(rst_n),
    .clk50m(clk50m),
    .en(en25m),
    .load(pc_load),
    .inc(pc_inc),
    .cnt_in(a[PW-1:0]),
    // outputs
    .cnt(pc)
);

// no width defined here; standard is used
instr_demux instr_demux_u1(
    // inputs
    .instr(instr),
    // outputs
    .instr_type(instr_type),
    .instr_v(instr_v),
    .cmd_a(cmd_a),
    .cmd_c1(cmd_c1),
    .cmd_c2(cmd_c2),
    .cmd_c3(cmd_c3),
    .cmd_c4(cmd_c4),
    .cmd_c5(cmd_c5),
    .cmd_c6(cmd_c6),
    .cmd_d1(cmd_d1),
    .cmd_d2(dload),
    .cmd_d3(mload),
    .cmd_j1(cmd_j1),
    .cmd_j2(cmd_j2),
    .cmd_j3(cmd_j3)
);

jmp_ctrl jmp_ctrl_u1(
    // inputs
    .j1(cmd_j1),
    .j2(cmd_j2),
    .j3(cmd_j3),
    .neg(alu_ng),
    .zero(alu_zr),
    // outputs
    .pc_load(pc_load),
    .pc_inc(pc_inc)
);

// Output assignments
assign outM         = alu_out;
assign addressM     = a;
assign writeM       = mload;
// Input assignments
assign m            = inM;
// Muxer in CPU
assign aload        = (instr_type   == 1'b1) ? cmd_d1   : 1'b1;
assign ad           = (instr_type   == 1'b1) ? alu_out  : instr_v;
assign y            = (cmd_a        == 1'b1) ? m        : a;

endmodule