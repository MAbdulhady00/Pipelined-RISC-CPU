/**
* This module is responsible for all logical operations.
* operation: opcode
*     Not  : 001
*     Add  : 010
*     Sub  : 011
*     And  : 100
*     Or   : 101
*     SHL  : 110
*     SHR  : 111
* =============================================
* Test Status = OK
*/
module alu (
    input      [15:0] i_data_1,         // source
    input      [15:0] i_data_2,         // destination
    input      [ 2:0] i_op,             // opcode 
    input             i_zero_flag,      // zero flag
    input             i_negative_flag,  // negative flag
    input             i_carry_flag,     // carry flag 
    output reg        o_zero_flag,      // zero flag
    output reg        o_negative_flag,  // negative flag
    output reg        o_carry_flag,     // carry flag 
    output reg [15:0] o_result          // result
);
  always @(*) begin
    o_zero_flag = i_zero_flag;
    o_negative_flag = i_negative_flag;
    o_carry_flag = i_carry_flag;
    case (i_op)
      //NOP
      3'b000:  o_result <= ~i_data_1;
      //Not
      3'b001:  o_result <= ~i_data_1;
      //Add
      3'b010:  {o_carry_flag, o_result} <= i_data_1 + i_data_2;
      //Sub
      3'b011:  {o_carry_flag, o_result} <= i_data_2 - i_data_1;
      //And
      3'b100:  o_result <= i_data_1 & i_data_2;
      //Or
      3'b101:  o_result <= i_data_1 | i_data_2;
      //SHL
      3'b110:  {o_carry_flag, o_result} <= i_data_1 << i_data_2;
      //SHR
      3'b111:  {o_carry_flag, o_result} <= i_data_1 >> i_data_2;
      //bad opcode
      default: o_result = 16'bx;
    endcase
    if (i_op !== 3'b000) begin
      // zero flag
      o_zero_flag <= ~(|o_result);
      // negative flag
      o_negative_flag <= o_result[15];
    end
  end
endmodule
// mini do file
/*
vsim work.alu
add wave sim:/alu/*
force -freeze sim:/alu/i_data_1 1000100010001000 0
force -freeze sim:/alu/i_data_2 0000000000000101 0
force -freeze sim:/alu/i_op 110 0
run
*/
