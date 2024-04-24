`ifndef __DECODER_SV
`define __DECODER_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else
`endif 

module decoder 
    import common::*;
    import pipes::*;(
    input [31:0] raw_instr,
    output decode_op_t op,
	output alufunc_t alufunc,
	output logic regwrite
);

    wire [6:0] funct7 =    raw_instr[6:0];
    wire [2:0] funct3 =    raw_instr[14:12];
    wire [6:0] f7_first =  raw_instr[31:25];

    always_comb begin
        op = ALUI;
        alufunc = ALU_ADD;
        regwrite = 1'b1;

        unique case(funct7)
            F7_ALUI: begin
                op = ALUI;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: alufunc = ALU_ADD;
                    F3_XOR: alufunc = ALU_XOR;
                    F3_OR: alufunc = ALU_OR;
                    F3_AND: alufunc = ALU_AND;
                    F3_SLT: alufunc = ALU_SLT;
                    F3_SLTU: alufunc = ALU_SLTU;
                    F3_SLL: alufunc = ALU_SLL;
                    F3_SR: begin
                        if (raw_instr[30])
                            alufunc = ALU_SRA;
                        else
                            alufunc = ALU_SRL;
                    end
                endcase 
            end

            F7_ALU: begin
                op = ALU;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ALU_ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = ALU_SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_MULT;
                    end
                    F3_XOR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_DIV;
                        else
                            alufunc = ALU_XOR;
                    end
                    F3_OR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_REM;
                        else
                            alufunc = ALU_OR;
                    end
                    F3_AND: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_REMU;
                        else
                            alufunc = ALU_AND;
                    end
                    F3_SLT: alufunc = ALU_SLT;
                    F3_SLTU: alufunc = ALU_SLTU;
                    F3_SLL: alufunc = ALU_SLL;
                    F3_SR: begin
                        if (f7_first == F7_FIRST_SUB)
                            alufunc = ALU_SRA;
                        else if (f7_first == F7_FIRST_ADD)
                            alufunc = ALU_SRL;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_DIVU;
                    end
                endcase 
            end

            F7_ALUIW: begin
                op = ALUIW;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: alufunc = ALU_ADD;
                    F3_XOR: alufunc = ALU_XOR;
                    F3_OR: alufunc = ALU_OR;
                    F3_AND: alufunc = ALU_AND;
                    F3_SLT: alufunc = ALU_SLT;
                    F3_SLTU: alufunc = ALU_SLTU;
                    F3_SLL: alufunc = ALU_SLL;
                    F3_SR: begin
                        if (raw_instr[30])
                            alufunc = ALU_SRA;
                        else
                            alufunc = ALU_SRL;
                    end
                endcase 
            end

            F7_ALUW: begin
                op = ALUW;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ALU_ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = ALU_SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_MULT;
                    end
                    F3_XOR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_DIV;
                        else
                            alufunc = ALU_XOR;
                    end
                    F3_OR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_REM;
                        else
                            alufunc = ALU_OR;
                    end
                    F3_AND: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_REMU;
                        else
                            alufunc = ALU_AND;
                    end
                    F3_SLT: alufunc = ALU_SLT;
                    F3_SLTU: alufunc = ALU_SLTU;
                    F3_SLL: alufunc = ALU_SLL;
                    F3_SR: begin
                        if (f7_first == F7_FIRST_SUB)
                            alufunc = ALU_SRA;
                        else if (f7_first == F7_FIRST_ADD)
                            alufunc = ALU_SRL;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = ALU_DIVU;
                    end
                endcase 
            end

            F7_LUI: begin
                op = LUI;
                regwrite = 1'b1;
                alufunc = ALU_LUI;
            end

            F7_JAL: begin
                op = JAL;
                regwrite = 1'b1;
                alufunc = ALU_ADD;
            end

            F7_BRANCH: begin
                regwrite = 1'b0;

                unique case(funct3)
                    F3_BEQ: begin
                        op = BEQ;
                        alufunc = ALU_COMPARE;
                    end
                    F3_BNE: begin
                        op = BNE;
                        alufunc = ALU_COMPARE;
                    end
                    F3_BLT: begin
                        op = BLT;
                        alufunc = ALU_SLT;
                    end
                    F3_BGE: begin
                        op = BGE;
                        alufunc = ALU_SLT;
                    end
                    F3_BLTU: begin
                        op = BLTU;
                        alufunc = ALU_SLTU;
                    end
                    F3_BGEU: begin
                        op = BGEU;
                        alufunc = ALU_SLTU;
                    end
                    default: begin end
                endcase 
            end

            F7_LD: begin
                op = LD;
                regwrite = 1'b1;
                alufunc = ALU_ADD;
            end

            F7_SD: begin
                op = SD;
                regwrite = 1'b0;
                alufunc = ALU_ADD;
            end

            F7_AUIPC: begin
                op = AUIPC;
                regwrite = 1'b1;
                alufunc = ALU_ADD;
            end

            F7_JALR: begin
                op = JALR;
                regwrite = 1'b1;
                alufunc = ALU_ADD;
            end

            default: begin end
        endcase
    end
endmodule

`endif
