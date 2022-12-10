vsim work.phase_3
add wave -position insertpoint sim:/phase_3/*
add wave -position insertpoint sim:/phase_3/ftch/pc/*
add wave -position insertpoint sim:/phase_3/ds/cu/*
add wave -position insertpoint sim:/phase_3/wb/*
add wave -position insertpoint sim:/phase_3/em/*
add wave -position insertpoint sim:/phase_3/em/alu_unit/*
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[7]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[6]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[5]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[4]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[3]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[2]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[1]/r/o_data}
add wave -position insertpoint  {sim:/phase_3/ds/rf/genblk1[0]/r/o_data}
force -freeze sim:/phase_3/i_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/phase_3/i_reset 1 0
run 125
force -freeze sim:/phase_3/i_reset 0 0
run 75
run 100000
