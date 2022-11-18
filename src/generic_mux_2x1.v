/**
* This module is responsible selecting inputs (MUX).
* Genric input bit width mux.
* Default width is 1 bit
* =============================================
* Test Status = OK 
*/
module mux_2x1 #(
    parameter N = 1
) (
    i_in0,
    i_in1,
    i_sel,
    o_out
);
  input [N-1:0] i_in0, i_in1;
  input i_sel;
  output [N-1:0] o_out;
  assign o_out = (i_sel) ? i_in1 : i_in0;
endmodule
// mini do file
/*
vsim work.mux_2x1
add wave sim:/mux_2x1/*
force -freeze sim:/mux_2x1/i_in0 0 0
force -freeze sim:/mux_2x1/i_in1 1 0
force -freeze sim:/mux_2x1/i_sel 1 0
run
*/
