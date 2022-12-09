module decode_stage (
    input [15:0] i_instr,
    input i_clk,
    input i_reset,
    input i_interrupt,
    input i_write_back,
    input [2:0] i_write_addr,
    input [15:0] i_write_data,
    output [2:0] o_alu_function,
    output [1:0] o_wb_selector,
    output [2:0] o_branch_selector,
    output o_mov,
    output o_write_back,
    output o_inc_dec,
    output o_change_carry,
    output o_carry_value,
    output o_mem_read,
    output o_mem_write,
    output o_stack_operation,
    output o_stack_function,
    output o_branch_operation,
    output o_imm,
    output o_output_port,
    output o_pop_pc,
    output o_push_pc,
    output o_branch_flags,
    output [15:0] o_data1,
    output [15:0] o_data2,
    output [2:0] o_rd,
    output [2:0] o_rs
);

  wire read1, read2;

  control_unit cu (
      .i_op_code(i_instr[15:11]),
      .i_interrupt(i_interrupt),
      .o_alu_function(o_alu_function),
      .o_wb_selector(o_wb_selector),
      .o_branch_selector(o_branch_selector),
      .o_mov(o_mov),
      .o_write_back(o_write_back),
      .o_inc_dec(o_inc_dec),
      .o_change_carry(o_change_carry),
      .o_carry_value(o_carry_value),
      .o_mem_read(o_mem_read),
      .o_mem_write(o_mem_write),
      .o_stack_operation(o_stack_operation),
      .o_stack_function(o_stack_function),
      .o_branch_operation(o_branch_operation),
      .o_imm(o_imm),
      .o_output_port(o_output_port),
      .o_pop_pc(o_pop_pc),
      .o_push_pc(o_push_pc),
      .o_branch_flags(o_branch_flags),
      .o_read1(read1),
      .o_read2(read2)
  );

  register_file rf (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_read1(read1),
      .i_read2(read2),
      .i_read_addr1(o_rd),
      .i_read_addr2(o_rs),
      .i_write(i_write_back),
      .i_write_addr(i_write_addr),
      .i_write_data(i_write_data),
      .o_data1(o_data1),
      .o_data2(o_data2)
  );

  assign o_rd = i_instr[10:8];
  assign o_rs = i_instr[7:5];

endmodule
