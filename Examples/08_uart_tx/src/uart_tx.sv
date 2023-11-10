//************************************************
//  Project: uart_tx.sv
//  Purpose: Implementation of a UART transmitter 
//  Author: Michael Geuze
//  Version: v0
//  Date: 03.11.2023
//************************************************


module uart_tx
#(
    parameter           BAUD        = 100_000,       //symbols per second
    parameter           FCLK        = 50_000_000   //clk frequency
) 
(
    input   logic               rst_n,              //active low reset
    input   logic               clk,                //clock
    input   logic       [7:0]   tx_data,            //data payload
    input   logic               tx_start,           //starts data frame
    output  logic               tx,                 //uart tx line
    output  logic               tx_idle             //indicates module is idle, new frame can be sent
);

// Implement the FSM

//auxilliary parameters
localparam WC_STARTVAL  = FCLK/BAUD - 1;
localparam WC_W         = $clog2(WC_STARTVAL); 

//typedefinitions
typedef enum logic[1:0] {IDLE, START, DATA, STOP} state_t;
state_t                 state;
state_t                 state_next;

//width counter signals
logic                   wc_zero;
logic [WC_W-1:0]        wc_cnt;
logic                   wc_load;
//bit counter signals
logic                   bc_inc;
logic                   bc_clr;
logic [2:0]             bc_cnt;

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
    state_next  = state; //so all states are defined
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
        DATA: begin
            tx      = tx_data[bc_cnt];  //transmit data
            //transition
            if (wc_zero) begin
                if (bc_cnt < 3'd7) begin
                    state_next  = DATA; //obsolete, just for readability
                    bc_inc      = 1'b1;
                    wc_load     = 1'b1;
                end 
                else begin
                    state_next  = STOP;
                    wc_load     = 1'b1;
                end
            end
        end
        STOP: begin
            tx                  = 1'b1;
            if (wc_zero) begin
                state_next      = IDLE;
            end
        end
    endcase
end

// WIDTH counter
always_ff @(posedge clk or negedge rst_n) begin
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

// BIT Counter
always_ff @(negedge rst_n or posedge clk) begin
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


endmodule