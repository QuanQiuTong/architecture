`ifndef __DECODER_SV
`define __DECODER_SV
`ifdef VERILATOR
`include "include/common.sv"
`endif 

module decoder 
    import common::*;(
    input [31:0]       instr,
    output decode_op_t op,
	output alufunc_t   alufunc,
	output logic       regwrite
);
    wire [2:0] funct3 =  instr[14:12];
    wire [6:0] funct7 =  instr[31:25];

    always_comb unique case(instr[6:0])
        7'b0010011: begin
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

        7'b0110011: begin
            op = ALU;
            regwrite = 1'b1;

            if(funct7 == 7'b0000000)
                unique case(funct3)
                    'b000: alufunc = ADD;
                    'b100: alufunc = XOR;
                    'b110: alufunc = OR;
                    'b111: alufunc = AND;
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: alufunc = SRL;
                endcase 
            else if(funct7 == 7'b0100000)
                unique case(funct3)
                    'b000: alufunc = SUB;
                    'b101: alufunc = SRA;
                    default: alufunc = NOTALU;
                endcase 
            else if(funct7 == 7'b0000001)
                unique case(funct3)
                    'b000: alufunc = MULT;
                    'b100: alufunc = DIV;
                    'b110: alufunc = REM;
                    'b111: alufunc = REMU;
                    'b101: alufunc = DIVU;
                    default: alufunc = NOTALU;
                endcase
            else alufunc = NOTALU;
        end

        7'b0011011: begin
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

        7'b0111011: begin
            op = ALUW;
            regwrite = 1'b1;

            if(funct7 == 7'b0000000)
                 unique case(funct3)
                    'b000: alufunc = ADD;
                    'b100: alufunc = XOR;
                    'b110: alufunc = OR;
                    'b111: alufunc = AND;
                    'b010: alufunc = SLT;
                    'b011: alufunc = SLTU;
                    'b001: alufunc = SLL;
                    'b101: alufunc = SRL;
                endcase 
            else if(funct7 == 7'b0100000)
                unique case(funct3)
                    'b000: alufunc = SUB;
                    'b101: alufunc = SRA;
                    default: alufunc = NOTALU;
                endcase 
            else if(funct7 == 7'b0000001)
                unique case(funct3)
                    'b000: alufunc = MULT;
                    'b100: alufunc = DIV;
                    'b110: alufunc = REM;
                    'b111: alufunc = REMU;
                    'b101: alufunc = DIVU;
                    default: alufunc = NOTALU;
                endcase
            else alufunc = NOTALU;
        end

        7'b0110111: begin
            op = LUI;
            regwrite = 1'b1;
            alufunc = CPYB;
        end

        7'b1101111: begin
            op = JAL;
            regwrite = 1'b1;
            alufunc = ADD;
        end

        7'b1100011: begin // branch
            regwrite = 1'b0;
            op = funct3[0] ? BNZ : BZ;
            unique case(funct3[2:1])
                'b00: alufunc = EQL;
                'b01: alufunc = NOTALU;
                'b10: alufunc = SLT;
                'b11: alufunc = SLTU;
            endcase 
        end

        7'b0000011: begin
            op = LD;
            regwrite = 1'b1;
            alufunc = ADD;
        end

        7'b0100011: begin
            op = SD;
            regwrite = 1'b0;
            alufunc = ADD;
        end

        7'b0010111: begin
            op = AUIPC;
            regwrite = 1'b1;
            alufunc = ADD;
        end

        7'b1100111: begin
            op = JALR;
            regwrite = 1'b1;
            alufunc = ADD;
        end

        7'b1110011: begin
            regwrite = 1;
            unique case (funct3) 
                    'b011:begin // CSRRC
                        op=CSR;
                        alufunc=ALU_CSRC;
                    end
                    'b111:begin // CSRRCI
                        op=CSRI;
                        alufunc=ALU_CSRC;
                    end
                    'b010:begin // CSRRS
                        op=CSR;
                        alufunc=ALU_CSRS;
                    end
                    'b110:begin // CSRRSI
                        op=CSRI;
                        alufunc=ALU_CSRS;
                    end
                    'b001:begin // CSRRW
                        op=CSR;
                        alufunc=ALU_CSRW;
                    end
                    'b101:begin // CSRRWI
                        op=CSRI;
                        alufunc=ALU_CSRW;
                    end
                    'b000:begin // ECALL
                        regwrite=0;
                        if (funct7==7'b0000000) begin
                            op=ECALL;
                            alufunc=ALU_ECALL;
                        end else if (funct7=='b0011000) begin
                            op=MRET;
                            alufunc=ALU_MRET;
                        end else begin
                            op=UNKNOWN;
                            alufunc=NOTALU;
                        end                        
                    end
                    default: begin
                        
                    end
                endcase
        end

        default: begin op = UNKNOWN; alufunc = NOTALU; regwrite = 0; end
    endcase
endmodule

`endif
