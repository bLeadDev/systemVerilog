vlib work


vlog -work work     ../src/edge_det.sv
vlog -work work     ../src/updncnt.sv

vlog -work work     tb_updncnt.sv

vsim -voptargs=+acc     work.tb_updncnt

log -r *

#do wave.do

run -all

view wave
