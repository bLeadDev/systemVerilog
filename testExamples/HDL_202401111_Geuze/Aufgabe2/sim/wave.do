onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_count_1596/rst_n
add wave -noupdate /tb_count_1596/clk5m
add wave -noupdate /tb_count_1596/en
add wave -noupdate /tb_count_1596/load
add wave -noupdate /tb_count_1596/updn
add wave -noupdate -max 42.0 -radix unsigned /tb_count_1596/data_in
add wave -noupdate -format Analog-Step -height 74 -max 42.0 -radix unsigned /tb_count_1596/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12700 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 137
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
WaveRestoreZoom {0 ns} {13752 ns}
