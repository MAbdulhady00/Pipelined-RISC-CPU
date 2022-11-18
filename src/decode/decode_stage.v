module decode_stage (
    input [15:0] i_instr,
    input i_clk,
    input i_interrupt,
    input i_write_back,
    input [2:0] i_write_addr,
    input [15:0] i_write_data,
    output reg [2:0] o_alu_function,
    output reg [1:0] o_wb_selector,
    output reg [2:0] o_branch_selector,
    output reg o_mov,
    output reg o_write_back,
    output reg o_inc_dec,
    output reg o_change_carry,
    output reg o_carry_value,
    output reg o_mem_read,
    output reg o_mem_write,
    output reg o_stack_operation,
    output reg o_stack_function,
    output reg o_branch_operation,
    output reg o_imm,
    output reg o_output_port,
    output reg o_pop_pc,
    output reg o_push_pc,
    output reg o_branch_flags,
    output [15:0] o_data1,
    output [15:0] o_data2,
    output [2:0] o_rd,
    output [2:0] o_rs
);

  wire read1, read2;
  control_unit_phase_1 cu (
      i_instr[15:13],
      i_interrupt,
      o_alu_function,
      o_wb_selector,
      o_branch_selector,
      o_mov,
      o_write_back,
      o_inc_dec,
      o_change_carry,
      o_carry_value,
      o_mem_read,
      o_mem_write,
      o_stack_operation,
      o_stack_function,
      o_branch_operation,
      o_imm,
      o_output_port,
      o_pop_pc,
      o_push_pc,
      o_branch_flags,
      read1,
      read2
  );

  register_file rf (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_read1(read1),
      .i_read2(read2),
      .i_read_addr1(rd),
      .i_read_addr2(rs),
      .i_write(i_write_back),
      .i_write_addr(i_write_addr),
      .i_write_data(i_write_data),
      .o_data1(o_data1),
      .o_data2(o_data2)
  );

  assign o_rd = i_instr[12:10];
  assign o_rs = i_instr[9:7];

endmodule
