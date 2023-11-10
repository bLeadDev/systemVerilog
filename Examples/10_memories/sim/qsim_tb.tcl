vlib work

vlog -work work     ../fpga/toplevel_c5g_hex4_uart.sv
vlog -work work     ../ip/rom_10bit_256.v
vlog -work work     ../src/*.sv

vlog -work work     tb.sv

#includes alteralib without optimization
vopt +acc -O0 -L altera_mf_ver tb -o tb_opt_disabled 

vsim work.tb_opt_disabled

log -r *

#do wave.do

run -all

view wave
