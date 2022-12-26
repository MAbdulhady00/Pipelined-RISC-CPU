module phase_3 (
    input i_clk,
    input i_reset,
    input i_interrupt,
    input [15:0] i_input_port,
    output [15:0] o_output_port
);
  // fetch stage
  wire [15:0] ftch_instr;
  wire [31:0] ftch_pc;

  // decode stage
  wire [15:0] decode_instr;
  wire [31:0] decode_i_pc, decode_pc;
  wire [2:0] decode_alu_function;
  wire [1:0] decode_wb_selector;
  wire [2:0] decode_branch_selector;
  wire decode_interrupt;
  wire decode_i_interrupt;
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
  wire decode_shamt;
  wire decode_output_port;
  wire decode_pop_pc;
  wire decode_push_pc;
  wire decode_branch_flags;
  wire [15:0] decode_sh_amount;
  wire [15:0] decode_data1;
  wire [15:0] decode_data2;
  wire [2:0] decode_rd;
  wire [2:0] decode_rs;

  // EXM stage

  wire [2:0] exm_write_addr;
  wire [15:0] exm_immediate;  // to write back buffer
  wire [15:0] exm_memory_data;  // Data read from the memory
  wire [15:0] exm_ex_result;
  wire [1:0] exm_wb_selector;
  wire exm_write_back;
  wire exm_branch_decision;
  wire [31:0] exm_pc_new;

  wire [2:0] exm_i_write_addr;
  wire [2:0] exm_i_alu_function;
  wire [1:0] exm_i_wb_selector;
  wire [2:0] exm_i_branch_selector;
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
  wire exm_i_shamt;
  wire exm_i_output_port;
  wire exm_i_pop_pc;
  wire exm_i_push_pc;
  wire exm_i_branch_flags;
  wire [15:0] exm_i_sh_amount;
  wire [15:0] exm_i_data1;
  wire [15:0] exm_i_data2;
  wire [2:0] exm_i_rd;
  wire [2:0] exm_i_rs;
  wire [31:0] exm_i_pc;

  // hazard unit
  wire hazard_flush_f_d;
  wire hazard_flush_d_exm;
  wire hazard_stall_d_exm;
  wire hazard_branch_decision;
  wire hazard_state;


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


  wire interrupt_hold_call;
  wire interrupt_hold_stall;
  wire fetch_hazard_instruction;
  wire decode_hazard_instruction;

  fetch_stage ftch (
      .i_interrupt_signal(interrupt_hold_call & ~interrupt_hold_stall),
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_pc_new(exm_pc_new),
      .i_branch_decision(hazard_branch_decision),
      .o_instr(ftch_instr),
      .o_pc_inc(ftch_pc),
      .o_interrupt(decode_interrupt),
      .o_hazard_instruction(fetch_hazard_instruction)
  );

  wire reset_f_d;
  assign reset_f_d = i_reset | hazard_flush_f_d;
  fetch_decode_buffer ftch_decode_buff (
      .i_clk(i_clk),
      .i_reset(reset_f_d),
      .i_instr(ftch_instr),
      .i_pc(ftch_pc),
      .i_interrupt(decode_interrupt),
      .o_pc(decode_i_pc),
      .o_instr(decode_instr),
      .o_interrupt(decode_i_interrupt)
  );

  decode_stage ds (
      .i_instr(decode_instr),
      .i_reset(i_reset),
      .i_clk(i_clk),
      .i_interrupt(decode_i_interrupt),
      .i_write_back(wb_write_back),
      .i_write_addr(wb_write_addr),
      .i_write_data(wb_write_data),
      .i_pc(decode_i_pc),
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
      .o_shamt(decode_shamt),
      .o_output_port(decode_output_port),
      .o_pop_pc(decode_pop_pc),
      .o_push_pc(decode_push_pc),
      .o_branch_flags(decode_branch_flags),
      .o_sh_amount(decode_sh_amount),
      .o_data1(decode_data1),
      .o_data2(decode_data2),
      .o_rd(decode_rd),
      .o_rs(decode_rs),
      .o_pc(decode_pc),
      .o_hazard_instruction(decode_hazard_instruction)
  );

  wire reset_d_e;
  assign reset_d_e = i_reset | hazard_flush_d_exm;
  decode_exm_buffer decode_exm_buff (
      .i_clk(i_clk),
      .i_reset(reset_d_e),
      .i_enable(~hazard_stall_d_exm),
      .i_pc(decode_pc),
      .i_alu_function(decode_alu_function),
      .i_wb_selector(decode_wb_selector),
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
      .i_shamt(decode_shamt),
      .i_pop_pc(decode_pop_pc),
      .i_push_pc(decode_push_pc),
      .i_branch_flags(decode_branch_flags),
      .i_sh_amount(decode_sh_amount),
      .i_data1(decode_data1),
      .i_data2(decode_data2),
      .i_rd(decode_rd),
      .i_rs(decode_rs),
      .i_output_port(decode_output_port),
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
      .o_shamt(exm_i_shamt),
      .o_output_port(exm_i_output_port),
      .o_pop_pc(exm_i_pop_pc),
      .o_push_pc(exm_i_push_pc),
      .o_branch_flags(exm_i_branch_flags),
      .o_sh_amount(exm_i_sh_amount),
      .o_data1(exm_i_data1),
      .o_data2(exm_i_data2),
      .o_rd(exm_i_rd),
      .o_rs(exm_i_rs),
      .o_pc(exm_i_pc)
  );
  assign exm_i_write_addr = exm_i_rd;

  wire data1_forward, data2_forward;
  forwarding_unit funit (
      .i_rs(exm_i_rs),  // the data1 regeister
      .i_rd(exm_i_rd),  // the data2 register
      .i_rd_exmem(wb_i_wire_addr),  // the register we will write back into the next stage
      .i_write_back_signal(wb_i_write_back),
      .o_forward_slct_data1(data1_forward),  // A selector for the first mux before the alu
      .o_forward_slct_data2(data2_forward)  // A selector for the second mux before the alu
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
      .i_shamt(exm_i_shamt),
      .i_output_port(exm_i_output_port),
      .i_pop_pc(exm_i_pop_pc),
      .i_push_pc(exm_i_push_pc),
      .i_branch_flags(exm_i_branch_flags),
      .i_data1(exm_i_data1),
      .i_data2(exm_i_data2),
      .i_rd(exm_i_rd),
      .i_rs(exm_i_rs),
      .i_data_wb(wb_write_data),  // actual result data coming from the write back stage
      .i_sh_amount(exm_i_sh_amount),  // shift amount from instruction bits
      .i_data1_forward(data1_forward),  // from the fowrading unit if data1 should be fowraded 
      .i_data2_forward(data2_forward),  // from the fowrading unit if data2 should be fowraded
      .i_immediate(decode_instr),  // instruction data from decode stage
      .i_write_addr(exm_i_write_addr),
      .i_hazard_state(hazard_state),
      .i_pc(exm_i_pc),
      .o_write_addr(exm_write_addr),
      .o_immediate(exm_immediate),  // to write back buffer
      .o_memory_data(exm_memory_data),  // Data read from the memory
      .o_ex_result(exm_ex_result),
      .o_wb_selector(exm_wb_selector),
      .o_write_back(exm_write_back),
      .o_branch_decision(exm_branch_decision),
      .o_pc_new(exm_pc_new),
      .o_output_port(o_output_port)
  );

  exm_write_back_buffer exm_wb_buff (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_ex_result(exm_ex_result),
      .i_memory_data(exm_memory_data),
      .i_immediate(exm_immediate),
      .i_port(i_input_port),
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
      .o_write_addr(wb_write_addr),
      .o_write_back(wb_write_back)
  );

  interrupt_hold ih (
      .i_interrupt_signal(i_interrupt),
      .i_clk(i_clk),
      .i_enable(~interrupt_hold_stall),
      .i_reset(i_reset),
      .o_interrupt_call(interrupt_hold_call)
  );

  hazard_unit hazard_unit (
      .i_clk(i_clk),
      .i_push_pc(exm_i_push_pc),
      .i_pop_pc(exm_i_pop_pc),
      .i_branch_decision(exm_branch_decision),
      .i_interrupt_call(interrupt_hold_call),
      .i_exm_imm(exm_i_imm),
      .i_fetch_hazard_instruction(fetch_hazard_instruction),
      .i_decode_hazard_instruction(decode_hazard_instruction),
      .o_stall_interrupt(interrupt_hold_stall),
      .o_flush_f_d(hazard_flush_f_d),
      .o_flush_d_em(hazard_flush_d_exm),
      .o_stall_d_em(hazard_stall_d_exm),
      .o_branch_decision(hazard_branch_decision),
      .o_state(hazard_state)
  );

endmodule
