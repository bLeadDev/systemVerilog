//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement an ALU
// Author: Michael Geuze
// Version: v0
// Date: 16.10.2023
//----------------------------------------------------------

module alu 
#(
    parameter W = 16         //bit width of the data path
)
(
    // IO ports
    input       logic       [W-1 : 0]           x,
    input       logic       [W-1 : 0]           y, 
    input		logic			                zx,
    input       logic                           nx, 
    input       logic                           zy,
    input       logic                           ny,
    input       logic                           f,
    input       logic                           no,

    output      logic       [W-1 : 0]           out,
    output      logic                           zr,
    output      logic                           ng
);

logic                       [W-1:0]             x_stage[2];
logic                       [W-1:0]             y_stage[2];
logic                       [W-1:0]             out_stage[2];

// saturation 
always_comb begin 
    // Manipulating and staging inputs
    if(zx) 
        x_stage[0] = 0;
    else 
        x_stage[0] = x;

	if(nx) 
        x_stage[1] = ~x_stage[0];
    else 
        x_stage[1] = x_stage[0];

    if(zy) 
        y_stage[0] = 0;
    else 
        y_stage[0] = y;

	if(ny) 
        y_stage[1] = ~y_stage[0];
    else 
        y_stage[1] = y_stage[0];

    // Staging outputs
    if(f) 
        out_stage[0] = x_stage[1] + y_stage[1];
    else 
        out_stage[0] = x_stage[1] & y_stage[1];

    if(no) 
        out_stage[1] = ~out_stage[0];
    else 
        out_stage[1] = out_stage[0];

    // Assigning outputs
    if(out_stage[1] == '0) 
        zr = 1'b1;
    else 
        zr = 1'b0;
    
    if(out_stage[1][W-1] == 1'b1)
        ng = 1'b1;
    else 
        ng = 1'b0;

    out = out_stage[1];
end 
    
endmodule