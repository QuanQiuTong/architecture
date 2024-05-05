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

    always_comb
        unique case(instr[6:0])
            F7_ALUI: begin
                op = ALUI;
                regwrite = 1'b1;
                unique case(funct3)
                    'b000: alufunc = ADD;
                    'b100: alufunc = XOR;
                    'b110: alufunc = OR;
                    'b111: alufunc = AND;
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: alufunc = instr[30] ? SRA : SRL;
                endcase 
            end

            F7_ALU: begin
                op = ALU;
                regwrite = 1'b1;

                unique case(funct3)
                    'b000: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = MULT;
                    end
                    'b100: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = DIV;
                        else
                            alufunc = XOR;
                    end
                    'b110: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REM;
                        else
                            alufunc = OR;
                    end
                    'b111: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REMU;
                        else
                            alufunc = AND;
                    end
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: begin
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
                    'b000: alufunc = ADD;
                    'b100: alufunc = XOR;
                    'b110: alufunc = OR;
                    'b111: alufunc = AND;
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: alufunc = instr[30] ? SRA : SRL;
                endcase 
            end

            F7_ALUW: begin
                op = ALUW;
                regwrite = 1'b1;

                unique case(funct3)
                    'b000: begin
                        if (f7_first == F7_FIRST_ADD)
                            alufunc = ADD;
                        else if (f7_first == F7_FIRST_SUB)
                            alufunc = SUB;
                        else if (f7_first == F7_FIRST_MUL)
                            alufunc = MULT;
                    end
                    'b100: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = DIV;
                        else
                            alufunc = XOR;
                    end
                    'b110: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REM;
                        else
                            alufunc = OR;
                    end
                    'b111: begin
                        if (f7_first == F7_FIRST_MUL)
                            alufunc = REMU;
                        else
                            alufunc = AND;
                    end
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: begin
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
                op = funct3[0] ? BNZ : BZ;
                unique case(funct3[2:1])
                    'b00: alufunc = EQL;
                    'b01: begin end
                    'b10: alufunc = SLT;
                    'b11: alufunc = SLTU;
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

            default: op = ALUI;
        endcase
endmodule

`endif
