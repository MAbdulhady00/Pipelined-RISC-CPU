module control_unit (
    input wire [4:0] i_op_code,
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
    output reg o_shamt,
    output reg o_output_port,
    output reg o_pop_pc,
    output reg o_push_pc,
    output reg o_branch_flags,
    output reg o_read1,
    output reg o_read2,
    output reg o_hazard_instruction
);

  always @(*) begin
    o_alu_function = 3'b000;
    o_wb_selector = 2'b00;
    o_branch_selector = 2'b00;
    o_mov = 1'b0;
    o_write_back = 1'b0;
    o_inc_dec = 1'b0;
    o_change_carry = 1'b0;
    o_carry_value = 1'b0;
    o_mem_read = 1'b0;
    o_mem_write = 1'b0;
    o_stack_operation = 1'b0;
    o_stack_function = 1'b0;
    o_branch_operation = 1'b0;
    o_branch_selector = 1'b0;
    o_imm = 1'b0;
    o_shamt = 1'b0;
    o_output_port = 1'b0;
    o_pop_pc = 1'b0;
    o_push_pc = 1'b0;
    o_branch_flags = 1'b0;
    o_read1 = 1'b1;
    o_read2 = ~i_op_code[4];  // RTYPE
    o_hazard_instruction = 1'b0;

    case (i_op_code)
      5'b00000: begin  // NOP
        o_read1 = 1'b0;
        o_read2 = 1'b0;
      end
      5'b00001,  // UNUSED
      5'b00010: begin  // RET
        o_mem_read = 1'b1;
        o_pop_pc = 1'b1;
        // o_stack_function = 1'b0;
        o_stack_operation = 1'b1;
        o_hazard_instruction = 1'b1;
      end
      5'b00011: begin  // RTI
        o_mem_read = 1'b1;
        o_pop_pc = 1'b1;
        // o_stack_function = 1'b0;
        o_stack_operation = 1'b1;
        o_branch_flags = 1'b1;
      end
      5'b00100,  // UNUSED
      5'b00101: begin  // CALL
        o_mem_write = 1'b1;
        o_push_pc = 1'b1;
        o_stack_function = 1'b1;
        o_stack_operation = 1'b1;
        // o_branch_flags = i_interrupt;
        o_branch_operation = 1'b1;
        o_branch_selector = 2'b11;  // jump unconditionally to register
        o_hazard_instruction = 1'b1;
      end
      5'b00110: begin  // CLRC
        o_change_carry = 1'b1;
        // o_carry_value = 1'b0;
      end
      5'b00111: begin  // SETC
        o_change_carry = 1'b1;
        o_carry_value  = 1'b1;
      end
      5'b01000: begin  // MOV
        // o_wb_selector = 2'b00;
        o_write_back = 1'b1;
        // o_alu_function = 3'b000;
        o_mov = 1'b1;
      end
      5'b01001: begin  // NOT
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b001;
      end
      5'b01010: begin  // ADD
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b010;
      end
      5'b01011: begin  // SUB
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b011;
      end
      5'b01100: begin  // AND
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b100;
      end
      5'b01101: begin  // OR
        // o_wb_selector = 2'b00;
        o_write_back   = 1'b1;
        o_alu_function = 3'b101;
      end
      5'b01110: begin  // INC
        // o_wb_selector = 2'b00;
        o_write_back = 1'b1;
        o_alu_function = 3'b010;
        o_inc_dec = 1'b1;
      end
      5'b01111: begin  // DEC
        o_write_back = 1'b1;
        o_alu_function = 3'b011;
        o_inc_dec = 1'b1;
      end

      5'b10000: begin  // STD
        o_mem_write = 1'b1;
        o_read2 = 1'b1;
      end
      5'b10001,  // UNUSED
      5'b10010: begin  // LDM
        o_imm = 1'b1;
        o_write_back = 1'b1;
        o_wb_selector = 2'b10;
        o_hazard_instruction = 1'b1;
      end
      5'b10011: begin  // LDD
        o_mem_read = 1'b1;
        o_write_back = 1'b1;
        o_wb_selector = 2'b11;
        o_read2 = 1'b1;
      end
      5'b10100: begin  // PUSH
        o_mem_write = 1'b1;
        o_stack_function = 1'b1;
        o_stack_operation = 1'b1;
      end
      5'b10101,  // UNUSED
      5'b10110,  // UNUSED
      5'b10111: begin  // POP
        o_mem_read = 1'b1;
        o_write_back = 1'b1;
        o_wb_selector = 2'b11;
        // o_stack_function = 1'b0;
        o_stack_operation = 1'b1;
      end
      5'b11000: begin  // JZ
        o_branch_operation   = 1'b1;
        // o_branch_selector  = 2'b00;
        o_hazard_instruction = 1'b1;
      end
      5'b11001: begin  // JN
        o_branch_operation = 1'b1;
        o_branch_selector = 2'b01;
        o_hazard_instruction = 1'b1;
      end
      5'b11010: begin  // JC
        o_branch_operation = 1'b1;
        o_branch_selector = 2'b10;
        o_hazard_instruction = 1'b1;
      end
      5'b11011: begin  // JMP
        o_branch_operation = 1'b1;
        o_branch_selector = 2'b11;
        o_hazard_instruction = 1'b1;
      end
      5'b11100: begin  // IN
        o_write_back  = 1'b1;
        o_wb_selector = 2'b01;
      end
      5'b11101: begin  // OUT
        o_output_port = 1'b1;
      end
      5'b11110: begin  // SHL
        o_write_back = 1'b1;
        // o_wb_selector = 2'b00;
        o_shamt = 1'b1;
        o_alu_function = 3'b110;
      end
      5'b11111: begin  // SHR
        o_write_back = 1'b1;
        // o_wb_selector = 2'b00;
        o_shamt = 1'b1;
        o_alu_function = 3'b111;
      end
    endcase

    if (i_interrupt) begin
      o_mem_write = 1'b1;
      o_push_pc = 1'b1;
      o_stack_function = 1'b1;
      o_stack_operation = 1'b1;
      o_branch_flags = 1'b1;
    end
  end

endmodule
