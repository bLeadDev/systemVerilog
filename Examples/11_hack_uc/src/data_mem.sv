//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Data memory for the hack uc
// Author: Michael Geuze
// Version: v0
// Date: 24.11.2023
//----------------------------------------------------------

module data_mem #(
    parameter AW = 15,
    parameter DW = 16
)
(
    input           logic               rst_n,      // asynchronous reset     
    input           logic               clk50m,     // 50MHz clock
    input           logic               we,         // write enable
    input           logic  [DW-1 : 0]   data_in,    // data to be written
    input           logic  [AW-1 : 0]   addr,        // address to be set
    input           logic  [DW-1 : 0]   reg0x7400,   // input from the keys
    input           logic  [DW-1 : 0]   reg0x7401,   // input from the keys
    input           logic  [DW-1 : 0]   reg0x7402,   // input form the keys

    output          logic  [DW-1 : 0]   reg0x7000,  // output leds
    output          logic  [DW-1 : 0]   reg0x7001,  // output leds
    output          logic  [DW-1 : 0]   reg0x7002,  // output leds
    output          logic  [DW-1 : 0]   data_out
);


// define address space constants
localparam RAM_START        = 15'h0000;
localparam RAM_END          = 15'h3FFF;

// genereate the wr_en signalf for all submodules

logic wren_ram16k;
logic [DW-1:0] data_out_ram16k;

assign wren_ram16k = we & (addr >= RAM_START) & (addr <= RAM_END);  

// submodules
ram16k ram16k_u0
(
	.aclr       (~rst_n),
	.address    (addr[13:0]),
	.clock      (clk50m),
	.data       (data_in),
	.wren       (wren_ram16k),
	.q          (data_out_ram16k)
);

mem_slice #(.ADDRESS(15'h7000), .AW(AW), .DW(DW)) mem_slice_0x7000
(
    .rst_n      (rst_n),  
    .clk50m     (clk50m), 
    .addr       (addr),   
    .data_in    (data_in), 
    .we         (we),     
    .data_out   (reg0x7000)
);

mem_slice #(.ADDRESS(15'h7001), .AW(AW), .DW(DW)) mem_slice_0x7001
(
    .rst_n      (rst_n),  
    .clk50m     (clk50m), 
    .addr       (addr),   
    .data_in    (data_in), 
    .we         (we),     
    .data_out   (reg0x7001)
);

mem_slice #(.ADDRESS(15'h7002), .AW(AW), .DW(DW)) mem_slice_0x7002
(
    .rst_n      (rst_n),  
    .clk50m     (clk50m), 
    .addr       (addr),   
    .data_in    (data_in), 
    .we         (we),     
    .data_out   (reg0x7002)
);

// Output muxer
always_comb begin : data_out_mux

    if ( (addr >= RAM_START) & (addr <= RAM_END)) begin
        data_out = data_out_ram16k;
    end
    // Output registers 
    else if (addr == 15'h7000) begin
        data_out = reg0x7000;
    end
    else if (addr == 15'h7001) begin
        data_out = reg0x7001;
    end
    else if (addr == 15'h7002) begin
        data_out = reg0x7002;
    end 
    // input registers
    else if (addr == 15'h7400) begin
        data_out = reg0x7400;
    end
    else if (addr == 15'h7401) begin
        data_out = reg0x7401;
    end
    else if (addr == 15'h7402) begin
        data_out = reg0x7402;
    end
    else begin
        data_out = '0;
    end
end

endmodule;