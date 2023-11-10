

module addr_cnt (
    input   logic               rst_n,
    input   logic               clk, 
    input   logic               en,
    output  logic [7:0]         addr
);

always_ff @( negedge rst_n or posedge clk ) begin : addr_cnt
    if (~rst_n)begin
        addr         <= '0;
    end
    else if(en) begin
        addr         <= addr + 1'b1;       
    end
end

endmodule