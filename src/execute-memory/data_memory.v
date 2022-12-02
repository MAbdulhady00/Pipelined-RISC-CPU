/*
* This module is responsible for read from or write to an address in the data memory
* =============================================
* Test Status = OK
*/

module data_memory (
    input      [15:0] i_address,       //the address that you want to write or read from
    input      [15:0] i_write_data,    //the data that you want to write on memory
    input             i_memory_read,   //the memory read control signal
    input             i_memory_write,  //the memory write control signal
    input             i_clk,           // memory clock
    output reg [15:0] o_read_data      //the data that you want to read from memory
);

  reg [15:0] memory[2**12 -1 : 0];  //the size of the memory is 4KB

  integer i;

  initial begin
    for (i = 0; i <= 2 ** 12 - 1; i = i + 1) memory[i] = 8'h0000;
    $readmemh("./data.txt", memory);
  end

  always @(negedge i_clk) begin
    if (i_memory_write) begin
      memory[i_address] <= i_write_data;
    end
    if (i_memory_read) begin
      o_read_data = memory[i_address];
    end
  end

endmodule

/*
vsim work.data_memory
add wave sim:/data_memory/*
force -freeze sim:/data_memory/i_address 0000_0000_0001_0000 0
force -freeze sim:/data_memory/i_write_data 0000_1010_0000_0000 0
force -freeze sim:/data_memory/i_memory_read 0 0
force -freeze sim:/data_memory/i_memory_write 1 0
run
force -freeze sim:/data_memory/i_memory_read 1 0
force -freeze sim:/data_memory/i_memory_write 0 0
run
*/
