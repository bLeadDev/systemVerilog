vlib work

vlog -work work     ../src/dreg.sv

vlog -work work     tb_dreg.sv

vsim -voptargs=+acc     work.tb_dreg

log -r *

do wave_dreg.do

run -all

view wave
