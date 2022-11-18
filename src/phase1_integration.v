module phase_1 (
    input i_clk,
    input i_reset
);
  // fetch stage
  wire [15:0] ftch_instr;

  // decode stage
  wire [15:0] decode_instr;
  wire [2:0] decode_alu_function;
  wire [1:0] decode_wb_selector;
  wire [2:0] decode_branch_selector;
  wire decode_mov;
  wire decode_write_back;
  wire decode_inc_dec;
  wire decode_change_carry;
  wire decode_carry_value;
  wire decode_mem_read;
  wire decode_mem_write;
  wire decode_stack_operation;
  wire decode_stack_function;
  wire decode_branch_operation;
  wire decode_imm;
  wire decode_output_port;
  wire decode_pop_pc;
  wire decode_push_pc;
  wire decode_branch_flags;
  wire [15:0] decode_data1;
  wire [15:0] decode_data2;
  wire [2:0] decode_rd;
  wire [2:0] decode_rs;

  // EXM stage

  wire [2:0] exm_write_addr;
  wire [15:0] exm_immediate;  // to write back buffer
  wire [15:0] exm_memory_data;  // Data read from the memory
  wire [15:0] exm_ex_result;
  wire exm_zero_flag;  // zero flag
  wire exm_negative_flag;  // negative flag
  wire exm_carry_flag;  // carry flag 
  wire [1:0] exm_wb_selector;
  wire exm_write_back;
  wire [2:0] exm_alu_function;
  wire [15:0] exm_port;
  wire exm_i_write_addr;
  wire exm_i_alu_function;
  wire exm_i_wb_selector;
  wire exm_i_branch_selector;
  wire exm_i_mov;
  wire exm_i_write_back;
  wire exm_i_inc_dec;
  wire exm_i_change_carry;
  wire exm_i_carry_value;
  wire exm_i_mem_read;
  wire exm_i_mem_write;
  wire exm_i_stack_operation;
  wire exm_i_stack_function;
  wire exm_i_branch_operation;
  wire exm_i_imm;
  wire exm_i_output_port;
  wire exm_i_pop_pc;
  wire exm_i_push_pc;
  wire exm_i_branch_flags;
  wire [15:0] exm_i_data1;
  wire [15:0] exm_i_data2;
  wire [2:0] exm_i_rd;
  wire [2:0] exm_i_rs;
  // write back stage
  wire [1:0] wb_i_wb_selector;
  wire wb_i_write_back;
  wire [15:0] wb_i_ex_result;
  wire [15:0] wb_i_memory_data;
  wire [15:0] wb_i_port;
  wire [15:0] wb_i_immediate;
  wire [2:0] wb_i_wire_addr;

  wire wb_write_back;
  wire [2:0] wb_write_addr;
  wire [15:0] wb_write_data;

  fetch_Stage ftch (
      .i_intterup_signal(1'b0),
      .i_clk(i_clk),
      .i_reset(i_rst),
      .o_instr(ftch_instr)
  );

  fetch_decode_buffer ftch_decode_buff (
      .i_clk  (i_clk),
      .i_reset(i_reset),
      .i_instr(ftch_instr),
      .o_instr(decode_instr)
  );

  decode_stage ds (
      .i_instr(decode_instr),
      .i_clk(i_clk),
      .i_interrupt(1'b0),
      .i_write_back(wb_write_back),
      .i_write_addr(wb_write_addr),
      .i_write_data(wb_write_data),
      .o_alu_function(decode_alu_function),
      .o_wb_selector(decode_wb_selector),
      .o_branch_selector(decode_branch_selector),
      .o_mov(decode_mov),
      .o_write_back(decode_write_back),
      .o_inc_dec(decode_inc_dec),
      .o_change_carry(decode_change_carry),
      .o_carry_value(decode_carry_value),
      .o_mem_read(decode_mem_read),
      .o_mem_write(decode_mem_write),
      .o_stack_operation(decode_stack_operation),
      .o_stack_function(decode_stack_function),
      .o_branch_operation(decode_branch_operation),
      .o_imm(decode_imm),
      .o_output_port(decode_output_port),
      .o_pop_pc(decode_pop_pc),
      .o_push_pc(decode_push_pc),
      .o_branch_flags(decode_branch_flags),
      .o_data1(decode_data1),
      .o_data2(decode_data2),
      .o_rd(decode_rd),
      .o_rs(decode_rs)
  );


  decode_exm_buffer decode_exm_buff (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_alu_function(decode_alu_function),
      .i_wb_selector(decode_wb_Selector),
      .i_branch_selector(decode_branch_selector),
      .i_mov(decode_mov),
      .i_write_back(decode_write_back),
      .i_inc_dec(decode_inc_dec),
      .i_change_carry(decode_change_carry),
      .i_carry_value(decode_carry_value),
      .i_mem_read(decode_mem_read),
      .i_mem_write(decode_mem_write),
      .i_stack_operation(decode_stack_operation),
      .i_stack_function(decode_stack_function),
      .i_branch_operation(decode_branch_operation),
      .i_imm(decode_imm),
      .i_input_port(1'b0),
      .i_pop_pc(decode_pop_pc),
      .i_push_pc(decode_push_pc),
      .i_branch_flags(decode_branch_flags),
      .i_data1(decode_data1),
      .i_data2(decode_data2),
      .i_rd(decode_rd),
      .i_rs(decode_rs),
      .o_write_addr(exm_i_write_addr),
      .o_alu_function(exm_i_alu_function),
      .o_wb_selector(exm_i_wb_selector),
      .o_branch_selector(exm_i_branch_selector),
      .o_mov(exm_i_mov),
      .o_write_back(exm_i_write_back),
      .o_inc_dec(exm_i_inc_dec),
      .o_change_carry(exm_i_change_carry),
      .o_carry_value(exm_i_carry_value),
      .o_mem_read(exm_i_mem_read),
      .o_mem_write(exm_i_mem_write),
      .o_stack_operation(exm_i_stack_operation),
      .o_stack_function(exm_i_stack_function),
      .o_branch_operation(exm_i_branch_operation),
      .o_imm(exm_i_imm),
      .o_output_port(exm_i_output_port),
      .o_pop_pc(exm_i_pop_pc),
      .o_push_pc(exm_i_push_pc),
      .o_branch_flags(exm_i_branch_flags),
      .o_data1(exm_i_data1),
      .o_data2(exm_i_data2),
      .o_rd(exm_i_rd),
      .o_rs(exm_i_rs)
  );

  exm_stage em (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_alu_function(exm_i_alu_function),
      .i_wb_selector(exm_i_wb_selector),
      .i_branch_selector(exm_i_branch_selector),
      .i_mov(exm_i_mov),
      .i_write_back(exm_i_write_back),
      .i_inc_dec(exm_i_inc_dec),
      .i_change_carry(exm_i_change_carry),
      .i_carry_value(exm_i_carry_value),
      .i_mem_read(exm_i_mem_read),
      .i_mem_write(exm_i_mem_write),
      .i_stack_operation(exm_i_stack_operation),
      .i_stack_function(exm_i_stack_function),
      .i_branch_operation(exm_i_branch_operation),
      .i_imm(exm_i_imm),
      .i_input_port(1'b0),
      .i_pop_pc(exm_i_pop_pc),
      .i_push_pc(exm_i_push_pc),
      .i_branch_flags(exm_i_branch_flags),
      .i_data1(exm_i_data1),
      .i_data2(exm_i_data2),
      .i_rd(exm_i_rd),
      .i_rs(exm_i_rs),
      .i_data_wb(wb_write_data),  // actual result data coming from the write back stage
      .i_data1_forward(1'b0),  // from the fowrading unit if data1 should be fowraded 
      .i_data2_forward(1'b0),  // from the fowrading unit if data2 should be fowraded
      .i_immediate(decode_instr),  // instruction data from decode stage
      .i_write_addr(exm_i_write_addr),
      .o_write_addr(exm_write_addr),
      .o_immediate(exm_immediate),  // to write back buffer
      .o_memory_data(exm_memory_data),  // Data read from the memory
      .o_ex_result(exm_ex_result),
      .o_zero_flag(exm_zero_flag),  // zero flag
      .o_negative_flag(exm_zero_flag),  // negative flag
      .o_carry_flag(exm_carry_flag),  // carry flag 
      .o_wb_selector(exm_wb_selector),
      .o_write_back(exm_write_back)
  );

  exm_write_back_buffer exm_wb_buff (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_ex_result(exm_ex_result),
      .i_memory_data(exm_memory_data),
      .i_immediate(exm_immediate),
      .i_port(exm_port),
      .i_wb_selector(exm_wb_selector),
      .i_write_back(exm_write_back),
      .i_write_addr(exm_write_addr),
      .o_write_addr(wb_i_wire_addr),
      .o_ex_result(wb_i_ex_result),
      .o_memory_data(wb_i_memory_data),
      .o_immediate(wb_i_immediate),
      .o_port(wb_i_port),
      .o_wb_selector(wb_i_wb_selector),
      .o_write_back(wb_i_write_back)
  );

  write_back_stage wb (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_ex_result(wb_i_ex_result),
      .i_memory_data(wb_i_memory_data),
      .i_immediate(wb_i_immediate),
      .i_port(wb_i_port),
      .i_write_addr(wb_i_wire_addr),
      .i_wb_selector(wb_i_wb_selector),
      .i_write_back(wb_i_write_back),
      .o_write_data(wb_write_data),
      .o_write_addr(wb_wire_addr),
      .o_write_back(wb_write_back)
  );

endmodule
