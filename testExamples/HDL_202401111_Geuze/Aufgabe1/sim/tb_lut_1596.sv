//-----------------------------------------------------
// Project: EDB HDL 7 segment display
// Purpose: Testbench for the implementation of a seven segment display
// Author:  Michael Geuze
// Version: v0 
//-----------------------------------------------------


module tb_lut_1596 (); 
    logic [3:0] x;
    logic       y:

    lut_1596 dut (.*);  // connects all inputs to signals of the same name

    int pass_cnt = 0;
    int err_cnt = 0;

    initial begin
        $display("tb_lut_1596 starting...");
        x = '0;
        #1us;

        $display("Starting the loop");
        for (int i = 0; i < 16; i++) begin
            x = i; 
            #1us;
            if (x == 4'h4 || x == 4'h8 || x == 4'hA) begin
                // y must be one
                if (y == 1'b1)
                    pass_cnt++;
                else
                    err_cnt++;
            end
            else begin
                // y must be zero
                if (y == 1'b0)
                    pass_cnt++;
                else
                    err_cnt++;
            end
        end
        $display("tb_lut_1596 stops");
        $display("Test report:");
        if (err_cnt) begin
            $display("Passed %0d of %0d tests", pass_cnt, pass_cnt + err_cnt);
            $display("%0d tests have failed", err_cnt);
        end
        else begin
            $display("Passed all %0d tests", pass_cnt);
        end
    end
endmodule