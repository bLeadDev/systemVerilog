//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Up Down Counter 
// Author: Michael Geuze
// Version: v0
// Date: 20.10.2023
//-----------------.-----------------------------------------

module updncnt
(
    input       logic                   rst_n,  //active low
    input       logic                   clk,    //posedge active
    input       logic                   inc,    //increase count
    input       logic                   dec,    //decrease count
    output      logic [7:0]             cnt     //counting output
);

//D-FF
always_ff @(negedge rst_n or posedge clk) begin 
    // (1) async behaviour
    if (~rst_n) begin
        cnt <= '0; // all bits zeroed
    end
    else if (inc) begin // (2) synchronous behaviour, higher priority 
        cnt <= cnt + 8'd1;
    end
    else if (dec) begin // synchronous, low prio
        cnt <= cnt - 8'd1;
    end
end 

endmodule