/*---------------------------------------------
Project: Hack Computer
Module: RAM16k in verilog
Purpose: Data RAM in SystemVerilog as it has a lower delay than the generated
IP
Author: Andre Mitterbacher
Version: v0, 13.05.2019
---------------------------------------------*/
module ram16k_verilog(
 // same interface as the generated RAM IP!
 input logic aclr,
 input logic [13:0] address,
 input logic clock,
 input logic [15:0] data,
 input logic wren,
 output logic [15:0] q
);
logic [15:0] mem [0:(1<<14)-1];
always_ff @ (posedge clock) begin
    // The reset branch is deleted as it is not supported by Intel FPGA RAM memory.
    /*if (aclr) begin
    mem <= '{default:'0};
    end
    else */
    if (wren) begin
        mem[address] <= data;
    end
end
assign q = mem[address];
endmodule