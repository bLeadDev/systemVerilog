//----------------------------------------------------------
// Project:     EDB HDL WS2023
// Purpose:     Hack microcontroller implmentation
// Author:      Michael Geuze
// Version:     v0
// Date:        01.12.2023
//----------------------------------------------------------

module uc
#(
    parameter DW = 16,          // Width of the data path
    parameter AW = 15,          // Width of the RAM addr
    parameter PW = 15           // width of the ROM addr
)
(
    input           logic               rst_n,      // Active low reset
    input           logic               clk50m,     // Clock input 
    input           logic [DW-1:0]      reg0x7400,  // Memory mapped input (GPI)
    input           logic [DW-1:0]      reg0x7401,  // Memory mapped input (GPI)
    input           logic [DW-1:0]      reg0x7402,  // Memory mapped input (GPI)

    output          logic [DW-1:0]      reg0x7000,  // Memory mapped output (GPO)
    output          logic [DW-1:0]      reg0x7001,  // Memory mapped output (GPO)
    output          logic [DW-1:0]      reg0x7002   // Memory mapped output (GPO)
);

// ----- Interconnection wires -----
logic [PW-1:0]      pc;             // Programm counter --> Addres of ROM32k
logic [DW-1:0]      instr;          // Machine code instruction
logic               writeM;         // Write enable for the RAM 
logic [DW-1:0]      outM;           // Output from the CPU, data in at data_mem
logic [AW-1:0]      addressM;       // Output from the CPU, addr in at data_mem
logic [DW-1:0]      inM;            // Output from the data_mem, input at CPU
logic               en25m;          // Enable clock with 25MHz in the clk50m domain

// ----- submodules -----

cpu #(
    .DW(DW),               // data width
    .AW(AW),               // address width
    .PW(PW)                // program counter width
)
cpu_u0
(
    // Inputs
    .rst_n          (rst_n),            // Asynchronous reset
    .clk50m         (clk50m),           // Clock 50MHz
    .en25m          (en25m),            // Enable clock 25MHz
    .instr          (instr),            // instruction from ROM
    .inM            (inM),              // Data from RAM
    // Outputs
    .writeM         (writeM),           // Write enable for RAM
    .outM           (outM),             // Data to RAM
    .addressM       (addressM),         // Address for RAM
    .pc             (pc)                // Address for ROM instructions
);

rom32k rom32k_u0
(
	.address    (pc),
	.clock      (clk50m),
	.q          (instr)
);

data_mem #(
    .AW(AW),
    .DW(DW)
)
data_mem_u0
(
    // Inputs
    .rst_n      (rst_n),            // asynchronous reset     
    .clk50m     (clk50m),           // 50MHz clock
    .we         (writeM),           // write enable
    .data_in    (outM),             // data to be written
    .addr       (addressM),         // address to be set
    .reg0x7400  (reg0x7400),        // input from the keys
    .reg0x7401  (reg0x7401),        // input from the keys
    .reg0x7402  (reg0x7402),        // input form the keys
    // Outputs
    .reg0x7000  (reg0x7000),        // output leds
    .reg0x7001  (reg0x7001),        // output leds
    .reg0x7002  (reg0x7002),        // output leds
    .data_out   (inM)               // Data to CPU
);

// ---- generate en25m
always_ff @( negedge rst_n or posedge clk50m ) begin : en25_ff
    if (~rst_n) begin
        en25m <= 1'b0;
    end 
    else begin
        en25m <= ~en25m;
    end
end

endmodule