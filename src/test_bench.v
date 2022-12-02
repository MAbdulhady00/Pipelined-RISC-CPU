module test_bench ( );
  
  // fetch stage
  
  wire [15:0] ftch_instr;
  reg [15:0] instruction_memory[2**21 -1 : 0];  //the size of the memory is 2MB
  // decode stage
  
  wire [15:0] decode_instr;
  wire [2:0] decode_alu_function;
  wire [1:0] decode_wb_selector;
  wire [2:0] decode_branch_selector;
  wire decode_write_back;
  wire decode_inc_dec;
  wire decode_mem_read;
  wire decode_mem_write;
  wire decode_imm;
  wire [15:0] decode_data1;
  wire [15:0] decode_data2;
  wire [2:0] decode_rd;
  wire [2:0] decode_rs;

  // EXM stage

  wire [2:0] exm_write_addr;
  wire [15:0] exm_immediate;  // to write back buffer
  wire [15:0] exm_memory_data;  // Data read from the memory
  wire [15:0] exm_ex_result;
  wire exm_zero_flag;  // zero flag
  wire exm_negative_flag;  // negative flag
  wire exm_carry_flag;  // carry flag 
  wire [1:0] exm_wb_selector;
  wire exm_write_back;
  wire [15:0] exm_port;
  wire [2:0] exm_i_write_addr;
  wire [2:0] exm_i_alu_function;

  wire exm_i_write_back;
  wire exm_i_inc_dec;
  wire exm_i_mem_read;
  wire exm_i_mem_write;
  wire exm_i_imm;
  wire [15:0] exm_i_data1;
  wire [15:0] exm_i_data2;
  wire [2:0] exm_i_rd;
  wire [2:0] exm_i_rs;
  reg [15:0] data_memory[2**12 -1 : 0];  //the size of the memory is 4KB
  // write back stage
  
  wire [1:0] wb_i_wb_selector;
  wire wb_i_write_back;
  wire [15:0] wb_i_ex_result;
  wire [15:0] wb_i_memory_data;
  wire [15:0] wb_i_immediate;
  wire [2:0] wb_i_reg_addr;

  reg wb_write_back;
  wire [2:0] wb_write_addr;
  wire [15:0] wb_write_data;

  reg i_clk;
  reg i_reset;

  fetch_stage ftch ( 1'b0 , i_clk , i_reset ,ftch_instr) ;

  fetch_decode_buffer ftch_decode_buff (
      .i_clk  (i_clk),
      .i_reset(i_reset),
      .i_instr(ftch_instr),
      .o_instr(decode_instr)
  );
  
decode_stage ds (
      .i_instr(decode_instr),
      .i_reset(i_reset),
      .i_clk(i_clk),
      .i_interrupt(1'b0),
      .i_write_back(wb_write_back),
      .i_write_addr(wb_write_addr),
      .i_write_data(wb_write_data),
      .o_alu_function(decode_alu_function),
      .o_mem_read(decode_mem_read),
      .o_mem_write(decode_mem_write),
      .o_imm(decode_imm),
      .o_output_port(decode_output_port),
      .o_data1(decode_data1),
      .o_data2(decode_data2),
      .o_rd(decode_rd),
      .o_rs(decode_rs)
  );
  wire ldm;
  assign ldm = i_reset | exm_i_imm;
  decode_exm_buffer decode_exm_buff (
      .i_clk(i_clk),
      .i_reset(ldm),
      .i_alu_function(decode_alu_function),
      .i_wb_selector(decode_wb_selector),
      .i_mov(decode_mov),
      .i_write_back(decode_write_back),
      .i_inc_dec(decode_inc_dec),
      .i_mem_read(decode_mem_read),
      .i_mem_write(decode_mem_write),
      .i_imm(decode_imm),
      .i_input_port(1'b0),
      .i_data1(decode_data1),
      .i_data2(decode_data2),
      .i_rd(decode_rd),
      .i_rs(decode_rs),
      .o_input_port(decode_input_port),
      .o_alu_function(exm_i_alu_function),
      .o_wb_selector(exm_i_wb_selector),
      .o_imm(exm_i_imm),
      .o_data1(exm_i_data1),
      .o_data2(exm_i_data2),
      .o_rd(exm_i_rd),
      .o_rs(exm_i_rs)
  );
  
  exm_stage em (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_alu_function(exm_i_alu_function),
      .i_mem_read(exm_i_mem_read),
      .i_mem_write(exm_i_mem_write),
      .i_imm(exm_i_imm),
      .i_data1(exm_i_data1),
      .i_data2(exm_i_data2),
      .i_rd(exm_i_rd),
      .i_rs(exm_i_rs),
      .i_data_wb(wb_write_data),  // actual result data coming from the write back stage
      .i_immediate(decode_instr),  // instruction data from decode stage
      .i_write_addr(exm_i_write_addr),
      .o_write_addr(exm_write_addr),
      .o_immediate(exm_immediate),  // to write back buffer
      .o_memory_data(exm_memory_data),  // Data read from the memory
      .o_ex_result(exm_ex_result),
      .o_wb_selector(exm_wb_selector),
      .o_write_back(exm_write_back)
  );

  exm_write_back_buffer exm_wb_buff (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_ex_result(exm_ex_result),
      .i_memory_data(exm_memory_data),
      .i_immediate(exm_immediate),
      .i_write_back(exm_write_back),
      .i_write_addr(exm_write_addr),
      .o_write_addr(wb_i_reg_addr),
      .o_ex_result(wb_i_ex_result),
      .o_memory_data(wb_i_memory_data),
      .o_immediate(wb_i_immediate),
      .o_wb_selector(wb_i_wb_selector),
      .o_write_back(wb_i_write_back)
  );

  write_back_stage wb (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_ex_result(wb_i_ex_result),
      .i_memory_data(wb_i_memory_data),
      .i_immediate(wb_i_immediate),
      .i_write_addr(wb_i_reg_addr),
      .o_write_data(wb_write_data),
      .o_write_addr(wb_write_addr)
  );

always #50 i_clk=~i_clk;

initial begin
$display( " ---------------------------------------------------- START OF SIMULATION ---------------------------------------------------- " );
i_reset=1'b1;
i_clk=1'b1;
#50
i_reset=1'b0;
#50
//------------------------------------------------------- fetch decode buffer-----------------------------------------------------------//

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( ftch_instr == 9216 ) begin
	$display( "Fetch #1 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #1 : FAILED  \n" ) ;
end

//Second stage : decode
wb_write_back=1'b1;
#50
//------------------------------------------------------- decode -----------------------------------------------------------//
#50
//------------------------------------------------------- decode execute buffer-----------------------------------------------------------//

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( ftch_instr == 0 ) begin
	$display( "Fetch #2 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #2 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 1 ) begin
	$display( "Decode #2 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #2 : FAILED  \n" ) ;
end

//Third stage : execute and memory stage
#50
#50
//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( ftch_instr == 10240 ) begin
	$display( "Fetch #3 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #3 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #3 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #3 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 1 && $signed(exm_immediate) == 0 ) begin
	$display( "ExecuteMemory#3 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#3 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( ftch_instr == 2 ) begin
	$display( "Fetch #4 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #4 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 2 ) begin
	$display( "Decode #4 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #4 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == 10240 ) begin
	$display( "ExecuteMemory#4 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#4 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == 0  ) begin
	$display( "Writeback#4 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#4 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -24576 ) begin
	$display( "Fetch #5 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #5 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #5 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #5 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 2 && $signed(exm_immediate) == 2 ) begin
	$display( "ExecuteMemory#5 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#5 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == 10240  ) begin
	$display( "Writeback#5 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#5 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == 26752 ) begin
	$display( "Fetch #6 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #6 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #6 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #6 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == -24576 ) begin
	$display( "ExecuteMemory#6 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#6 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == 2  ) begin
	$display( "Writeback#6 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#6 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -31744 ) begin
	$display( "Fetch #7 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #7 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 2 && decode_rs == 1 && decode_rd == 2 ) begin
	$display( "Decode #7 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #7 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == 26752 ) begin
	$display( "ExecuteMemory#7 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#7 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == -24576  ) begin
	$display( "Writeback#7 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#7 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -24576 ) begin
	$display( "Fetch #8 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #8 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 1 && decode_rs == 0 && decode_rd == 1 ) begin
	$display( "Decode #8 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #8 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 1 && exm_i_rd== 2 && $signed(exm_immediate) == -31744 ) begin
	$display( "ExecuteMemory#8 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#8 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == 26752  ) begin
	$display( "Writeback#8 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#8 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -24576 ) begin
	$display( "Fetch #9 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #9 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #9 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #9 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 1 && $signed(exm_immediate) == -24576) begin
	$display( "ExecuteMemory#9 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#9 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == -31744  ) begin
	$display( "Writeback#9 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#9 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -24576 ) begin
	$display( "Fetch #10 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #10 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #10 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #10 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == -24576) begin
	$display( "ExecuteMemory#10 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#10 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) == -24576  ) begin
	$display( "Writeback#10 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#10 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == -24576 ) begin
	$display( "Fetch #11 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #11 : FAILED  \n" ) ;
end


//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #11 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #11 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == -24576) begin
	$display( "ExecuteMemory#11 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#11 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) ==  -24576 ) begin
	$display( "Writeback#11 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#11 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- fetch -----------------------------------------------------------//
$display( "ftch_instr = %h, ",ftch_instr);
if ( $signed(ftch_instr) == 18560 ) begin
	$display( "Fetch #12 : SUCCESS  \n" ) ;
end
else begin
	$display( "Fetch #12 : FAILED  \n" ) ;
end

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 0 && decode_rd == 0 ) begin
	$display( "Decode #12 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #12 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == -24576) begin
	$display( "ExecuteMemory#12 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#12 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) ==  -24576 ) begin
	$display( "Writeback#12 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#12 : FAILED  \n" ) ;
end

#50
#50

//------------------------------------------------------- decode -----------------------------------------------------------//
$display( " decode_alu_function=%d, decode_rs=%d,decode_rd=%d, "  ,  decode_alu_function ,  decode_rs , decode_rd ) ;
if ( decode_alu_function == 0 && decode_rs == 1 && decode_rd == 2 ) begin
	$display( "Decode #13 : SUCCESS  \n" ) ;
end
else begin
	$display( "Decode #13 : FAILED  \n" ) ;
end

//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 0 && exm_i_rd== 0 && $signed(exm_immediate) == 18560) begin
	$display( "ExecuteMemory#13 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#13 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) ==  -24576 ) begin
	$display( "Writeback#13 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#13 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- execute memory -----------------------------------------------------------//
$display( " exm_i_rs=%d , exm_i_rd=%d , exm_immediate=%d "  , exm_i_rs , exm_i_rd , exm_immediate) ;
if ( exm_i_rs== 1 && exm_i_rd== 2 && $signed(exm_immediate) == 0) begin
	$display( "ExecuteMemory#14 : SUCCESS  \n" ) ;
end
else begin
	$display( "ExecuteMemory#14 : FAILED  \n" ) ;
end

//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) ==  18560 ) begin
	$display( "Writeback#14 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#14 : FAILED  \n" ) ;
end

#50
#50
//------------------------------------------------------- write back -----------------------------------------------------------//
$display( " wb_i_immediate=%d, "  , wb_i_immediate ) ;
// memory write back buffer
if ( $signed(wb_i_immediate) ==  0 ) begin
	$display( "Writeback#15 : SUCCESS  \n" ) ;
end
else begin
	$display( "Writeback#15 : FAILED  \n" ) ;
end

end

endmodule
