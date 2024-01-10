//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------


module tb_pcount();
    parameter W = 15;
    // (1) DUT wiring
    logic                           rst_n;
    logic                           clk50m;
    logic                           en;
    logic                           load;
    logic                           inc;
    logic       [W-1 : 0]           cnt_in;

    logic       [W-1 : 0]           cnt;

    // (2) Place an instance of the DUT
    pcount  dut (.*);

    logic run_sim = 1'b1;

    task set_load_enable;
        begin
            load = 1'b1;
            en = 1'b1;
        end
    endtask

    task reset_load_enable;
        begin
            load = 1'b0;
            en = 1'b0;
        end
    endtask

    task set_inc_enable;
        begin
            inc = 1'b1;
            en = 1'b1;
        end
    endtask

    task reset_inc_enable;
        begin
            inc = 1'b0;
            en = 1'b0;
        end
    endtask

    initial begin //clock generator
        clk50m = 1'b0;
        while(run_sim) begin
            #10ns;
            clk50m = ~clk50m;
        end
    end

    int pass_cnt = 0;
    int err_cnt = 0;
    int err_in_loop = 0;

    initial begin
        $display("tb_pcount starts");
        rst_n = 1'b0;
        reset_load_enable;
        reset_inc_enable;
        cnt_in = 15'h0000;

        #70ns;
        $display("POR");
        rst_n = 1'b1;

        #100ns;               // # waits for a time
        
        //let the counter count to 30
        set_inc_enable;

        for (int i = 0; i < 30; i++) begin
            if(cnt != i) begin
                err_in_loop++;
            end
            @ (negedge  clk50m);  
        end
        reset_inc_enable;
        if (err_in_loop != 0) begin
            err_cnt++;
            $error("Error occured");
        end
        //wait a few clockcycles, check if value is kept
        @ (negedge  clk50m);         
        @ (negedge  clk50m);         
        @ (negedge  clk50m);         
        @ (negedge  clk50m);         
        @ (negedge  clk50m);         
        if(cnt == 30) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end
        //check if reset has zero as output
        rst_n = 1'b0;
        @ (negedge  clk50m); 
        rst_n = 1'b1;
        if(cnt == 0) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end
        @ (negedge  clk50m); 
        @ (negedge  clk50m);
        @ (negedge  clk50m);

        //check if value gets loaded
        set_load_enable;
        cnt_in = 15'h001e;
        @ (negedge  clk50m);
        reset_load_enable;
        // and does not increment when not enabled
        if(cnt == 15'h001e) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end
        @ (negedge  clk50m);
        if(cnt == 15'h001e) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end
        //set increment 
        set_inc_enable;
        @ (negedge  clk50m);
        if(cnt == 15'h001f) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end
        @ (negedge  clk50m);
        if(cnt == 15'h0020) begin
            pass_cnt++;
        end 
        else begin
            $error("Error occured");
            err_cnt++;
        end

        #50ns;               

        run_sim = 1'b0;
        if(err_cnt > 0) begin
            $display("Passed %d/%d tests.", pass_cnt, pass_cnt + err_cnt);
            $display("%d tests have failed.", err_cnt);
        end else if (err_cnt == 0) begin
            $display("All %d tests passed.", pass_cnt);
        end 
        $display("tb_pcount finished.");
    end
endmodule 