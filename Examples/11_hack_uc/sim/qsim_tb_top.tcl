vlib work

vlog -work work     ../fpga/toplevel_c5g_hex4_uart.sv
vlog -work work     ../ip/ram16k.v
vlog -work work     ../ip/rom32k.v
vlog -work work     ../src/*.sv

vlog -work work     tb_top.sv

#includes alteralib without optimization, +acc(ess) all signals
#optimize compiled stuff, use  lib altera mf, compile tb_data_mem and output to opt_disabled
vopt +acc -O0 -L altera_mf_ver tb_top -o tb_top_opt_disabled 

#simulate the opt disabled TB
vsim work.tb_top_opt_disabled

log -r *

do tb_top_wave.do

run -all

view wave
