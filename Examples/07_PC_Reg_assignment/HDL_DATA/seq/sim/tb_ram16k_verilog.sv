//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement tb for program counter
// Author: Michael Geuze
// Version: v0
// Date: 30.10.2023
//----------------------------------------------------------


module tb_ram16k_verilog();
    // (1) DUT wiring
    logic           aclr;
    logic [13:0]    address;
    logic           clock;
    logic [15:0]    data;
    logic           wren;
    logic [15:0]    q;
    // (2) Place an instance of the DUT
    ram16k_verilog  dut (.*);

    logic run_sim = 1'b1;

    initial begin //clock generator
        clock = 1'b0;
        while(run_sim) begin
            #10ns;
            clock = ~clock;
        end
    end

    int pass_cnt = 0;
    int err_cnt = 0;

    initial begin
        $display("tb_ram16k_verilog starts");
        aclr = 1'b0;

        //fill with zeroes
        wren = 1'b1;
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            data = 'b0;
            @ (negedge  clock);  
        end
        wren = 1'b0;
        address = 0;
        @ (negedge clock);
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            if(q != 0) begin
                err_cnt++;
                $error("Error occured.");
            end 
            else begin
                pass_cnt++;
            end
            @ (negedge  clock); 
        end

        //fill with ones
        wren = 1'b1;
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            data = 16'hffff;
            @ (negedge  clock);  
        end
        wren = 1'b0;
        address = 0;
        @ (negedge clock);
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            if(q != 16'hffff) begin
                err_cnt++;
                $error("Error occured.");
            end 
            else begin
                pass_cnt++;
            end
            @ (negedge  clock); 
        end
        #10ns;

        //fill with address values
        wren = 1'b1;
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            data = i;
            @ (negedge  clock);  
        end
        wren = 1'b0;
        address = 0;
        @ (negedge clock);
        for(int i = 0; i < (2**14); i++) begin
            address = i;
            @ (negedge  clock); 
            if(q != i) begin
                err_cnt++;
                $error("Error occured.");
            end 
            else begin
                pass_cnt++;
            end
        end
        #50ns;               

        run_sim = 1'b0;
        if(err_cnt > 0) begin
            $display("Passed %d/%d tests.", pass_cnt, pass_cnt + err_cnt);
            $display("%d tests have failed.", err_cnt);
        end else if (err_cnt == 0) begin
            $display("All %d tests passed.", pass_cnt);
        end 
        $display("tb_ram16k_verilog finished.");
    end
endmodule 