vlib work

vlog -work work     ../src/alu.sv

vlog -work work     tb_alu.sv

vsim -voptargs=+acc     work.tb_alu

log -r *

do wave.do

run -all

view wave
