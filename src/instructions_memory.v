/*
* This module is responsible for read from an address in the instructions memory
* =============================================
* Test Status = Not Yet
*/

module instructions_memory (
    input             i_clk,           // Clock Signal   
    input      [31:0] i_address,       //the address that you want to read from
    input             i_enable,        //the memory enable control signal
    output reg [15:0] o_read_data      //the data that you want to read from memory
);

  reg [15:0] memory[2**21 -1 : 0];  //the size of the memory is 2MB
  always @(posedge i_clk) begin
    if (i_enable) begin
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
