//-----------------------------------------------------
// Project: EDB HDL
// Purpose: Implement a three bit majority voter
// Author:  Michael Geuze
// Version: v0
//-----------------------------------------------------

module tb_maj_vote (); // typ- no IOs

    // (1) Prepare the DUT wiring
    logic       x2;
    logic       x1;
    logic       x0;
    logic       y;
    logic       y2;

    // (2) Create an instance of the DUT

    /* manually done
    maj_vote        DUT
    // |             |
    // |         instance name
    // module name   |
    (
        .x2         (x2)
    //   |            |
    //   |         name in tb
    // name in submodule

    )
    */ // !manually done 

    maj_vote dut (.*);  // shortcut for TB ONLY!!
                        // connects all inputs to signals of the same name

    // (3) Stimuli for the DUT
    initial begin
        // now we are at simtime = 0
        // IMPORTANT: Init all inputs!
        $display("tb_maj_vote starts now");
        x2 = 1'b0;
        x1 = 1'b0;
        x0 = 1'b0;
        #1us;
        $display("starting the loop");
        for (int i = 0; i <= 7; i++) begin
            {x2, x1, x0} = i; //this is possible :-o
            $display("x2,x1,x0 = %d", i);
            $display("y = %d, y2 = %d", y, y2);
            #1us;
        end
        $display("tb_maj_vote stops");
    end



endmodule