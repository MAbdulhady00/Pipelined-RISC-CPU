module fetch_decode_buffer (
    input i_clk,
    input i_reset,
    input [31:0] i_pc,
    input [15:0] i_instr,
    input i_interrupt,
    output reg o_interrupt,
    output reg [15:0] o_instr,
    output reg [31:0] o_pc
);
  localparam NOP_INSTR = 16'b0;

  always @(posedge i_clk) begin
    if (i_reset) begin
      o_pc <= 32'b0;
      o_instr <= NOP_INSTR;
      o_interrupt <= 1'b0;
    end else begin
      o_pc <= i_pc;
      o_instr <= i_instr;
      o_interrupt <= i_interrupt;
    end
  end

endmodule
