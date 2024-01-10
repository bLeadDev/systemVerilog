//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for data register
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------


module tb_dreg();
    parameter W = 16;
    // (1) DUT wiring
    logic                           rst_n;
    logic                           clk50m;
    logic                           en;
    logic                           load;
    logic       [W-1 : 0]           d;

    logic       [W-1 : 0]           q;

    // (2) Place an instance of the DUT
    dreg  dut (.*);

    logic run_sim = 1'b1;

    task set_write_enable;
        begin
            load = 1'b1;
            en = 1'b1;
        end
    endtask

    task reset_write_enable;
        begin
            load = 1'b0;
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
    initial begin
        $display("tb_dreg starts");
        rst_n = 1'b0;
        reset_write_enable;
        d = 16'h0000;

        #70ns;
        $display("POR");
        rst_n = 1'b1;
        //Check if data 0000 can be written to register
        #100ns;               // # waits for a time
        @ (negedge  clk50m);   
        d = 16'h0000;            
        set_write_enable;

        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //new data, should be zero
        @ (negedge  clk50m);   
        reset_write_enable;
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //write ffff  to  register, data should still be zero
        @ (negedge  clk50m);   
        d = 16'hffff;            
        set_write_enable;

        if(q == 'd0) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set data in to zero, output should be ffff
        @ (negedge  clk50m);   
        d = 16'h0000;           
        reset_write_enable;

        if(q == 16'hffff) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //data should still be ffff
        @ (negedge  clk50m);   
        if(q == 16'hffff) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set data to aa55, data should still be ffff
        @ (negedge  clk50m);   
        d = 16'haa55;           
        set_write_enable;

        if(q == 16'hffff) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set data to 0000, should be aa55
        @ (negedge  clk50m);   
        d = 16'h0000;            
        reset_write_enable;

        if(q == 16'haa55) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set data to zero without writing, should still be aa55
        @ (negedge  clk50m);   
        d = 16'h0000;            

        if(q == 16'haa55) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set data to 55aa, should still be aa55
        @ (negedge  clk50m);   
        d = 16'h55aa;            
        set_write_enable;

        if(q == 16'haa55) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //reset write, data should be 55aa
        @ (negedge  clk50m);   
        reset_write_enable;
        if(q == 16'h55aa) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //set input to zero without write enable, data should stay at 55aa
        @ (negedge  clk50m);   
        d = 16'h0000;           
        if(q == 16'h55aa) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //write zero to data, should still be 55aa
        @ (negedge  clk50m);   
        d = 16'h0000;           
        set_write_enable;
        
        if(q == 16'h55aa) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //reset write enable, data should be zero
        @ (negedge  clk50m);   
        d = 16'h0000;           
        reset_write_enable;

        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end

        @ (negedge  clk50m);   
        d = 16'h0000;           
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end

        //set data to 1234, data should be 0000
        @ (negedge  clk50m);   
        d = 16'h1234;           
        set_write_enable;
        
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //reset write enable and set input to zero, data should be 1234
        @ (negedge  clk50m);   
        d = 16'h0000;           
        reset_write_enable;

        if(q == 16'h1234) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //reset register, data should still be 1234
        @ (negedge  clk50m);   
        rst_n = 1'b0;
        if(q == 16'h1234) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //reset done, data should be zero
        @ (negedge  clk50m);   
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //try to override reset with a value, data should stay at 0000
        @ (negedge  clk50m);   
        set_write_enable;
        d = 16'h1234;
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //same, second cycle
        @ (negedge  clk50m);   
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end
        //same thrid cycle
        @ (negedge  clk50m);   
        if(q == 16'h0000) begin
            pass_cnt++;
        end
        else begin
            err_cnt++;
        end

        #50ns;               // # waits for a time

        run_sim = 1'b0;
        if(err_cnt > 0) begin
            $display("Passed %d/%d tests.", pass_cnt, pass_cnt + err_cnt);
            $display("%d tests have failed.", err_cnt);
        end else if (err_cnt == 0) begin
            $display("All %d tests passed.", pass_cnt);
        end            
        $display("tb_dreg finished");
    end
endmodule 