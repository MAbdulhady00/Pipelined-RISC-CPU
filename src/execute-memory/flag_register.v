/**
* This module is responsible for flag register.
* Read at negative edge write at positive edge.
* =============================================
* Test Status = Not tested
*/
module flag_register (
    input      i_clk,            //clock signal
    input      i_rst,            // reset signal
    input      i_zero_flag,      // zero flag
    input      i_negative_flag,  // negative flag
    input      i_carry_flag,     // carry flag 
    output reg o_zero_flag,      // zero flag
    output reg o_negative_flag,  // negative flag
    output reg o_carry_flag      // carry flag 
);

  always @(posedge i_clk) begin
    if (i_rst) {o_zero_flag, o_negative_flag, o_carry_flag} <= 3'b0;
    else
      {o_zero_flag, o_negative_flag, o_carry_flag} <= {i_zero_flag, i_negative_flag, i_carry_flag};
  end
endmodule
