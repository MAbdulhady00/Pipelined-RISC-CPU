


vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ih/*
add wave -position insertpoint sim:/phase_3/ftch/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint  \
sim:/phase_3/ds/rf/reg_out
add wave -position insertpoint  \
sim:/phase_3/ftch/i_branch_decision
add wave -position insertpoint sim:/phase_3/hazard_unit/*
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
force -freeze sim:/phase_3/i_interrupt 0 0
run 125
force -freeze sim:/phase_3/i_reset 0 0
run 75

run 100000


//test for interrupt

vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ih/*
add wave -position insertpoint sim:/phase_3/ftch/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint  \
sim:/phase_3/ds/rf/reg_out
add wave -position insertpoint  \
sim:/phase_3/ftch/i_branch_decision
add wave -position insertpoint sim:/phase_3/hazard_unit/*
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
force -freeze sim:/phase_3/i_interrupt 0 0
run 25
force -freeze sim:/phase_3/i_reset 0 0
run 75
run 1000
force -freeze sim:/phase_3/i_interrupt 1 0
run 1600





//Test case from TA

vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ih/*
add wave -position insertpoint sim:/phase_3/ftch/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint  \
sim:/phase_3/ds/rf/reg_out
add wave -position insertpoint  \
sim:/phase_3/ftch/i_branch_decision
add wave -position insertpoint sim:/phase_3/hazard_unit/*
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
force -freeze sim:/phase_3/i_interrupt 0 0
run 75
force -freeze sim:/phase_3/i_reset 0 0
force -freeze sim:/phase_3/i_input_port 0000000000000101 0
run 275
force -freeze sim:/phase_3/i_input_port 0000000000011001 0
run 100
force -freeze sim:/phase_3/i_input_port 1111111111111111 0
run 100
force -freeze sim:/phase_3/i_input_port 1111001100100000 0
run 50000


//Test case from TA -interrupt-

vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ih/*
add wave -position insertpoint sim:/phase_3/ftch/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint  \
sim:/phase_3/ds/rf/reg_out
add wave -position insertpoint  \
sim:/phase_3/ftch/i_branch_decision
add wave -position insertpoint sim:/phase_3/hazard_unit/*
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
force -freeze sim:/phase_3/i_interrupt 0 0
run 75
force -freeze sim:/phase_3/i_reset 0 0
force -freeze sim:/phase_3/i_input_port 0000000000000101 0
run 275
force -freeze sim:/phase_3/i_input_port 0000000000011001 0
run 100
force -freeze sim:/phase_3/i_input_port 1111111111111111 0
run 100
force -freeze sim:/phase_3/i_input_port 1111001100100000 0
run 100
run 25
force -freeze sim:/phase_3/i_interrupt 1 0
run 900

