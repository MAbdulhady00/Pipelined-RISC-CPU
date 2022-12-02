/*
* This module is responsible for read from an address in the instructions memory
* =============================================
* Test Status = Not Yet
*/

module instructions_memory (
    input      [31:0] i_address,   //the address that you want to read from
    input             i_enable,    //the memory enable control signal
    input             i_clk,
    output reg [15:0] o_read_data  //the data that you want to read from memory
);

  reg [15:0] memory[2**21 -1 : 0];  //the size of the memory is 2MB

  integer i;

  initial begin
    for (i = 0; i <= 2 ** 21 - 1; i = i + 1) memory[i] = 8'h0000;
    $readmemh("./instruction_data.txt", memory);
  end

  always @(negedge i_clk) begin
    if (i_enable) begin
      o_read_data = memory[i_address];
    end
  end

endmodule
