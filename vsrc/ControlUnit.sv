`ifndef __CONTROLUNIT_SV
`define __CONTROLUNIT_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module ControlUnit import common::*;(
    input zero,
    input [31:0] inst,
    output logic [4:0] alu_op,
    output logic [63:0] imm,
    output logic aluimm, jump, branch, u, reg_write, mem_read, mem_write
    );
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] op = inst[6:0], funct7 = inst[31:25];

    always_comb begin
    aluimm = 1;
    branch = 0;
    case (op)
    7'b0010011: begin // I-type
        imm = {{52{inst[31]}}, inst[31:20]};
        reg_write = 1;
        case (funct3)
        3'b000: alu_op = ADD; // addi
        3'b001: alu_op = SLL; // slli
        3'b010: alu_op = SLT; // slti
        3'b011: alu_op = SLTU; // sltiu
        3'b100: alu_op = _XOR; // xori
        3'b101: alu_op = inst[30] ? SRA : SRL; // srli, srai
        3'b110: alu_op = _OR; // ori
        3'b111: alu_op = _AND; // andi
        endcase
    end
    7'b0011011: begin // I-type
        imm = {{52{inst[31]}}, inst[31:20]};
        reg_write = 1;
        case (funct3)
        3'b000: alu_op = ADDW; // addiw
        3'b001: alu_op = SLLW; // slliw
        3'b101: alu_op = inst[30] ? SRAW : SRLW; // srliw, sraiw
        default: alu_op = ADDW;
        endcase
    end
    7'b0110011: begin // R-type
        aluimm = 0;
        reg_write = 1;
        case ({funct3, funct7})
            10'b000_0000000: alu_op = ADD;  // add
            10'b001_0000000: alu_op = SLL;  // sll
            10'b010_0000000: alu_op = SLT;  // slt
            10'b011_0000000: alu_op = SLTU; // sltu
            10'b100_0000000: alu_op = _XOR; // xor
            10'b101_0000000: alu_op = SRL;  // srl
            10'b110_0000000: alu_op = _OR;  // or
            10'b111_0000000: alu_op = _AND; // and

            10'b000_0100000: alu_op = SUB;  // sub
            10'b101_0100000: alu_op = SRA ; // sra
            
            10'b000_0000001: alu_op = MUL;  // mul
            10'b100_0000001: alu_op = DIV;  // div
            10'b101_0000001: alu_op = DIVU; // divu
            10'b110_0000001: alu_op = REM;  // rem
            10'b111_0000001: alu_op = REMU; // remu
            default: alu_op = ADD;
        endcase
    end
    7'b0111011: begin // R-type
        aluimm = 0;
        reg_write = 1;
        case ({funct3, funct7})
            10'b000_0000000: alu_op = ADDW; // addw
            10'b001_0000000: alu_op = SLLW; // sllw
            10'b101_0000000: alu_op = SRLW; // srlw

            10'b000_0100000: alu_op = SUBW; // subw
            10'b101_0100000: alu_op = SRAW; // sraw

            10'b000_0000001: alu_op = MULW; // mulw
            10'b100_0000001: alu_op = DIVW; // divw
            10'b101_0000001: alu_op = DIVUW;// divuw
            10'b110_0000001: alu_op = REMW; // remw
            10'b111_0000001: alu_op = REMUW;// remuw
            default: begin end
        endcase
    end
    7'b0110111: begin // lui
        imm = {{32{inst[31]}}, inst[31:12], 12'b0};
        reg_write = 1;
        alu_op = CPYB;
    end
    7'b1101111: begin // jal
        branch = 1;
        imm = {{44{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
        reg_write = 1;
        alu_op = ADD;
    end
    7'b0010111: begin // auipc
        imm = {{32{inst[31]}}, inst[31:12], 12'b0};
        reg_write = 1;
        alu_op = ADD;
    end
    7'b1100011: begin // B-type
        aluimm = 0; // imm here is acutally offset.
        imm = {{52{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
        reg_write = 0;
        case (funct3)
            3'b000: begin alu_op = SUB; branch = zero; end// beq
            3'b001: begin alu_op = SUB; branch = !zero; end // bne
            3'b010, 3'b011: begin end
            3'b100: begin alu_op = SLT; branch = !zero; end // blt
            3'b101: begin alu_op = SLT; branch = zero; end // bge
            3'b110: begin alu_op = SLTU; branch = !zero; end // bltu
            3'b111: begin alu_op = SLTU; branch = zero;end // bgeu
        endcase
    end
    7'b1100111: if(funct3 == 3'b000) begin // jalr
        imm = {{52{inst[31]}}, inst[31:20]};
        reg_write = 1;
        alu_op = ADD;
    end
    7'b0000011: begin // I-type
        imm = {{52{inst[31]}}, inst[31:20]};
        reg_write = 0; // 用 mem_read 替代
        alu_op = ADD;
    end
    7'b0100011: begin // S-type
        imm = {{52{inst[31]}}, inst[31:25], inst[11:7]};
        reg_write = 0;
        alu_op = ADD;
    end
    default: alu_op = ADD;
    endcase
    end 
    assign jump = op == 7'b1101111 || {funct3, op} == 'b000_1100111;
    assign u = op == 7'b0010111;
    assign mem_read = op == 7'b0000011;
    assign mem_write = op == 7'b0100011;
endmodule

`endif