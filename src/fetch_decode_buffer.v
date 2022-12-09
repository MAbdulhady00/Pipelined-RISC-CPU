// TODO: flush input
module fetch_decode_buffer (
    input i_clk,
    input i_reset,
    input [15:0] i_instr,
    output reg [15:0] o_instr
);
  localparam NOP_INSTR = 16'b0;

  always @(posedge i_clk) begin
    if (i_reset) o_instr <= NOP_INSTR;
    else o_instr <= i_instr;
  end

endmodule
