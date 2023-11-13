
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

`timescale 10 ns / 10 ns

module toplevel_c5g_hex4_uart(

	//////////// CLOCK //////////
	input 	logic	          		CLOCK_125_p,
	input 	logic	          		CLOCK_50_B5B,
	input 	logic	          		CLOCK_50_B6A,
	input 	logic	          		CLOCK_50_B7A,
	input 	logic	          		CLOCK_50_B8A,

	//////////// LED //////////
	output	logic	     [7:0]		LEDG,
	output	logic	     [9:0]		LEDR,

	//////////// KEY //////////
	input 	logic	          		CPU_RESET_n,
	input 	logic	     [3:0]		KEY,

	//////////// SW //////////
	input 	logic	     [9:0]		SW,

	//////////// SEG7 //////////
	output	logic	     [6:0]		HEX0,
	output	logic	     [6:0]		HEX1,
	output	logic	     [6:0]		HEX2,
	output	logic	     [6:0]		HEX3,

	//////////// Uart to USB //////////
	input 	logic	          		UART_RX,
	output	logic	          		UART_TX
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

logic clk;
logic rst_n;
logic [2:0] speed;
logic clk_en;
logic [7:0]address;

assign clk 		=  CLOCK_50_B5B;
assign rst_n 	= KEY[0]; 
assign speed	= SW[2:0];

//=======================================================
//  Structural coding
//=======================================================

rom_10bit_256 rom_10bit_256_u0(
	.address		(address),
	.clock			(clk),
	.q				(LEDR)
);    

prescaler	prescaler_u0(
	.rst_n	(rst_n),
    .clk	(clk),
    .speed	(speed),
    .clk_en (clk_en)
);

addr_cnt addr_cnt(
	.rst_n	(rst_n),
	.clk	(clk), 
	.en		(clk_en),
	.addr	(address)
);

	assign LEDG         = '0;
    assign HEX0         = '1;      
    assign HEX1         = '1;      
    assign HEX2         = '1;      
    assign HEX3         = '1;      
    assign UART_TX      = '0;   

endmodule