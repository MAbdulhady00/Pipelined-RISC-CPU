module fetch_stage (
    input i_interrupt_signal,
    input i_enable,
    input i_clk,
    input i_reset,
    input [31:0] i_pc_new,
    input i_branch_decision,
    output [15:0] o_instr,
    output [31:0] o_pc_inc,
    output o_interrupt,
    output o_hazard_instruction
);
  wire [31:0] pc_in;
  wire [31:0] pc_out;
  wire [31:0] pc_inc;
  wire [15:0] instr;
  wire [ 4:0] opcode;

  assign opcode = instr[15:11];

  assign pc_inc = pc_out + 1;
  assign o_interrupt = i_interrupt_signal;
  // call | ret | rti | jz | jn | jc | jmp | ldm
  assign o_hazard_instruction = 
  (opcode === 5'b00101) || (opcode === 5'b00010) || (opcode === 5'b00011) || 
  (opcode === 5'b11000) || (opcode === 5'b11001) || (opcode === 5'b11010) || (opcode === 5'b11011) ||
  (opcode === 5'b10010);


  program_counter pc (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_interrupt(i_interrupt_signal),
      .i_enable(i_enable),
      .i_data(pc_in),
      .o_data(pc_out)
  );

  mux_2x1 #(32) mux (
      o_pc_inc,
      i_pc_new,
      i_branch_decision,
      pc_in
  );

  instructions_memory imem (
      .i_address(pc_out),
      .i_enable(1'b1),
      .i_clk(i_clk),
      .o_read_data(instr)
  );

  mux_2x1 #(16) mux2 (
      instr,
      16'b0,
      i_interrupt_signal,
      o_instr
  );


  assign o_pc_inc = (i_interrupt_signal) ? ((i_branch_decision) ? i_pc_new : pc_out) : pc_inc;

endmodule
