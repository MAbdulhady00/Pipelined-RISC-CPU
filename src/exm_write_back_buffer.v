module exm_write_back_buffer (
    input i_clk,
    input i_reset,
    input [15:0] i_ex_result,
    input [15:0] i_memory_data,
    input [15:0] i_immediate,
    input [15:0] i_port,
    input [1:0] i_wb_selector,
    input i_write_back,
    input [2:0] i_write_addr,
    output [2:0] o_write_addr,
    output [15:0] o_ex_result,
    output [15:0] o_memory_data,
    output [15:0] o_immediate,
    output [15:0] o_port,
    output [1:0] o_wb_selector,
    output o_write_back
);
  always @(posedge i_clk) begin
    if (i_reset) begin
      o_ex_result <= 16'b0;
      o_memory_data <= 16'b0;
      o_immediate <= 16'b0;
      o_port <= 16'b0;
      o_wb_selector <= 2'b0;
      o_write_back <= 1'b0;
      o_write_addr <= 3'b0;
    end else begin
      o_ex_result <= i_ex_result;
      o_memory_data <= i_memory_data;
      o_immediate <= i_immediate;
      o_port <= i_port;
      o_wb_selector <= i_wb_selector;
      o_write_back <= i_write_back;
      o_write_addr <= i_write_addr;
    end
  end
endmodule
