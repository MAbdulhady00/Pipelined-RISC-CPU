//
// Check verilog_tips.pdf for common dos and don'ts
//

// use snake_case for variable and module names
module module_name #(
    // use CAPITAL_CASE for parameters
    parameter PARAM_NAME = 0
) (
    // prefix i_ for inputs
    input i_my_input,
    input i_clk,
    // prefix o_ for outputs
    output reg o_my_output
    // use output reg for outputs, input wire is optional
    // note this doesn't always result in a register
    // but we use it nonetheless
);
  // use CAPITAL_CASE for constants
  localparam BIT_WIDTH = 16;

  // local variable
  reg [BIT_WIDTH-1:0] local_wire;
  reg [BIT_WIDTH-1:0] local_temp;
  reg read_sample;

  // using always blocks for combinational logic
  // use = for combinational logic
  always @(*) begin
    case (local_wire)
      16'b0000_1111_0000_1111: local_temp = 0;
      16'b0000_1111_1111_1111: local_temp = 1;

      // include a default case if all branches 
      // in case/if statements are not covered
      // this is done in order to avoid accidental latches
      default: local_temp = 3;
    endcase
  end

  // can also use assign for combinational logic
  // do not mix design and always @(*)in the same file

  always @(posedge i_clk) begin
    // use <= for synchronized elements (dealing with registers)
    o_my_output <= local_temp;
  end

  always @(negedge i_clk) begin
    // use <= for synchronized elements (dealing with registers)
    read_sample <= o_my_output;
  end
endmodule
