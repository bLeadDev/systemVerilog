//-----------------------------------------------------
// Project: EDB HDL 7 segment display
// Purpose: Testbench for the implementation of a seven segment display
// Author:  Michael Geuze
// Version: v0 
//-----------------------------------------------------

function void display_debug_messages(int i, logic [3:0] bin_i, logic [6:0] hex_o, logic [6:0] hexn_o);
    $display("Displayed Value: %1X", i);
    $display("Binary input: %4b", bin_i);
    $display("LED Markings:                GFEDCBA");
    $display("State Output (non-inverted): %b", hex_o);
    $display("State Output (inverted):     %b", hexn_o);
    $display("-----------------------------------------------");
endfunction

module tb_sevenseg (); 
    logic [3:0] bin_i;
    logic [6:0] hex_o;
    logic [6:0] hexn_o;

    sevenseg dut (.*);  // connects all inputs to signals of the same name

    initial begin
        $display("tb_sevenseg starts now");
        bin_i = 4'd0;
        #1us;

        $display("Starting the loop");
        for (int i = 0; i < 16; i++) begin
            bin_i = i; 
            #1us;
            display_debug_messages(i, bin_i, hex_o, hexn_o);
        end
        $display("tb_sevenseg stops");
    end
endmodule