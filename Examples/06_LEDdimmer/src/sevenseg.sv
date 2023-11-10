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
    case (bin_i) 
        //bit representation of the LED segments
        //Segment order:     GFE_DCBA
        4'h0: hex_state = 7'b011_1111;
        4'h1: hex_state = 7'b000_0110;
        4'h2: hex_state = 7'b101_1011;
        4'h3: hex_state = 7'b100_1111;
        4'h4: hex_state = 7'b110_0110;
        4'h5: hex_state = 7'b110_1101;
        4'h6: hex_state = 7'b111_1101;
        4'h7: hex_state = 7'b000_0111;
        4'h8: hex_state = 7'b111_1111;
        4'h9: hex_state = 7'b110_1111;
        4'hA: hex_state = 7'b111_0111;
        4'hB: hex_state = 7'b111_1100;
        4'hC: hex_state = 7'b011_1001;
        4'hD: hex_state = 7'b101_1110;
        4'hE: hex_state = 7'b111_1001;
        4'hF: hex_state = 7'b111_0001;
        default: hex_state = 7'h0;
    endcase
    hex_o = hex_state;  
    hexn_o = ~hex_state;
end : sevenseg_logic

endmodule