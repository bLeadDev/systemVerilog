vlib work

vlog -work work     ../src/edge_det.sv

vlog -work work     tb_edge_det.sv

vsim -voptargs=+acc     work.tb_edge_det

log -r *

#do wave.do

run -all

view wave
