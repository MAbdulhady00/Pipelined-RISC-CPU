module fetch_stage (
    input i_intterup_signal,
    input i_clk,
    input i_reset,
    output [15:0] o_instr
);
  wire [31:0] pc_in;
  wire [31:0] pc_out;

  // phase 1 enable always on
  program_counter pc (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_enable(1'b1),
      .i_data(pc_in),
      .o_data(pc_out)
  );
  // phase 1 always increment
  mux_2x1 #(32) mux (
      pc_out + 1,
      32'b0,
      1'b0,
      pc_in
  );

  instructions_memory imem (
      .i_address(pc_out),
      .i_enable(1'b1),
      .o_read_data(o_instr)
  );

endmodule
