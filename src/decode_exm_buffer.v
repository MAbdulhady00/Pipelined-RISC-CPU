// TODO: flush & stall inputs
module decode_exm_buffer (
    input i_clk,
    input i_reset,
    input [2:0] i_alu_function,
    input [1:0] i_wb_selector,
    input [2:0] i_branch_selector,
    input i_mov,
    input i_write_back,
    input i_inc_dec,
    input i_change_carry,
    input i_carry_value,
    input i_mem_read,
    input i_mem_write,
    input i_stack_operation,
    input i_stack_function,
    input i_branch_operation,
    input i_imm,
    input i_input_port,
    input i_pop_pc,
    input i_push_pc,
    input i_branch_flags,
    input [15:0] i_data1,
    input [15:0] i_data2,
    input [2:0] i_rd,
    input [2:0] i_rs,
    output reg [2:0] o_alu_function,
    output reg [1:0] o_wb_selector,
    output reg [2:0] o_branch_selector,
    output reg o_mov,
    output reg o_write_back,
    output reg o_inc_dec,
    output reg o_change_carry,
    output reg o_carry_value,
    output reg o_mem_read,
    output reg o_mem_write,
    output reg o_stack_operation,
    output reg o_stack_function,
    output reg o_branch_operation,
    output reg o_imm,
    output reg o_output_port,
    output reg o_pop_pc,
    output reg o_push_pc,
    output reg o_branch_flags,
    output reg [15:0] o_data1,
    output reg [15:0] o_data2,
    output reg [2:0] o_rd,
    output reg [2:0] o_rs
);
  always @(posedge i_clk) begin
    if (i_reset) begin 
        o_alu_function <= 3'b0;
        o_wb_selector <= 2'b0;
        o_branch_selector <= 3'b0;
        o_mov <= 1'b0;
        o_write_back <= 1'b0;
        o_inc_dec <= 1'b0;
        o_change_carry <= 1'b0;
        o_carry_value <= 1'b0;
        o_mem_read <= 1'b0;
        o_mem_write <= 1'b0;
        o_stack_operation <= 1'b0;
        o_stack_function <= 1'b0;
        o_branch_operation <= 1'b0;
        o_imm <= 1'b0;
        o_input_port <= 1'b0;
        o_pop_pc <= 1'b0;
        o_push_pc <= 1'b0;
        o_branch_flags <= 1'b0;
        o_data1 <= 16'b0;
        o_data2 <= 16'b0;
        o_rd <= 3'b0;
        o_rs <= 3'b0;
    end
    else begin
     o_alu_function <= i_alu_function;
     o_wb_selector <= i_wb_selector;
     o_branch_selector <= i_branch_selector;
     o_mov <= i_mov;
     o_write_back <= i_write_back;
     o_inc_dec <= i_inc_dec;
     o_change_carry <= i_change_carry;
     o_carry_value <= i_carry_value;
     o_mem_read <= i_mem_read;
     o_mem_write <= i_mem_write;
     o_stack_operation <= i_stack_operation;
     o_stack_function <= i_stack_function;
     o_branch_operation <= i_branch_operation;
     o_imm <= i_imm;
     o_input_port <= i_input_port;
     o_pop_pc <= i_pop_pc;
     o_push_pc <= i_push_pc;
     o_branch_flags <= i_branch_flags;
     o_data1 <= i_data1;
     o_data2 <= i_data2;
     o_rd <= i_rd;
     o_rs <= i_rs;
    end
  end
endmodule
