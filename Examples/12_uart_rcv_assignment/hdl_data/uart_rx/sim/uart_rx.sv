/////////////////////////////////////////////////////////////////////
//  Project:    HDL Assignments ETD
//  Author:     Michael Geuze
//  Purpose:    Implementation for a uart reciver
//  Date:       28.11.2023
//
/////////////////////////////////////////////////////////////////////

module uart_rx#(
    parameter fclk = 50_000_000;
    parameter baud = 115_200;
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


typedef enum logic[2:0] {IDLE, START, RCV, STOP, DATA, ERROR} state_t;
state_t                 state;
state_t                 state_next;

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
    //defaults
    state_next  = state; 
    
    // outputs
    rx_data     = '0;
    rx_ready    = 1'b0;
    rx_error    = 1'b0;
    rx_idle     = 1'b0;

    // do not reset counter values;; only do it in idle/data/error state
    wc_zero     = 1'b0;
    bc_clr      = 1'b0;

    case (state)
    IDLE: begin
        wc_zero     = 1'b1;
        bc_clr      = 1'b1;
        rx_idle     = 1'b1;

        if (~rx) begin
            wc_load     = 1'b1;
            state_next  = START;
        end
    end
    START: begin
        if (wc_zero) begin
            wc_load     = 1'b1;
            state_next  = DATA;
        end
    end
    DATA: begin
        if (wc_mid) begin
            // sample data on bus

        end

        if (wc_zero) begin
            // get next bit
        end

        if (bc_end) begin
            // end of data, stop bit still missing
        end
    end
    STOP: begin
        
    end

    endcase

end


// WIDTH counter
always_ff @(posedge clk50m or negedge rst_n) begin
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
always_ff @(posedge clk50m or negedge rst_n) begin
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
assign bc_end = (bc_cnt >= 3'd8);


endmodule