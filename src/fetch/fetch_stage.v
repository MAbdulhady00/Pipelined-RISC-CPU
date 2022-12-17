module fetch_stage (
    input i_intterup_signal,
    input i_clk,
    input i_reset,
    input [31:0] i_pc_new,
    input i_branch_decision,
    output [15:0] o_instr,
    output [31:0] o_pc_inc
);
  wire [31:0] pc_in;
  wire [31:0] pc_out;

  assign o_pc_inc = pc_out + 1;

  program_counter pc (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_enable(1'b1),
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
      .o_read_data(o_instr)
  );

endmodule
