/**
* This module is responsible for PC register.
* Reset will make PC 2^5 (First location of our program)
* =============================================
* Test Status = Not tested
*/
module program_counter (
    input i_clk,
    input i_enable,
    input i_reset,
    input i_interrupt,
    input [31:0] i_data,
    output reg [31:0] o_data
);

  always @(posedge i_clk) begin
    if (i_reset) o_data <= 32'b100000;
    else if (i_interrupt) o_data <= 32'b0;
    else if (i_enable) o_data <= i_data;
  end

endmodule
