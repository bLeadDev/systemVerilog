module tb_dreg();
    parameter W = 16;
    // (1) DUT wiring
    logic                           rst_n;
    logic                           clk50m;

    logic       [W-1 : 0]           q;

    // (2) Place an instance of the DUT
    dreg  dut (.*);

    logic run_sim = 1'b1;

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
    end
endmodule
