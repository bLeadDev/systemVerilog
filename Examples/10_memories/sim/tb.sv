

`timescale 10 ns / 10 ns

module tb();
    // (1) DUT wiring
    logic	          		CLOCK_125_p;
	logic	          		CLOCK_50_B5B;
	logic	          		CLOCK_50_B6A;
	logic	          		CLOCK_50_B7A;
	logic	          		CLOCK_50_B8A;

	//////////// LED //////////
	logic	     [7:0]		LEDG;
	logic	     [9:0]		LEDR;

	//////////// KEY //////////
	logic	          		CPU_RESET_n;
	logic	     [3:0]		KEY;
	//////////// SW //////////
    logic	     [9:0]		SW;

	//////////// SEG7 //////////
	logic	     [6:0]		HEX0;
	logic	     [6:0]		HEX1;
	logic	     [6:0]		HEX2;
	logic	     [6:0]		HEX3;

	//////////// Uart to USB //////////
	logic	          		UART_RX;
	logic	          		UART_TX;

    // (2) DUT instance
    toplevel_c5g_hex4_uart toplevel_c5g_hex4_uart(.*);

    // (3) DUT stimule
    logic run_sim = 1'b1;


    initial begin
        CLOCK_50_B5B = 1'b0;
        while (run_sim) begin
            #10ns;
            CLOCK_50_B5B = ~CLOCK_50_B5B;
        end
    end

    assign CLOCK_125_p = 1'b0;
    assign CLOCK_50_B6A = CLOCK_50_B5B;
    assign CLOCK_50_B7A = CLOCK_50_B5B;
    assign CLOCK_50_B8A = CLOCK_50_B5B;   

    initial begin
        UART_RX                     = 1'b0;
        CPU_RESET_n                 = 1'b0;
        KEY                         = '0;
        SW                          = '0;
        
        #100ns;
        KEY                         = 4'b0001;

        #1us;
        @(negedge CLOCK_50_B5B);
        SW                          = 10'd1;

        #1us;
        @(negedge CLOCK_50_B5B);
        $readmemb("rom_10bit_256_zero.txt", toplevel_c5g_hex4_uart.rom_10bit_256_u0.altsyncram_component.m_default.altsyncram_inst.mem_data);
        
        #1us;
        run_sim = 1'b0;
    end

endmodule
