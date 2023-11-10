//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: PWM Module
// Author: Michael Geuze
// Version: v0
// Date: 20.10.2023
//-----------------.-----------------------------------------

module pwm_mod #(
    parameter W_CNT = 16
)
(
    input       logic                   rst_n,  //active low reset 
    input       logic                   clk,    //posedge active
    input       logic                   en,     //increase count when enabled
    input       logic [W_CNT-1:0]       period, //period in clock cycles
    input       logic [W_CNT-1:0]       thr,    //threshold for pmw duty            
    output      logic                   q       //output
);

logic cnt [W_CNT-1:0];

always_ff @(negedge rst_n or posedge clk) begin 
    if (~rst_n) begin       // (1) async behaviour
        cnt <= '0;      	// all bits zeroed
    end
    else if (cnt >= period) begin
        cnt <= '0;
    end
    else if (en) begin      // if en and clock, add count
        cnt <= cnt + 8'd1;
    end
end

assign q = cnt < thr ? 1'b0 : 1'b1;

endmodule
