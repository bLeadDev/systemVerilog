# (1) Init sim enviroment
vlib work

# (2) Compile the SRC files
vlog -work work         ../src/fsm_door_1596.sv

# (3) Compile the TB files
vlog -work work         tb_fsm_door_1596.sv

# (4) Start Simulation --> module name (no extension!)
vsim -voptargs=+acc     work.tb_fsm_door_1596

# (5) Log all signals recursively
log -r *

# (5a) Call the wave format script
do wave.do

# (6) Run the simulation
run -all 

# (7) Bring up the wave window
view wave