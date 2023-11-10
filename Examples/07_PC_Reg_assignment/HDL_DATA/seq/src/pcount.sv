//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement a program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------

module pcount
#(
    parameter W = 15
)
(
    // IO ports
    input       logic                           rst_n,
    input       logic                           clk50m,
    input       logic                           en,
    input       logic                           load,
    input       logic                           inc,
    input       logic       [W-1 : 0]           cnt_in,

    output      logic       [W-1 : 0]           cnt
);

always_ff @(negedge rst_n or posedge clk50m) begin 
    if (~rst_n) begin
        cnt <= 'd0;
    end 
    else if (load & en) begin
        cnt <= cnt_in;
    end
    else if (inc & en) begin
        cnt <= cnt + W'(8'd1);
    end
end
    
endmodule