module register_file (
    input i_clk,
    input i_reset,
    input i_read1,
    input i_read2,
    input [2:0] i_read_addr1,
    input [2:0] i_read_addr2,
    input i_write,
    input [2:0] i_write_addr,
    input [15:0] i_write_data,
    output reg [15:0] o_data1,
    output reg [15:0] o_data2
);

  reg [7:0] read_enable;
  reg [7:0] write_enable;
  wire [15:0] reg_out[7:0];

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin
      rf_register r (
          .i_clk(i_clk),
          .i_reset(i_reset),
          .i_read_enable(read_enable[i]),
          .i_write_enable(write_enable[i]),
          .i_data(i_write_data),
          .o_data(reg_out[i])
      );
    end
  endgenerate

  always @(*) begin
    read_enable = 8'b0;
    write_enable = 8'b0;
    o_data1 = reg_out[i_read_addr1];
    o_data2 = reg_out[i_read_addr2];

    if (i_write) write_enable[i_write_addr] = 1'b1;

    if (i_read1) read_enable[i_read_addr1] = 1'b1;

    if (i_read2) read_enable[i_read_addr2] = 1'b1;
  end


endmodule

// vsim work.register_file
// add wave -position insertpoint  \
// sim:/register_file/i_clk \
// sim:/register_file/i_reset \
// sim:/register_file/i_read1 \
// sim:/register_file/i_read2 \
// sim:/register_file/i_read_addr1 \
// sim:/register_file/i_read_addr2 \
// sim:/register_file/i_write \
// sim:/register_file/i_write_addr \
// sim:/register_file/i_write_data \
// sim:/register_file/o_data1 \
// sim:/register_file/o_data2
// force -freeze sim:/register_file/i_clk 1 0, 0 {50 ps} -r 100
// force -freeze sim:/register_file/i_reset 1 0
// force -freeze sim:/register_file/i_read1 1 0
// force -freeze sim:/register_file/i_read2 1 0
// force -freeze sim:/register_file/i_read_addr1 0 0
// force -freeze sim:/register_file/i_read_addr2 1 0
// force -freeze sim:/register_file/i_write 0 0
// force -freeze sim:/register_file/i_write_addr 0 0
// force -freeze sim:/register_file/i_write_data 0 0
// run
// force -freeze sim:/register_file/i_reset 0 0
// force -freeze sim:/register_file/i_write 1 0
// force -freeze sim:/register_file/i_write_addr 000 0
// force -freeze sim:/register_file/i_write_data 0000000001100000 0
// run
