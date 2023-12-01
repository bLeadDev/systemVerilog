onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/LEDG
add wave -noupdate /tb_top/CLOCK_50_B5B
add wave -noupdate /tb_top/LEDR
add wave -noupdate /tb_top/CPU_RESET_n
add wave -noupdate /tb_top/KEY
add wave -noupdate /tb_top/SW
add wave -noupdate /tb_top/HEX0
add wave -noupdate /tb_top/HEX1
add wave -noupdate /tb_top/HEX2
add wave -noupdate /tb_top/HEX3
add wave -noupdate /tb_top/UART_RX
add wave -noupdate /tb_top/UART_TX
add wave -noupdate -format Analog-Step -height 68 -max 8.0 -radix unsigned /tb_top/dut/uc_u0/cpu_u0/pcount_u1/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {575000 ps} 0}
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
WaveRestoreZoom {0 ps} {3255 ns}
