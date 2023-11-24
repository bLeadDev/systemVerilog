onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_data_mem/action
add wave -noupdate /tb_data_mem/data_in
add wave -noupdate /tb_data_mem/data_out
add wave -noupdate /tb_data_mem/addr
add wave -noupdate /tb_data_mem/reg0x7400
add wave -noupdate /tb_data_mem/reg0x7401
add wave -noupdate /tb_data_mem/reg0x7402
add wave -noupdate /tb_data_mem/reg0x7000
add wave -noupdate /tb_data_mem/reg0x7001
add wave -noupdate /tb_data_mem/reg0x7002
add wave -noupdate /tb_data_mem/we
add wave -noupdate /tb_data_mem/clk50m
add wave -noupdate /tb_data_mem/rst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {950003 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2782500 ps}
