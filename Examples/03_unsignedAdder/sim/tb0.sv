//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement an unsigned adder
// Author: Michael Geuze
// Version: v0
// Date: 13.10.2023
//----------------------------------------------------------


module tb0();
    // (1) DUT wiring
    
    parameter W = 4;        //bit width of the data path
    logic       [W-1 : 0]           x_i;
    logic       [W-1 : 0]           y_i;
    logic       [W-1 : 0]           sum_o;
    logic                           of_o;

    // (2) Place an instance of the DUT
    adder_u #(.W(W))  dut (.*);

    // (3) Stimulate the  DUT

    int sum_expected;
    localparam NUMMAX = 2**W - 1;
    int pass_cnt;
    int err_cnt;

    initial begin
        x_i     = '0;
        y_i     = '0;
        pass_cnt = 0;
        err_cnt = 0;

        for(int i = 0; i <= NUMMAX; i++) begin
            x_i = i;
            for(int j = 0; j <= NUMMAX; j++) begin
                y_i = j;
                #100ns;
                sum_expected = i + j;
                if(sum_expected >= NUMMAX) begin
                    sum_expected = NUMMAX;
                end
                //check the output
                if (sum_o == sum_expected) begin
                    pass_cnt++;
                end
                else begin
                    err_cnt++;
                    $error("DUT output is wrong! sum = %d, expected = %d", sum_o, sum_expected);
                end
            end
        end
        $display("tb0 finished.");
        $display("pass_cnt = %d", pass_cnt);
        $display("err_cnt = %d", err_cnt);
        if (err_cnt) begin
            $error("Test failed!");
        end
    end
endmodule 