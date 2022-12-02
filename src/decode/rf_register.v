
module rf_register #(
    parameter WIDTH = 16
) (
    input i_clk,
    input i_read_enable,
    input i_write_enable,
    input i_reset,
    input [WIDTH-1:0] i_data,
    output reg [WIDTH-1:0] o_data
);

  always @(negedge i_clk) begin
    if (i_reset) o_data <= 0;
    else if (i_write_enable) o_data <= i_data;
  end

endmodule


