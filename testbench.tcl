vsim work.test_bench
add wave -position insertpoint sim:/test_bench/*
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[7]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[6]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[5]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[4]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[3]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[2]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[1]/r/o_data}
add wave -position insertpoint  {sim:/test_bench/ds/rf/genblk1[0]/r/o_data}
run 100000
