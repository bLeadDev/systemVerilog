//----------------------------------------------------------
// Project: EDB HDL WS2023
// Purpose: Implement an unsigned adder
// Author: Michael Geuze
// Version: v0
// Date: 13.10.2023
//----------------------------------------------------------
parameter W = 16; 

function void display_states(logic [W-1:0] x, logic [W-1:0] y, logic [W-1:0] out, logic zr, logic ng, int cnt);
    $display("Test nr:   %d", cnt);
    $display("in x: %16d", $signed(x));
    $display("in y: %16d", $signed(y));
    $display("out : %16d", $signed(out));
    $display("neg : %16d", ng);
    $display("zer : %16d", zr);
    $display("-----------------------------------------------");
endfunction

module tb_alu();
    // (1) DUT wiring
    logic       [W-1 : 0]           x;
    logic       [W-1 : 0]           y;
    logic			                zx;
    logic                           nx;
    logic                           zy;
    logic                           ny;
    logic                           f;
    logic                           no;

    logic       [W-1 : 0]           out;
    logic                           zr;
    logic                           ng;

    // (2) Place an instance of the DUT
    alu #(.W(W))  dut (.*);

    // Instruction set for tests, inclomplete
    logic                   [5:0] control;
    localparam ADD          = 6'b000010;
    localparam SUB_X_Y      = 6'b010011;
    localparam SUB_Y_X      = 6'b000111;
    localparam ZERO         = 6'b101010;
    localparam BIT_AND      = 6'b000000;
    localparam BIT_OR       = 6'b010101;
    localparam NOT_X        = 6'b001101;
    localparam NOT_Y        = 6'b110001;

    int err_cnt = 0;
    int pass_cnt = 0;   
    int test_cnt = 0;

    // Set instruction bits according to control variable
    assign {zx, nx, zy, ny, f, no} = control;

    // (3) Stimulate the  DUT
    initial begin
        test_cnt++;
        //create output: out = 1 + 2
        x = 1;
        y = 2;
        control = ADD;
        #100ns;
        if ($signed(out) == 3 && zr == 0 && ng == 0) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = 100-50
        x = 100;
        y = 50; 
        control = SUB_X_Y;
        #100ns;
        if ($signed(out) == 50 && zr == 0 && ng == 0) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = 50 - 100 
        x = 100;
        y = 50; 
        control = SUB_Y_X;
        #100ns;
        if ($signed(out) == -50 && zr == 0 && ng == 1) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = 0 
        x = 100;
        y = 50; 
        control = ZERO;
        #100ns;
        if ($signed(out) == 0 && zr == 1 && ng == 0) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = 0xaa & 0x55
        x = 16'haa;
        y = 16'h55; 
        control = BIT_AND;
        #100ns;
        if ($signed(out) == 0 && zr == 1 && ng == 0) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = 0xaa | 0x55
        x = 16'hAA;
        y = 16'h55; 
        control = BIT_OR;
        #100ns;
        if ($signed(out) == 255 && zr == 0 && ng == 0) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = -1
        x = 16'd0;
        y = 16'd1; 
        control = SUB_X_Y;
        #100ns;
        if ($signed(out) == -1 && zr == 0 && ng == 1) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = !255
        x = 16'd255;
        y = 16'd0; 
        control = NOT_X;
        #100ns;
        if ($signed(out) == -256 && zr == 0 && ng == 1) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);
        
        test_cnt++;
        //create output: out = -255
        x = 16'd255;
        y = 16'd0; 
        control = SUB_Y_X;
        #100ns;
        if ($signed(out) == -255 && zr == 0 && ng == 1) begin
            pass_cnt += 1;
        end
        else begin
            err_cnt += 1;
            $error("Failure in test %d", test_cnt);
        end
        display_states(x, y, out, zr, ng, test_cnt);

        $display("tests :    %d", test_cnt);
        $display("passed:    %d", pass_cnt);
        $display("error :    %d", err_cnt);
    end
endmodule 