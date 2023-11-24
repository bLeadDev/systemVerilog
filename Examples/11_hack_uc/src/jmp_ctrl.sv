/*---------------------------------------------
Project:    Hack Computer
Module:     ALU
Purpose:    Evaluate the JMP commands
Author:     Andre Mitterbacher
Version:    v0           
---------------------------------------------*/

module jmp_ctrl(
    input   logic       j1,
    input   logic       j2,
    input   logic       j3,
    input   logic       neg,
    input   logic       zero,

    output  logic       pc_load,
    output  logic       pc_inc
);

    logic [2:0] jbus;
    assign jbus = {j1, j2, j3}; //to keep in sync to the book

    always_comb begin
        // default values --> do not jump, do increment
        pc_load = 1'b0;
        pc_inc  = 1'b1;
        case (jbus)
            3'b000: begin //null
                // use defaults
            end
            3'b001: begin //JGT -- jump if alu_out > 0
                if (~neg & ~zero) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b010: begin //JEQ -- jump if alu_out == 0
                if (zero) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b011: begin // JGE -- jump if alu_out >= 0
                if (~neg) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b100: begin // JLT -- jump if alu_out < 0
                if (neg) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b101: begin // JNE -- jump if alu_out != 0
                if(~zero) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b110: begin //JLE -- jump if alu_out <= 0
                if(neg | zero) begin
                    pc_load = 1'b1;
                    pc_inc  = 1'b0;
                end
            end
            3'b111: begin //JMP -- jump always!
                pc_load = 1'b1;
                pc_inc  = 1'b0;
            end
            default : begin
                // use defaults
            end
        endcase
    end



endmodule