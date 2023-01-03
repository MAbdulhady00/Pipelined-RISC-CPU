module exm_stage (
    input         i_clk,
    input         i_reset,
    input  [ 2:0] i_alu_function,
    input  [ 1:0] i_wb_selector,
    input  [ 2:0] i_branch_selector,
    input         i_mov,
    input         i_write_back,
    input         i_inc_dec,
    input         i_change_carry,
    input         i_carry_value,
    input         i_change_zero,
    input         i_zero_value,
    input         i_change_negative,
    input         i_negative_value,
    input         i_mem_read,
    input         i_mem_write,
    input         i_stack_operation,
    input         i_stack_function,    // 1 for push, 0 for pop
    input         i_branch_operation,
    input         i_imm,
    input         i_shamt,
    input         i_output_port,
    input         i_pop_pc,
    input         i_push_pc,
    input         i_branch_flags,
    input  [15:0] i_data1,
    input  [15:0] i_data2,
    input  [ 2:0] i_rd,
    input  [ 2:0] i_rs,
    input  [31:0] i_pc,
    input  [15:0] i_data_wb,           // actual result data coming from the write back stage
    input         i_data1_forward,     // from the fowrading unit if data1 should be fowraded 
    input         i_data2_forward,     // from the fowrading unit if data2 should be fowraded
    input  [15:0] i_immediate,         // instruction data from decode stage
    input  [15:0] i_sh_amount,
    input  [ 2:0] i_write_addr,
    input         i_hazard_state,
    output [ 2:0] o_write_addr,
    output [15:0] o_immediate,         // to write back buffer
    output [15:0] o_memory_data,       // Data read from the memory
    output [15:0] o_ex_result,
    output [15:0] o_output_port,
    output [ 1:0] o_wb_selector,
    output        o_write_back,
    output        o_branch_decision,
    output [31:0] o_pc_new
);
  wire [15:0] memory_address;
  wire [15:0] memory_data_stack_address;
  wire [15:0] memory_selected;
  wire [15:0] memory_write_data;
  wire [15:0] memory_pc;
  wire [ 2:0] upper_3bits_pc;
  wire [15:0] pc_high;
  wire [15:0] pc_low;
  wire [15:0] alu_result;
  wire [31:0] branched_pc;
  wire        zero_flag_alu;  // alu res zero flag
  wire        negative_flag_alu;  // alu res negative flag
  wire        carry_flag_alu;  // alu res carry flag 
  wire        zero_flag;  // zero flag
  wire        negative_flag;  // negative flag
  wire        carry_flag;  // carry flag 
  wire [15:0] forward_imm;
  wire [15:0] forward_imm_inc;
  reg  [15:0] pc_temp;
  reg  [15:0] stack_temp;
  wire [15:0] data1, data2, alu_input_2;
  wire [15:0] imm_data;
  wire [31:0] stack_pointer_old;
  reg  [31:0] stack_pointer_new;
  assign o_immediate   = i_immediate;
  assign o_wb_selector = i_wb_selector;
  assign o_write_back  = i_write_back;
  assign o_write_addr  = i_write_addr;
  assign o_output_port = (i_output_port) ? data1 : 16'bz;

  // ========= stack =========
  stack_pointer stack (
      .i_reset(i_reset),
      .i_clk(i_clk),
      .i_stack_operation(i_stack_operation),  // enable
      .i_stack_pointer(stack_pointer_new),
      .o_stack_pointer(stack_pointer_old)
  );
  // latch old stack before negative clock cycle
  always @(*) begin
    if (i_stack_operation) begin
      if (i_stack_function) begin  // PUSH
        if (i_clk) stack_temp = stack_pointer_old;  // Write In (Stack Pointer) Location
        stack_pointer_new = stack_pointer_old - 1'b1;
      end else begin  // POP
        stack_pointer_new = stack_pointer_old + 1'b1;
        if (i_clk) stack_temp = stack_pointer_new;  // Read From (Stack Pointer - 1) Location
      end
    end
  end

  //=-=-=-=-=-==-=-=-= ALU + Fowarding =-=-=-=-=-==-=-=-=
  mux_2x1 #(16) mux_alu_foward_1 (
      .i_in0(i_data1),
      .i_in1(i_data_wb),
      .i_sel(i_data1_forward),
      .o_out(data1)
  );
  mux_2x1 #(16) mux_alu_foward_2 (
      .i_in0(i_data2),
      .i_in1(i_data_wb),
      .i_sel(i_data2_forward),
      .o_out(data2)
  );

  mux_2x1 #(16) mux_alu_foward_3_1 (
      .i_in0(i_immediate),
      .i_in1(i_sh_amount),
      .i_sel(i_shamt),
      .o_out(imm_data)
  );

  mux_2x1 #(16) mux_alu_foward_3 (
      .i_in0(data2),
      .i_in1(imm_data),
      .i_sel(i_imm | i_shamt),
      .o_out(forward_imm_inc)
  );
  mux_2x1 #(16) mux_alu_foward_4 (
      .i_in0(forward_imm_inc),
      .i_in1(16'b1),
      .i_sel(i_inc_dec),
      .o_out(alu_input_2)
  );
  wire [15:0] alu_input_1_final;
  wire [15:0] alu_input_2_final;
  mux_2x1 #(16) mux_alu_inputs_1(
      .i_in0(data1),
      .i_in1(alu_input_2),
      .i_sel(i_alu_function === 3'b011 & ~i_inc_dec),
      .o_out(alu_input_1_final)
  );
  mux_2x1 #(16) mux_alu_inputs_2(
      .i_in0(alu_input_2),
      .i_in1(data1),
      .i_sel(i_alu_function === 3'b011 & ~i_inc_dec),
      .o_out(alu_input_2_final)
  );
  wire carry_flag_r, zero_flag_r;
  assign carry_flag_r = (i_change_carry) ? i_carry_value : carry_flag;
  assign zero_flag_r = (i_change_zero) ? i_zero_value : zero_flag;

  flag_register fr (
      .i_clk          (i_clk),            //clock signal
      .i_rst          (i_reset),          // reset signal
      .i_zero_flag    (zero_flag_r),        // zero flag
      .i_negative_flag(negative_flag),    // negative flag
      .i_carry_flag   (carry_flag_r),     // carry flag 
      .o_zero_flag    (o_zero_flag),      // zero flag
      .o_negative_flag(o_negative_flag),  // negative flag
      .o_carry_flag   (o_carry_flag)      // carry flag 
  );


  alu alu_unit (
      .i_data_1       (alu_input_1_final),              // source
      .i_data_2       (alu_input_2_final),        // destination
      .i_op           (i_alu_function),     // opcode 
      .i_zero_flag    (o_zero_flag),        // zero flag
      .i_negative_flag(o_negative_flag),    // negative flag
      .i_carry_flag   (o_carry_flag),       // carry flag 
      .o_zero_flag    (zero_flag_alu),      // zero flag
      .o_negative_flag(negative_flag_alu),  // negative flag
      .o_carry_flag   (carry_flag_alu),     // carry flag 
      .o_result       (alu_result)          // result
  );  //Arithmatic logical operation unit.

  // select flags
  mux_2x1 flag_select_1 (
      .i_in0(zero_flag_alu),
      .i_in1(o_memory_data[15]),
      .i_sel(i_branch_flags & i_pop_pc & i_hazard_state),
      .o_out(zero_flag)
  );
  mux_2x1 flag_select_2 (
      .i_in0(negative_flag_alu),
      .i_in1(o_memory_data[14]),
      .i_sel(i_branch_flags & i_pop_pc & i_hazard_state),
      .o_out(negative_flag)
  );
  mux_2x1 flag_select_3 (
      .i_in0(carry_flag_alu),
      .i_in1(o_memory_data[13]),
      .i_sel(i_branch_flags & i_pop_pc & i_hazard_state),
      .o_out(carry_flag)
  );

  // Select data 2 instead of alu result if it is a mov instruction
  mux_2x1 #(16) ex_result (
      .i_in0(alu_result),
      .i_in1(data2),
      .i_sel(i_mov),
      .o_out(o_ex_result)
  );

  // branch decision
  assign o_branch_decision = (i_hazard_state | ~i_branch_operation)? 1'b0 : (i_branch_selector == 2'b11)? 1'b1 :
    (i_branch_selector == 2'b10)? o_carry_flag :
    (i_branch_selector == 2'b01)? o_negative_flag :
    o_zero_flag;


  mux_2x1 #(32) mux_pc_new_1 (
      .i_in0(32'b0),
      .i_in1({16'b0, data1}),
      .i_sel(o_branch_decision),
      .o_out(branched_pc)
  );

  mux_2x1 #(32) mux_pc_new_2 (
      .i_in0(branched_pc),
      .i_in1({3'b0, o_memory_data[12:0], pc_temp}),
      .i_sel(i_pop_pc & i_hazard_state),
      .o_out(o_pc_new)
  );

  // PC input

  mux_2x1 #(3) mux_pc_1 (
      .i_in0(i_pc[31:29]),
      .i_in1({o_zero_flag, o_negative_flag, o_carry_flag}),
      .i_sel(i_branch_flags),
      .o_out(upper_3bits_pc)
  );

  assign pc_high = {upper_3bits_pc, i_pc[28:16]};
  assign pc_low  = i_pc[15:0];

  mux_2x1 #(16) mux_memory_1 (
      .i_in0(data2),
      .i_in1(data1),
      .i_sel(i_mem_write),
      .o_out(memory_data_stack_address)
  );

  mux_2x1 #(16) mux_memory_2 (
      .i_in0(memory_data_stack_address),
      .i_in1(stack_temp[15:0]),
      .i_sel(i_stack_operation),
      .o_out(memory_address)
  );

  mux_2x1 #(16) mux_memory_3 (
      .i_in0(data2),
      .i_in1(data1),
      .i_sel(i_stack_operation),
      .o_out(memory_selected)
  );

  mux_2x1 #(16) mux_memory_4 (
      .i_in0(pc_high),
      .i_in1(pc_low),
      .i_sel(i_hazard_state),
      .o_out(memory_pc)
  );

  mux_2x1 #(16) mux_memory_5 (
      .i_in0(memory_selected),
      .i_in1(memory_pc),
      .i_sel(i_push_pc),
      .o_out(memory_write_data)
  );

  data_memory dm (
      .i_address(memory_address),
      .i_write_data(memory_write_data),
      .i_memory_read(i_mem_read),
      .i_memory_write(i_mem_write),
      .i_clk(i_clk),
      .o_read_data(o_memory_data)
  );

  // temp register
  always @(posedge i_clk) begin
    if (i_pop_pc) pc_temp <= o_memory_data;
  end

endmodule
