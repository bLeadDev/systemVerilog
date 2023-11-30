//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Edge detector 
// Author: Michael Geuze
// Version: v0
// Date: 20.10.2023
//-----------------.-----------------------------------------

module edge_det
(
    input       logic                   rst_n,  //active low
    input       logic                   clk,    //posedge active
    input       logic                   button,
    output      logic                   fall,
    output      logic                   rise
);

logic button_ff;

//D-FF
always_ff @(negedge rst_n or posedge clk) begin 
    // (1) async behaviour
    if (~rst_n) begin
        button_ff <= 1'b0;
    end
    else begin // (2) synchronous behaviour
        button_ff <= button;
    end
end 
    
assign fall = (button == 1'b0) && (button_ff == 1'b1);
assign rise = (button == 1'b1) && (button_ff == 1'b0);

endmodule