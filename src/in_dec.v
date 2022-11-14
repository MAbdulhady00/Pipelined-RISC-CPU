
module in_dec
(
 input [31:0]i_stack_pointer_before ,
 input i_flag_inc_dec ,
 input i_flag_1_2 ,
 output reg [31:0]o_stack_pointer_after 
);

always@(*) begin
	if( i_flag_inc_dec == 0'b0 ) begin //if flag= 0 ==> add to stack pointer ( pop )
		if( i_flag_1_2 == 0'b0 )
			o_stack_pointer_after = i_stack_pointer_before  + 1'b1;
		else
			o_stack_pointer_after = i_stack_pointer_before  + 2'b10;
	end	
	else begin	           //if flag= 1 ==> subtract from stack pointer ( push )	
		if( i_flag_1_2 == 0'b0 )
			o_stack_pointer_after = i_stack_pointer_before  - 1'b1;
		else
			o_stack_pointer_after = i_stack_pointer_before  - 2'b10;
	end
end
endmodule

/*

vsim work.in_dec
add wave sim:/in_dec/*
force -freeze sim:/in_dec/i_stack_pointer_before 1111_0000_0000_0000_0000_0000_0000_0100 0
force -freeze sim:/in_dec/i_flag_inc_dec 0 0
force -freeze sim:/in_dec/i_flag_1_2 0 0
run

*/