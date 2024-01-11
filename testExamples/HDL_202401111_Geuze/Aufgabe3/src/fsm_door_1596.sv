

module fsm_door_1596
(
    input   logic               rst_n,              //active low reset
    input   logic               clk2m,
    input   logic               key_up,
    input   logic               key_down,
    input   logic               sense_up,
    input   logic               sense_down,

    output  logic               ml,                 
    output  logic               mr,                 
    output  logic               light_red,                 
    output  logic               light_green                 
);

// State definition/enumeration
typedef enum logic[2:0] {START_UP, IS_OPEN, IS_CLOSED, DRV_OPEN, DRV_CLOSED} state_t;
state_t                 state;
state_t                 state_next;

// State dreg
always_ff @( negedge rst_n or posedge clk2m ) begin : state_ff
    if (~rst_n) begin
        state <= START_UP;
    end
    else begin
        state <= state_next;
    end
end

//combinatorial part
always_comb begin : state_comb
    // Defaults
    state_next  = state; // all states and all signals have to be defined at any point in time
    ml          = 1'b0;
    mr          = 1'b0; 
    light_red   = 1'b0;        
    light_green = 1'b0;

    case (state)
        START_UP: begin
            // No state is known yet, get position if possible else wait for input
            if (sense_down) begin
                state_next = IS_CLOSED;
            end
            else if (sense_up) begin
                state_next = IS_OPEN;
            end
            else if (key_up) begin
                state_next = DRV_OPEN;
            end
            else if(key_down) begin
                state_next = DRV_CLOSED;
            end
        end
        IS_CLOSED: begin
            light_red = 1'b1;

            if (key_up) begin
                state_next      = DRV_OPEN;
            end
        end
        IS_OPEN: begin
            light_green = 1'b1;

            if (key_down) begin
                state_next      = DRV_CLOSED;
            end
        end
        DRV_CLOSED: begin
            ml                  = 1'b1;
            light_red           = 1'b1;

            if (sense_down) begin
                state_next      = IS_CLOSED;
            end
        end
        DRV_OPEN: begin
            mr                  = 1'b1;
            light_red           = 1'b1;

            if (sense_up) begin
                state_next      = IS_OPEN;
            end
        end
    endcase
end

endmodule