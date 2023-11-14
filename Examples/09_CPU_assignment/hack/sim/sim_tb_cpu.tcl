vlib work

#compile all src files
vlog -work work     ../src/*.sv 

vlog -work work     tb_cpu.sv

vsim -voptargs=+acc     work.tb_cpu

log -r *

do wave.do

run -all

view wave
