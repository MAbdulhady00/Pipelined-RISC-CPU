vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ih/*
add wave -position insertpoint sim:/phase_3/ftch/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint sim:/phase_3/em/dm/*
add wave -position insertpoint  \
sim:/phase_3/ds/rf/reg_out
add wave -position insertpoint  \
sim:/phase_3/ftch/i_branch_decision
add wave -position insertpoint sim:/phase_3/hazard_unit/*
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
force -freeze sim:/phase_3/i_input_port 16'd5 0
force -freeze sim:/phase_3/i_interrupt 0 0
run 125
force -freeze sim:/phase_3/i_reset 0 0
run 75
run 100
force -freeze sim:/phase_3/i_input_port 16'h400 0
run 200
force -freeze sim:/phase_3/i_input_port 16'h40 0
run 100
force -freeze sim:/phase_3/i_input_port 16'h500 0
run 100
force -freeze sim:/phase_3/i_input_port 16'h100 0
run 100
force -freeze sim:/phase_3/i_input_port 16'hFFF 0
run 200
force -freeze sim:/phase_3/i_input_port 16'h700 0

run 100000