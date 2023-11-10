vlib work

vlog -work work     ../src/adder_u.sv

vlog -work work     tb1.sv

vsim -voptargs=+acc     work.tb1

log -r *

do wave1.do

run -all

view wave
