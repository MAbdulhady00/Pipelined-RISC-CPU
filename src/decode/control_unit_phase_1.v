module control_unit_phase_1 (
    input wire [2:0] i_op_code,
    input wire i_interrupt,
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
    output reg o_read1,
    output reg o_read2
);

  always @(*) begin
    o_alu_function = 3'b000;
    o_wb_selector = 2'b00;
    o_write_back = 1'b0;
    o_mem_read = 1'b0;
    o_mem_write = 1'b0;
    o_imm = 1'b0;
    o_read1 = 1'b1;
    o_read2 = 1'b1;

    case (i_op_code)
      3'b101: begin  // NOP
        o_read1 = 1'b0;
        o_read2 = 1'b0;
      end
      3'b100: begin  // NOT
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b001;
      end
      3'b011: begin  // ADD
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b010;
      end
      3'b010: begin  // STD
        o_mem_write = 1'b1;
        o_read2 = 1'b1;
      end
      3'b001: begin  // LDM
        o_imm = 1'b1;
        o_write_back = 1'b1;
        o_wb_selector = 2'b10;
      end

    endcase
  end

endmodule
