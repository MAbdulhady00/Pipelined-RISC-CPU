
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

  reg [WIDTH-1:0] data;

  always @(posedge i_clk) begin
    if (i_reset) data <= 0;
    else if (i_write_enable) data <= i_data;
  end

  always @(negedge i_clk) begin
    if (i_reset) data <= 0;
    if (i_read_enable) o_data <= data;
  end

endmodule


