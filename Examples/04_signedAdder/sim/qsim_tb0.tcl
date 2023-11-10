vlib work

vlog -work work     ../src/adder_u.sv

vlog -work work     tb0.sv

vsim -voptargs=+acc     work.tb0

log -r *

do wave0.do

run -all

view wave
