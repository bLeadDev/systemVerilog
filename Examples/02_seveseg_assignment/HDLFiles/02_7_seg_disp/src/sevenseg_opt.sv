//-----------------------------------------------------
// Project: EDB HDL 7 segment display
// Purpose: 7 segment display for assignment 1
// Author:  Michael Geuze
// Version: v0
//-----------------------------------------------------

module sevenseg (
    input           logic [3:0] bin_i ,
    output          logic [6:0] hex_o ,
    output          logic [6:0] hexn_o 
);

logic [6:0] hex_state;

always_comb begin : sevenseg_logic
    hex_state[0] = (bin_i != 4'h1) && (bin_i != 4'h4) && (bin_i != 4'hB) && (bin_i != 4'hD);
    hex_state[1] = (bin_i != 4'h5) && (bin_i != 4'h6) && (bin_i != 4'hB) && (bin_i != 4'hC) && (bin_i != 4'hE) && (bin_i != 4'hF);
    hex_state[2] = (bin_i != 4'h2) && (bin_i != 4'hC) && (bin_i != 4'hE) && (bin_i != 4'hF);
    hex_state[3] = (bin_i != 4'h1) && (bin_i != 4'h4) && (bin_i != 4'h7) && (bin_i != 4'hA) && (bin_i != 4'hF);
    hex_state[4] = (bin_i != 4'h1) && (bin_i != 4'h3) && (bin_i != 4'h4) && (bin_i != 4'h5) && (bin_i != 4'h7) && (bin_i != 4'h9);
    hex_state[5] = (bin_i != 4'h1) && (bin_i != 4'h2) && (bin_i != 4'h3) && (bin_i != 4'h7) && (bin_i != 4'hD);
    hex_state[6] = (bin_i != 4'h0) && (bin_i != 4'h1) && (bin_i != 4'h7) && (bin_i != 4'hC);
    hex_o = hex_state;  
    hexn_o = ~hex_state;
end : sevenseg_logic

endmodule