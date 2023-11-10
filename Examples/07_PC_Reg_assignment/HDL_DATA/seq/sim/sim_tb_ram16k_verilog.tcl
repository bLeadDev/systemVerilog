vlib work

vlog -work work     ../src/ram16k_verilog.sv

vlog -work work     tb_ram16k_verilog.sv

vsim -voptargs=+acc     work.tb_ram16k_verilog

log -r *

do wave_ram16k_verilog.do

run -all

view wave
