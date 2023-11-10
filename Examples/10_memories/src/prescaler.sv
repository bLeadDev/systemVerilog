module prescaler(
    input       logic           rst_n,
    input       logic           clk,
    input       logic  [2:0]    speed,
    output      logic           clk_en            
);

logic [25:0]            cnt;
logic [25:0]            preload_value;

localparam clock_speed = 50_000_000;

always_comb begin : pre_load_mux
    case (speed)
        3'b000: preload_value = 0;    //no prescaler active for simulation 
        3'b001: preload_value = clock_speed / 50 - 1;    // 1/50s at 50MHz
        3'b010: preload_value = clock_speed / 20 - 1;    // 1/20s at 50MHz
        3'b011: preload_value = clock_speed / 10 - 1;    // 1/10s at 50MHz
        3'b100: preload_value = clock_speed / 5 - 1;    // 1/5s 
        3'b101: preload_value = clock_speed / 2 - 1;    // 1/2s 
        3'b110: preload_value = clock_speed - 1;        // 1/1s  
        default:  preload_value = clock_speed - 1;  // 1/1
         
    endcase
end

always_ff @( negedge rst_n or posedge clk ) begin : prescaler_cnt
    if (~rst_n)begin
        cnt         <= '0;
        clk_en      <= 1'b0;
    end
    else if (cnt == '0) begin
        cnt         <= preload_value;
        clk_en      <= 1'b1;
    end
    else begin
        cnt         <= cnt - 1'b1;
        clk_en      <= 1'b0;        
    end
end


endmodule