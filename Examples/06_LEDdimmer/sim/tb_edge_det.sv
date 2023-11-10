//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for edge detector
// Author: Michael Geuze
// Version: v0
// Date: 13.10.2023
//----------------------------------------------------------


module tb_edge_det();
    // (1) DUT wiring
    logic                   rst_n;  //active low
    logic                   clk;    //posedge active
    logic                   button;
    logic                   fall;
    logic                   rise;

    // (2) Place an instance of the DUT
    edge_det  dut (.*);

    logic run_sim = 1'b1;

    // (3) Stimulate the  DUT
    initial begin //clock generator
        clk = 1'b0;
        while(run_sim) begin
            #10ns;
            clk = ~clk;
        end
    end

    int pass_cnt = 0;
    int err_cnt = 0;
    initial begin
        $$display("tb_edge_det starts");
        rst_n = 1'b0;
        button = 1'b0;

        #70ns;
        $display("POR");
        rst_n = 1'b1;
        
        #1us;               // # waits for a time
        @ (negedge  clk);   // @ waits for an event
        button = 1'b1;

        if(rise) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end

        #1us;               // # waits for a time
        @ (negedge  clk);   // @ waits for an event
        button = 1'b0;

        if(fall) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end

        #1us;               // # waits for a time

        run_sim = 1'b0;
        $display("pass cnt %d", pass_cnt);
        $display("err  cnt %d", err_cnt);
        $display("tb_edge_det done");
    end


endmodule 