/**
* This module is responsible for intterup hold FF
* When a 0 -> 1 transition happens in intterupt signal
* it will output a call signal to insert a interrupt call
* instruction
* =============================================
* Test Status = tested
*/

module interrupt_hold (
    input i_interrupt_signal,
    input i_clk,
    input i_enable,
    input i_reset,
    output reg o_interrupt_call
);

  reg interrupt_ff = 0;

  always @(posedge i_clk) begin
    interrupt_ff <= i_interrupt_signal;
    if (i_reset) o_interrupt_call <= 1'b0;
    else if (i_enable) o_interrupt_call <= ~interrupt_ff & i_interrupt_signal;
  end

endmodule

// add wave -position insertpoint  \
// sim:/interrupt_hold/i_interrupt_signal \
// sim:/interrupt_hold/i_clk \
// sim:/interrupt_hold/i_enable \
// sim:/interrupt_hold/o_interrupt_call \
// sim:/interrupt_hold/interrupt_ff
// force -freeze sim:/interrupt_hold/i_interrupt_signal 0 0
// force -freeze sim:/interrupt_hold/i_clk 1 0, 0 {50 ps} -r 100
// force -freeze sim:/interrupt_hold/i_enable 1 0
// run
// force -freeze sim:/interrupt_hold/i_interrupt_signal 1 0
// run
