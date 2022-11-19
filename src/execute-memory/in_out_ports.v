/*
* This module is responsible for input and output ports
* =============================================
* Test Status = OK
*/

module in_out_ports (
    input             i_port_signal,       // input port signal    
    input             o_port_signal,       // output port signal 
    input             i_clk,               // ports clock
    input  reg [15:0] i_data_to_out_port,  //input data to the output port
    output reg [15:0] o_data_from_in_port  //output data from the input port
);

  reg [15:0] output_port;  //the output port will hold the data if the output port siganl = 1 and still unchanged till output port siganl = 1 again

  always @(posedge i_clk) begin

    if (i_port_signal) begin  //if input port siganl = 1 ==> out the holding data
      o_data_from_in_port = output_port;
    end else begin  // else ==> not to out the data
      o_data_from_in_port = 16'b0000_0000_0000_0000;
    end

    if (o_port_signal) begin                   //if output port siganl = 1 ==> hold the new data and still unchanged till output port siganl = 1 again
      output_port = i_data_to_out_port;
    end
  end

endmodule

/*
vsim work.in_out_ports
add wave sim:/in_out_ports/*
force -freeze sim:/in_out_ports/i_data_to_out_port 0000_0000_1111_0000 0
force -freeze sim:/in_out_ports/i_port_signal 1 0
force -freeze sim:/in_out_ports/o_port_signal 1 0
run
force -freeze sim:/in_out_ports/i_port_signal 0 0
force -freeze sim:/in_out_ports/o_port_signal 1 0
run
force -freeze sim:/in_out_ports/i_port_signal 1 0
force -freeze sim:/in_out_ports/o_port_signal 0 0
run
force -freeze sim:/in_out_ports/i_port_signal 1 0
force -freeze sim:/in_out_ports/o_port_signal 1 0
run

*/
