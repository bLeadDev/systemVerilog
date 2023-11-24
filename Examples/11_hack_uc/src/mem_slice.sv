//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Memory cell for the outputs pins
// Author: Michael Geuze
// Version: v0
// Date: 24.11.2023
//----------------------------------------------------------

module mem_slice
#(
    parameter ADDRESS   = 15'h7000,
    parameter AW        = 15,
    parameter DW        = 16
)
(
    input       logic                   rst_n,  // active low reset
    input       logic                   clk50m, // input clock
    input       logic   [AW-1:0]        addr,   // address
    input       logic   [DW-1:0]        data_in, // data to be set
    input       logic                   we,         // write enable signal
    output      logic   [DW-1:0]        data_out    //output of data
);

always_ff @( negedge rst_n or posedge clk50m ) begin : output_reg
    if (~rst_n) begin
        data_out <= '0;
    end 
    else if (we & (addr == ADDRESS)) begin
        data_out <= data_in;
    end
end

endmodule;