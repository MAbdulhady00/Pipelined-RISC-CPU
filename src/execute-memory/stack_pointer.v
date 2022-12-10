module stack_pointer (
    input i_reset,
    input i_clk,
    input i_stack_operation,  // enable
    input [31:0] i_stack_pointer,
    output reg [31:0] o_stack_pointer
);

  reg [31:0] stack_pointer;
  always @(negedge i_clk) begin
    if (i_stack_operation) stack_pointer <= i_stack_pointer;
    if (i_reset) stack_pointer <= 32'b1111_1111_1111;
  end
  always @(*) begin
    if (i_stack_operation) o_stack_pointer = stack_pointer;
  end

endmodule
