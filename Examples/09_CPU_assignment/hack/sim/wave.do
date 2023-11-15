onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cpu/action
add wave -noupdate /tb_cpu/instr
add wave -noupdate /tb_cpu/clk50m
add wave -noupdate /tb_cpu/en25m
add wave -noupdate /tb_cpu/dut/a_u1/q
add wave -noupdate /tb_cpu/dut/d_u1/q
add wave -noupdate /tb_cpu/writeM
add wave -noupdate /tb_cpu/outM
add wave -noupdate /tb_cpu/addressM
add wave -noupdate /tb_cpu/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {850 ns}
