vlib work

vlog -work work     ../src/uart_tx.sv

vlog -work work     tb_uart_tx.sv

vsim -voptargs=+acc     work.tb_uart_tx

log -r *

#do wave_pcount.do

run -all

view wave
