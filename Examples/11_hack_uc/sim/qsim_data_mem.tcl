vlib work

vlog -work work     ../src/*.sv
vlog -work work     ../ip/ram16k.v

vlog -work work     tb_data_mem.sv

#includes alteralib without optimization
#optimize compiled stuff, use  lib altera mf, compile tb_data_mem and output to opt_disabled
vopt +acc -O0 -L altera_mf_ver tb_data_mem -o tb_opt_disabled 

#simulate the opt disabled TB
vsim work.tb_opt_disabled

log -r *

do wave.do

run -all

view wave
