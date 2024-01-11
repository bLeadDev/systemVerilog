onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fsm_door_1596/rst_n
add wave -noupdate /tb_fsm_door_1596/clk2m
add wave -noupdate /tb_fsm_door_1596/key_up
add wave -noupdate /tb_fsm_door_1596/key_down
add wave -noupdate /tb_fsm_door_1596/sense_up
add wave -noupdate /tb_fsm_door_1596/sense_down
add wave -noupdate /tb_fsm_door_1596/ml
add wave -noupdate /tb_fsm_door_1596/mr
add wave -noupdate /tb_fsm_door_1596/light_red
add wave -noupdate /tb_fsm_door_1596/light_green
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1628 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 219
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
WaveRestoreZoom {0 ns} {10763 ns}
