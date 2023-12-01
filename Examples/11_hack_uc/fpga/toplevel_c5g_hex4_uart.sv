
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

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
logic [3:0] 	BIN0;
logic [3:0] 	BIN1;
logic [3:0] 	BIN2;
logic [3:0] 	BIN3;
logic [15:0]	reg0x7000;
logic [15:0]	reg0x7001;
logic [15:0]	reg0x7002;
logic [15:0]	reg0x7400;
logic [15:0]	reg0x7401;
logic [15:0]	reg0x7402;
logic 			rst_n;
logic 			clk50m;


//=======================================================
//  Structural coding
//=======================================================
assign rst_n 		= CPU_RESET_n;
assign clk50m		= CLOCK_50_B5B;
assign reg0x7400	= {8'd0, 	SW[7:0]};
assign reg0x7401	= {14'd0,	SW[9:8]};
assign reg0x7402	= {12'd0,	KEY};

assign LEDG 										= reg0x7000[7:0];
assign LEDR 										= {reg0x7001[1:0], reg0x7000[15:8]};
assign {BIN3[3:0], BIN2[3:0], BIN1[3:0], BIN0[3:0]}	= reg0x7002;

// Drive uart_tx 
assign UART_TX		= 1'b1;

uc uc_u0
(
    .rst_n			(rst_n),      				// Active low reset
    .clk50m			(clk50m),     				// Clock input 
    .reg0x7400		(reg0x7400),  						// Memory mapped input (GPI)
    .reg0x7401		(reg0x7401),  						// Memory mapped input (GPI)
    .reg0x7402		(reg0x7402),  						// Memory mapped input (GPI)
	
    .reg0x7000		(reg0x7000),  						// Memory mapped output (GPO)
    .reg0x7001		(reg0x7001),  						// Memory mapped output (GPO)
    .reg0x7002		(reg0x7002)   						// Memory mapped output (GPO)
);

sevenseg sevenseg0(
    .bin_i  (BIN0),
    .hex_o  (),
    .hexn_o (HEX0)
);

sevenseg sevenseg1(
    .bin_i  (BIN1),
    .hex_o  (),
    .hexn_o (HEX1)
);

sevenseg sevenseg2(
    .bin_i  (BIN2),
    .hex_o  (),
    .hexn_o (HEX2)
);

sevenseg sevenseg3(
    .bin_i  (BIN3),
    .hex_o  (),
    .hexn_o (HEX3)
);

endmodule
