
module lut_1596 (
    input           logic [3:0] x ,
    output          logic       y 
);

always_comb begin : sevenseg_logic
    case (x) 
        4'h4: y = 1'b1;
        4'h8: y = 1'b1;
        4'hA: y = 1'b1;
        default: y = 1'b0;
    endcase
end 

endmodule