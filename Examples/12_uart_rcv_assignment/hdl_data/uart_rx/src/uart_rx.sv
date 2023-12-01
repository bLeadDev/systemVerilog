/////////////////////////////////////////////////////////////////////
//  Project:    HDL Assignments ETD
//  Author:     Michael Geuze
//  Purpose:    Implementation for a uart reciver
//  Date:       28.11.2023
//
/////////////////////////////////////////////////////////////////////

module uart_rx#(
    parameter fclk = 50_000_000,
    parameter baud = 115_200
) (
    input       logic           rst_n,
    input       logic           clk50m,
    input       logic           rx,


    output      logic   [7:0]   rx_data,
    output      logic           rx_ready,
    output      logic           rx_error,
    output      logic           rx_idle
);
    
localparam WC_STARTVAL  = fclk/baud - 1;        // width counter startvalue
localparam WC_W         = $clog2(WC_STARTVAL);  // width counter bit width

// width counter signals
logic                   wc_zero;    // is 1 if counter value is zero        
logic                   wc_mid;     // is 1 if counter value is below half of the counts
logic [WC_W-1:0]        wc_cnt;     // actual value in the counter
logic                   wc_load;    // command to reload the starting value

// bit counter signals
logic                   bc_inc;     // is 1 if counter value is zero    
logic [3:0]             bc_cnt;     // stores the counting value from 0-7, when 8 reset 
logic                   bc_clr;     // to clear the bit counter value
logic                   bc_end;     // indicates that the counter is >= 8

// Set reset error and ready signals
logic                   set_rx_error;   // Data transmission error.
logic                   set_rx_ready;   // Data ready to be taken from parallel bus
logic                   reset_rx_error; // Reset transmission error
logic                   reset_rx_ready; // Reset data ready

// RX line edge detection
logic                   state_rx_line;
logic                   rx_fall;
logic                   rx_rise;

typedef enum logic[2:0] {IDLE, RCV_START, RCV_DATA, RCV_STOP} state_t;
state_t                 state;
state_t                 state_next;

// Combinatorial part
always_comb begin : state_comb
    // Defaults
    state_next  = state; 
    
    // Outputs
    rx_idle     = 1'b0;

    // Do not reset counter values;; only do it in IDLE state
    wc_load             = 1'b0;
    bc_clr              = 1'b0;
    bc_inc              = 1'b0;

    set_rx_error        = 1'b0;
    reset_rx_error      = 1'b0;
    set_rx_ready        = 1'b0;
    reset_rx_ready      = 1'b0;

    case (state)
    IDLE: begin
        bc_clr      = 1'b1;
        rx_idle     = 1'b1;

        if (~rx) begin
        //if (rx_fall) begin
            wc_load     = 1'b1;
            state_next  = RCV_START;
        end
    end
    RCV_START: begin
        // Delete error or ready flags
        reset_rx_error = 1'b1;
        reset_rx_ready = 1'b1;
        // Restart counter in middle and set state to rcv data
        // No detection if start bit changed state or is flickering
        if (wc_mid) begin
            wc_load = 1'b1;
            state_next = RCV_DATA;
        end
    end
    RCV_DATA: begin
        if (wc_zero) begin
            // Sample bit, increase bit count and reload width counter
            rx_data[bc_cnt]     = rx;
            bc_inc              = 1'b1;
            wc_load             = 1'b1;
        end

        if (bc_end & wc_mid) begin
            // End of data, reload width counter for stop bit
            bc_inc      = 1'b1;
            wc_load     = 1'b1;
            bc_clr      = 1'b1;
            state_next  = RCV_STOP;
        end
    end
    RCV_STOP: begin

        if (wc_zero) begin
            // Stop bit was constantly zero, everything is okay
            set_rx_ready    = 1'b1;
            state_next      = IDLE;          
        end

        // If rx has a negedge signal error 
        if (rx_fall) begin
            set_rx_error    = 1'b1;
            set_rx_ready    = 1'b1;
            state_next      = IDLE;
        end 
    end
    endcase

end

//sequential part
always_ff @( negedge rst_n or posedge clk50m ) begin : ff_state
    if (~rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= state_next;
    end
end

// WIDTH counter
always_ff @(posedge clk50m or negedge rst_n) begin : ff_wid_count
    if (~rst_n) begin
        wc_cnt <= '0;
    end
    else if (wc_load) begin
        wc_cnt <= WC_STARTVAL;
    end 
    else if (~wc_zero) begin
        wc_cnt <= wc_cnt - 1'b1;
    end
end 
assign wc_zero = (wc_cnt == '0);
assign wc_mid  = (wc_cnt <= (WC_STARTVAL/2));

// BIT counter
always_ff @(posedge clk50m or negedge rst_n) begin : ff_bit_count
    if (~rst_n) begin
        bc_cnt <= '0;
    end 
    else if (bc_clr) begin
        bc_cnt <= '0;
    end
    else if (bc_inc) begin
        bc_cnt <= bc_cnt + 1'b1;
    end
end 
assign bc_end = (bc_cnt > 3'd7);

// Use flip flops for rx_ready and rx_error and set and clear them using the state machine
always_ff @(negedge rst_n or posedge clk50m) begin : ff_rx_error 
    if (~rst_n) begin
        rx_error <= 1'b0;
    end
    else if (reset_rx_error) begin
        rx_error <= 1'b0;
    end else if (set_rx_error) begin
        rx_error <= 1'b1;
    end
end

always_ff @(negedge rst_n or posedge clk50m) begin : ff_rx_ready
    if (~rst_n) begin
        rx_ready <= 1'b0;
    end
    else if (reset_rx_ready) begin
        rx_ready <= 1'b0;
    end else if (set_rx_ready) begin
        rx_ready <= 1'b1;
    end
end

// FF for edge detection on rx line
always_ff @(negedge rst_n or posedge clk50m) begin : ff_rx_edge_det
    if (~rst_n) begin
        state_rx_line <= 1'b0;
    end
    else begin // (2) synchronous behaviour
        state_rx_line <= rx;
    end
end 
    
assign rx_fall = (rx == 1'b0) && (state_rx_line == 1'b1);
assign rx_rise = (rx == 1'b1) && (state_rx_line == 1'b0);

endmodule