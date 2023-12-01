//----------------------------------------------------------
// Project:     EDB HDL WS2023
// Purpose:     Hack Microcontroller toplevel testbench
// Author:      Michael Geuze
// Version:     v0
// Date:        01.12.2023
//----------------------------------------------------------

`timescale 10ns/10ns

module tb_top();

// (1) DUT wiring
//// CLOCKS ///////
logic	          		CLOCK_125_p;
logic	          		CLOCK_50_B5B;
logic	          		CLOCK_50_B6A;
logic	          		CLOCK_50_B7A;
logic	          		CLOCK_50_B8A;
//// LED //////////
logic	     [7:0]		LEDG;
logic	     [9:0]		LEDR;
//// KEY //////////
logic	          		CPU_RESET_n;
logic	     [3:0]		KEY;
//// SW //////////
logic	     [9:0]		SW;
//// SEG7 //////////
logic	     [6:0]		HEX0;
logic	     [6:0]		HEX1;
logic	     [6:0]		HEX2;
logic	     [6:0]		HEX3;
//// Uart to USB //////////
logic	          		UART_RX;
logic	          		UART_TX;

// (2) DUT instance

toplevel_c5g_hex4_uart dut(.*);

int run_sim = 1;
string action = "Starting tb_top...POR";


// (3) DUT Stimuli
initial begin
    // Unused clocks, drive low
    CLOCK_125_p     = 1'b0;
    CLOCK_50_B6A    = 1'b0;
    CLOCK_50_B7A    = 1'b0;
    CLOCK_50_B8A    = 1'b0;

    CLOCK_50_B5B = 1'b0;
    while(run_sim) begin
        #10ns;
        CLOCK_50_B5B = ~CLOCK_50_B5B;
    end
end

initial begin
    CPU_RESET_n     = 1'b0;
    KEY             = '0;

    SW              = '0;
    UART_RX         = 1'b0;
    $readmemb("../asm/sum7400_7401_and_output_70000.hack", dut.uc_u0.rom32k_u0.altsyncram_component.m_default.altsyncram_inst.mem_data);

    #100ns;
    CPU_RESET_n     = 1'b1;


    #1us;
    SW              = 10'b01_0000_0001;
    #1us;
    SW              = 10'b11_0000_0011;
    #1us;

    run_sim         = 0;
end


endmodule