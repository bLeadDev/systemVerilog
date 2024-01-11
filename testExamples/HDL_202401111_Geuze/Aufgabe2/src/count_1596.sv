//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement a program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------

module count_1596
(
    // IO ports
    input       logic                           rst_n,
    input       logic                           clk5m,
    input       logic                           en,
    input       logic                           load,
    input       logic                           updn,
    input       logic       [9 : 0]             data_in,

    output      logic       [9 : 0]             cnt
);

always_ff @(negedge rst_n or posedge clk5m) begin 
    if (~rst_n) begin
        cnt <= 'd0;
    end 
    else if (load) begin
        cnt <= data_in;
    end
    else if (updn == 0 & en) begin
        cnt <= cnt + 10'd1;
    end
    else if (updn == 1 & en) begin
        cnt <= cnt - 10'd1;
    end
end
    
endmodule