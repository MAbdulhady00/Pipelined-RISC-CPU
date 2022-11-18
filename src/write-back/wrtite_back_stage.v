module write_back_stage (
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
    output [15:0] o_write_data,
    output o_write_back
);
  assign o_write_back = i_write_back;
  assign o_write_addr = i_write_addr;
  assign o_write_data = (i_wb_selector == 2'b00) ? i_ex_result:
                        (i_wb_selector == 2'b01) ? i_port:
                        (i_wb_selector == 2'b10) ? i_immediate: i_memory_data;
endmodule
