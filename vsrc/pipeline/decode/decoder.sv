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
    input [31:0] instr,
    output decode_op_t op,
	output alufunc_t alufunc,
	output logic regwrite
);
    wire [2:0] funct3 =    instr[14:12];
    wire [6:0] f7_first =  instr[31:25];

    always_comb begin
        op = ALUI;
        alufunc = ADD;
        regwrite = 1'b1;

        unique case(instr[6:0])
            F7_ALUI: begin
                op = ALUI;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: alufunc = ADD;
                    F3_XOR: alufunc = XOR;
                    F3_OR: alufunc = OR;
                    F3_AND: alufunc = AND;
                    F3_SLT: alufunc = SLT;
                    F3_SLTU: alufunc = SLTU;
                    F3_SLL: alufunc = SLL;
                    F3_SR: begin
                        if (instr[30])
                            alufunc = SRA;
                        else
                            alufunc = SRL;
                    end
                endcase 
            end

            F7_ALU: begin
                op = ALU;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = MULT;
                    end
                    F3_XOR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = DIV;
                        else
                            alufunc = XOR;
                    end
                    F3_OR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REM;
                        else
                            alufunc = OR;
                    end
                    F3_AND: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REMU;
                        else
                            alufunc = AND;
                    end
                    F3_SLT: alufunc = SLT;
                    F3_SLTU: alufunc = SLTU;
                    F3_SLL: alufunc = SLL;
                    F3_SR: begin
                        if (f7_first == F7_FIRST_SUB)
                            alufunc = SRA;
                        else if (f7_first == F7_FIRST_ADD)
                            alufunc = SRL;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = DIVU;
                    end
                endcase 
            end

            F7_ALUIW: begin
                op = ALUIW;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: alufunc = ADD;
                    F3_XOR: alufunc = XOR;
                    F3_OR: alufunc = OR;
                    F3_AND: alufunc = AND;
                    F3_SLT: alufunc = SLT;
                    F3_SLTU: alufunc = SLTU;
                    F3_SLL: alufunc = SLL;
                    F3_SR: begin
                        if (instr[30])
                            alufunc = SRA;
                        else
                            alufunc = SRL;
                    end
                endcase 
            end

            F7_ALUW: begin
                op = ALUW;
                regwrite = 1'b1;

                unique case(funct3)
                    F3_ADD: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = MULT;
                    end
                    F3_XOR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = DIV;
                        else
                            alufunc = XOR;
                    end
                    F3_OR: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REM;
                        else
                            alufunc = OR;
                    end
                    F3_AND: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REMU;
                        else
                            alufunc = AND;
                    end
                    F3_SLT: alufunc = SLT;
                    F3_SLTU: alufunc = SLTU;
                    F3_SLL: alufunc = SLL;
                    F3_SR: begin
                        if (f7_first == F7_FIRST_SUB)
                            alufunc = SRA;
                        else if (f7_first == F7_FIRST_ADD)
                            alufunc = SRL;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = DIVU;
                    end
                endcase 
            end

            F7_LUI: begin
                op = LUI;
                regwrite = 1'b1;
                alufunc = CPYB;
            end

            F7_JAL: begin
                op = JAL;
                regwrite = 1'b1;
                alufunc = ADD;
            end

            F7_BRANCH: begin
                regwrite = 1'b0;

                unique case(funct3)
                    F3_BEQ: begin
                        op = BEQ;
                        alufunc = COMPARE;
                    end
                    F3_BNE: begin
                        op = BNE;
                        alufunc = COMPARE;
                    end
                    F3_BLT: begin
                        op = BLT;
                        alufunc = SLT;
                    end
                    F3_BGE: begin
                        op = BGE;
                        alufunc = SLT;
                    end
                    F3_BLTU: begin
                        op = BLTU;
                        alufunc = SLTU;
                    end
                    F3_BGEU: begin
                        op = BGEU;
                        alufunc = SLTU;
                    end
                    default: begin end
                endcase 
            end

            F7_LD: begin
                op = LD;
                regwrite = 1'b1;
                alufunc = ADD;
            end

            F7_SD: begin
                op = SD;
                regwrite = 1'b0;
                alufunc = ADD;
            end

            F7_AUIPC: begin
                op = AUIPC;
                regwrite = 1'b1;
                alufunc = ADD;
            end

            F7_JALR: begin
                op = JALR;
                regwrite = 1'b1;
                alufunc = ADD;
            end

            default: begin end
        endcase
    end
endmodule

`endif
