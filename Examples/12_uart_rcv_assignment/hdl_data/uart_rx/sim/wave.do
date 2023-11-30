onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_uart_rx/action
add wave -noupdate /tb_uart_rx/rx
add wave -noupdate /tb_uart_rx/rx_data
add wave -noupdate /tb_uart_rx/rx_ready
add wave -noupdate /tb_uart_rx/rx_error
add wave -noupdate /tb_uart_rx/rx_idle
add wave -noupdate /tb_uart_rx/dut/state
add wave -noupdate /tb_uart_rx/clk50m
add wave -noupdate /tb_uart_rx/dut/rx_fall
add wave -noupdate /tb_uart_rx/dut/rx_rise
add wave -noupdate /tb_uart_rx/dut/bc_cnt
add wave -noupdate /tb_uart_rx/dut/wc_cnt
add wave -noupdate /tb_uart_rx/rst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88371 ns} 0}
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
WaveRestoreZoom {0 ns} {188465 ns}
