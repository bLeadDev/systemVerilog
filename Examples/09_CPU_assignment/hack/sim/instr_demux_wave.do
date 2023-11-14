onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_instr_demux/instr
add wave -noupdate /tb_instr_demux/instr_v
add wave -noupdate /tb_instr_demux/instr_type
add wave -noupdate -radix binary /tb_instr_demux/cmd_a
add wave -noupdate -radix binary /tb_instr_demux/cmd_out_j
add wave -noupdate -radix binary /tb_instr_demux/cmd_out_d
add wave -noupdate -radix binary /tb_instr_demux/cmd_out_c
add wave -noupdate /tb_instr_demux/action
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {149 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {554 ns}
