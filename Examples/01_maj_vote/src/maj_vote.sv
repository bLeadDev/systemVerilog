//-----------------------------------------------------
// Project: EDB HDL
// Purpose: Implement a three bit majority voter
// Author:  Michael Geuze
// Version: v0
//-----------------------------------------------------

module maj_vote (
    // IO list starts here
    input   logic       x2,
    input   logic       x1,
    input   logic       x0,
    output  logic       y,
    output  logic       y2
);
    
// --- Implement our manually derived solution ---
assign y = (x0 & x1) | (x2 & x0) | (x2 & x1); // assign is for low level description

// --- Implement on a higher level of abstraction
// --> Its combinatorial logic, --> always_comb

// Declare a three bit wide bus
logic [2:0] xbus;
// Connect the lines to the bus
assign xbus = {x2, x1, x0};

always_comb begin : optional_name
    // inside the always we can use if, case, ...
    //y2 = 1'b0; //or like this
    case (xbus) 
        3'b011: begin
            y2 = 1'b1;
        end
        3'b101: begin
            y2 = 1'b1;
        end
        3'b110: begin
            y2 = 1'b1;
        end
        3'b111: begin
            y2 = 1'b1;
        end
        default: begin    
            y2 = 1'b0;
        end
    endcase
    
end : optional_name
 
endmodule