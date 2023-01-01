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

run 1000
force -freeze sim:/phase_3/i_interrupt 1 0
run 1600




