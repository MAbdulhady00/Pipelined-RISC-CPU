/**
* This module is responsible forwarding the output from
* the alu/memory to the next alu/memory.
* =============================================
* Test Status = OK
*/
module forwarding_unit (
    input [2:0] i_rs,  // the data1 regeister
    input [2:0] i_rd,  // the data2 register
    input [2:0] i_rd_exmem,  // the register we will write back into the next stage
    output reg o_forward_slct_data1,  // A selector for the first mux before the alu
    output reg o_forward_slct_data2  // A selector for the second mux before the alu
);
  always @(*) begin
    if (i_rd_exmem === i_rs) o_forward_slct_data1 = 1'b1;
    else o_forward_slct_data1 = 1'b0;
    if (i_rd_exmem === i_rd) o_forward_slct_data2 = 1'b1;
    else o_forward_slct_data2 = 1'b0;
  end
endmodule
// mini do file
/*
vsim work.forwarding_unit
add wave sim:/forwarding_unit/*
force -freeze sim:/forwarding_unit/i_rs 010 0
force -freeze sim:/forwarding_unit/i_rd 011 0
force -freeze sim:/forwarding_unit/i_rd_exmem 010 0
run
*/
