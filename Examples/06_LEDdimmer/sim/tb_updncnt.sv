//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for edge detector
// Author: Michael Geuze
// Version: v0
// Date: 13.10.2023
//----------------------------------------------------------


module tb_updncnt();
    // (1) DUT wiring
    logic                   rst_n;  //active low
    logic                   clk;    //posedge active
    logic [7:0]             cnt;     //counting output

    logic                   key0;
    logic                   key1;
    logic                   fall0;
    logic                   fall1;

    // (2) Place an instance of the DUT
    updncnt  updncnt_dut_u1 (
        .rst_n      (rst_n),
        .clk        (clk),
        .inc        (fall0),
        .dec        (fall1),
        .cnt        (cnt)
        );

    edge_det edge_det_u0(
        .rst_n      (rst_n),
        .clk        (clk),
        .button     (key0),
        .fall       (fall0),
        .rise       ()      //n.c.
    );

    edge_det edge_det_u1(
        .rst_n      (rst_n),
        .clk        (clk),
        .button     (key1),
        .fall       (fall1),
        .rise       ()      //n.c.
    );

    logic run_sim = 1'b1;

    // (3) Stimulate the  DUT
    initial begin //clock generator
        clk = 1'b0;
        while(run_sim) begin
            #10ns;
            clk = ~clk;
        end
    end 

    initial begin
        $$display("tb_updncnt starts");
        rst_n       = 1'b0;
        key0        = 1'b1;
        key1        = 1'b1;

        #70ns;
        $display("POR");
        rst_n = 1'b1;
        
        #1us;               // # waits for a time
        // @ waits for an event
        repeat(50) begin
            @ (negedge  clk);  
            key0 = 1'b0;
            #200ns;
            @ (negedge  clk);  
            key0 = 1'b1;
            #1us;
        end        

        repeat(100) begin
            @ (negedge  clk);  
            key1 = 1'b0;
            #200ns;
            @ (negedge  clk);  
            key1 = 1'b1;
            #1us;
        end   

        run_sim = 1'b0;
        $display("tb_updncnt done");
    end


endmodule 