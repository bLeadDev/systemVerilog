vlib work

vlog -work work     ../src/uart_rx.sv
vlog -work work     ../src/uart_tx.sv

vlog -work work     tb_uart_rx.sv

vsim -voptargs=+acc     work.tb_uart_rx

log -r *

do wave.do

run -all

view wave
