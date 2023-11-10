//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement a data register
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------

module dreg
#(
    parameter W = 16
)
(
    // IO ports
    input       logic                           rst_n,
    input       logic                           clk50m,
    input       logic                           en,
    input       logic                           load,
    input       logic       [W-1 : 0]           d,

    output      logic       [W-1 : 0]           q
);


always_ff @(negedge rst_n or posedge clk50m) begin 
    if (~rst_n) begin
        q <= 'd0;
    end 
    else if (load & en) begin
        q <= d;
    end
end
    
endmodule