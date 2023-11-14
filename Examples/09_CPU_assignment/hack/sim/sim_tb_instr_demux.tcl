vlib work

vlog -work work     ../src/instr_demux.sv

vlog -work work     tb_instr_demux.sv

vsim -voptargs=+acc     work.tb_instr_demux

log -r *

do instr_demux_wave.do

run -all

view wave
