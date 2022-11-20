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
    input         i_mem_read,
    input         i_mem_write,
    input         i_stack_operation,
    input         i_stack_function,
    input         i_branch_operation,
    input         i_imm,
    input         i_input_port,
    input         i_pop_pc,
    input         i_push_pc,
    input         i_branch_flags,
    input  [15:0] i_data1,
    input  [15:0] i_data2,
    input  [ 2:0] i_rd,
    input  [ 2:0] i_rs,
    // input  [31:0] i_pc,
    input  [15:0] i_data_wb,           // actual result data coming from the write back stage
    input         i_data1_forward,     // from the fowrading unit if data1 should be fowraded 
    input         i_data2_forward,     // from the fowrading unit if data2 should be fowraded
    input  [15:0] i_immediate,         // instruction data from decode stage
    input  [ 2:0] i_write_addr,
    output [ 2:0] o_write_addr,
    output [15:0] o_immediate,         // to write back buffer
    output [15:0] o_memory_data,       // Data read from the memory
    output [15:0] o_ex_result,
    output        o_zero_flag,         // zero flag
    output        o_negative_flag,     // negative flag
    output        o_carry_flag,        // carry flag 
    output        o_wb_selector,
    output        o_write_back
);
  wire [15:0] memory_address;
  wire [15:0] memory_write_data;
  wire  [15:0] alu_input_1;
  wire  [15:0] alu_input_2;
  wire [15:0] alu_result;
  wire        zero_flag;  // zero flag
  wire        negative_flag;  // negative flag
  wire        carry_flag;  // carry flag 
  wire [15:0] forward_imm;
  wire [15:0] forward_imm_inc;
  assign o_immediate   = i_immediate;
  assign o_wb_selector = i_wb_selector;
  assign o_write_back  = i_write_back;
  assign o_write_addr  = i_write_addr;

  mux_2x1 #(16) mux_memory_1 (
      .i_in0(i_data2),
      .i_in1(i_data1),
      .i_sel(i_stack_operation),
      .o_out(memory_write_data)
  );

  mux_2x1 #(16) mux_memory_2 (
      .i_in0(i_data2),
      .i_in1(i_data1),
      .i_sel(i_mem_write),
      .o_out(memory_address)
  );

  data_memory dm (
      .i_address(memory_address),
      .i_write_data(memory_write_data),
      .i_memory_read(i_mem_read),
      .i_memory_write(i_mem_write),
      .i_clk(i_clk),
      .o_read_data(o_memory_data)
  );

  //=-=-=-=-=-==-=-=-= ALU + Fowarding =-=-=-=-=-==-=-=-=
  mux_2x1 #(16) mux_alu_foward_1 (
      .i_in0(i_data1),
      .i_in1(i_data_wb),
      .i_sel(i_data1_forward),
      .o_out(alu_input_1)
  );
  mux_2x1 #(16) mux_alu_foward_2 (
      .i_in0(i_data2),
      .i_in1(i_data_wb),
      .i_sel(i_data2_forward),
      .o_out(forward_imm)
  );
  mux_2x1 #(16) mux_alu_foward_3 (
      .i_in0(forward_imm),
      .i_in1(i_immediate),
      .i_sel(i_imm),
      .o_out(forward_imm_inc)
  );
  mux_2x1 #(16) mux_alu_foward_4 (
      .i_in0(forward_imm_inc),
      .i_in1(16'b1),
      .i_sel(i_inc_dec),
      .o_out(alu_input_2)
  );

  flag_register fr (
      .i_clk          (i_clk),            //clock signal
      .i_rst          (i_reset),          // reset signal
      .i_zero_flag    (zero_flag),        // zero flag
      .i_negative_flag(negative_flag),    // negative flag
      .i_carry_flag   (carry_flag),       // carry flag 
      .o_zero_flag    (o_zero_flag),      // zero flag
      .o_negative_flag(o_negative_flag),  // negative flag
      .o_carry_flag   (o_carry_flag)      // carry flag 
  );
  alu alu_unit (
      .i_data_1       (alu_input_1),     // source
      .i_data_2       (alu_input_2),     // destination
      .i_op           (i_alu_function),  // opcode 
      .o_zero_flag    (zero_flag),       // zero flag
      .o_negative_flag(negative_flag),   // negative flag
      .o_carry_flag   (carry_flag),      // carry flag 
      .o_result       (alu_result)       // result
  );  //Arithmatic logical operation unit.



  // Select data 2 instead of alu result if it is a mov instruction
  mux_2x1 ex_result (
      .i_in0(alu_result),
      .i_in1(i_data2),
      .i_sel(i_mov),
      .o_out(o_ex_result)
  );


endmodule
