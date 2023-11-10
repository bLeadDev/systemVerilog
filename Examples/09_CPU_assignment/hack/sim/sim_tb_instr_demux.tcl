vlib work

vlog -work work     ../src/instr_demux.sv

vlog -work work     tb_instr_demux.sv

vsim -voptargs=+acc     work.tb_instr_demux

log -r *

do wave.do

run -all

view wave
