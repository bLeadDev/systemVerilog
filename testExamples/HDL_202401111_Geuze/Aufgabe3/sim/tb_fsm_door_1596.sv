//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------


module tb_fsm_door_1596();

    // (1) DUT wiring

    logic               rst_n;              //active low reset
    logic               clk2m;
    logic               key_up;
    logic               key_down;
    logic               sense_up;
    logic               sense_down;

    logic               ml;                 
    logic               mr;          
    logic               light_red;               
    logic               light_green;


    // (2) Place an instance of the DUT
    fsm_door_1596  dut (.*);

    logic run_sim = 1'b1;

    initial begin //clock generator
        clk2m = 1'b0;
        while(run_sim) begin
            #250ns;
            clk2m = ~clk2m;
        end
    end

    int pass_cnt = 0;
    int err_cnt = 0;

    initial begin
        $display("tb_fsm_door_1596 starts");
        rst_n       = 1'b0;
        key_up      = 1'b0;
        key_down    = 1'b0;
        sense_up    = 1'b0;
        sense_down  = 1'b0;
        
        #70ns;
        $display("POR");
        rst_n = 1'b1;

        #1us;              
        // State is unknown, no Light and no motor should be active.
        key_up      = 1'b1;
        #1us;
        key_up      = 1'b0;
        #1us;
        sense_up    = 1'b1;
        #1us;
        key_down    = 1'b1;
        #1us;
        key_down    = 1'b0;
        sense_up    = 1'b0;
        #1us;
        sense_down  = 1'b1;

        #1us;               

        run_sim = 1'b0;

        $display("tb_fsm_door_1596 finished.");
    end
endmodule 