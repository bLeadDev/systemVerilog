vlib work

vlog -work work     ../src/pcount.sv

vlog -work work     tb_pcount.sv

vsim -voptargs=+acc     work.tb_pcount

log -r *

do wave_pcount.do

run -all

view wave
