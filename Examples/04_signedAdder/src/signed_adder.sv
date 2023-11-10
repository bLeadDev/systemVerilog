//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement an unsigned adder
// Author: Michael Geuze
// Version: v0
// Date: 13.10.2023
//----------------------------------------------------------

module adder_u 
#(
    parameter W = 8        //bit width of the data path
)
(
    // IO ports
    input       logic       [W-1 : 0]           x_i,
    input       logic       [W-1 : 0]           y_i,
    output      logic       [W-1 : 0]           sum_o,
    output      logic                           of_o
);

// increase the width by one for OF detection
logic [W : 0]                       x_ext; 
logic [W : 0]                       y_ext; 
logic [W : 0]                       sum_ext; 

assign x_ext = {1'b0, x_i};        //concatenate 0 and x in
assign y_ext = {1'b0, y_i};        //concatenate 0 and y in

assign sum_ext = x_ext + y_ext;

// saturation 
always_comb begin 
    if(sum_ext[W]) begin
        of_o = 1'b1;                // flag OF
        sum_o = '1;                 // saturate the output
    end
    else begin
        of_o = 1'b0;
        sum_o = sum_ext[W-1:0];
    end
end 
    

// Implementation of the adder
// assign sum_o = x_i + y_i; //without OF detection

endmodule