
// Full Module Head with state machine
module uart_tx
#(
    parameter           BAUD        = 100_000,       //symbols per second
) 
(
    input   logic               rst_n,              //active low reset
    input   logic       [7:0]   tx_data,            //data payload
    output  logic               tx,                 //uart tx line
)
// Module logic here
localparam WC_STARTVAL  = FCLK/BAUD - 1;
//sequential part
always_ff @( negedge rst_n or posedge clk ) begin : state_ff
    if (~rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= state_next;
    end
end

//combinatorial part
always_comb begin : state_comb
    // Defaults
    state_next  = state; // all states and all signals have to be defined at any point in time!
    tx          = 1'b1;
    tx_idle     = 1'b0;
    wc_load     = 0'b0;
    bc_inc      = 0'b0;
    bc_clr      = 0'b0;

    case (state)
        IDLE: begin
            //output differing from the defaults, 
            tx_idle = 1'b1; //indicates we are idle
            bc_clr  = 1'b1; //clear bitcounter
            //transition
            if(tx_start) begin
                state_next      = START;
                wc_load         = 1'b1;
            end
        end 
        START: begin
            tx      = 1'b0;          //START BIT
            //transitions
            if (wc_zero) begin
                state_next      = DATA;
                wc_load         = 1'b1; //load the width counter
            end
        end
        // ...more states
    endcase
end

endmodule

// Program counter
always_ff @(negedge rst_n or posedge clk50m) begin : pc_ff
    if (~rst_n) begin
        cnt <= 'd0;
    end 
    else if (load & en) begin
        cnt <= cnt_in;
    end
    else if (inc & en) begin
        cnt <= cnt + 8'd1;
    end
end

// State definition/enumeration
typedef enum logic[1:0] {IDLE, START, DATA, STOP} state_t;
state_t                 state;


// loose function for misc reasons
function void display_debug_messages(int i, logic [3:0] bin_i, logic [6:0] hex_o, logic [6:0] hexn_o);
    $display("Displayed Value: %1X", i);
    $display("Binary input: %4b", bin_i);
    $display("LED Markings:                GFEDCBA");
    $display("State Output (non-inverted): %b", hex_o);
    $display("State Output (inverted):     %b", hexn_o);
    $display("-----------------------------------------------");
endfunction