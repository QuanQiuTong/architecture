`ifndef __IMMEDIATE_SV
`define __IMMEDIATE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module immediate
	import common::*;
	import pipes::*;(
    input word_t scrb, scra,
    input u64 pc,
    input control_t ctl,
    input u32 instr,
    output word_t rd2, rd1,
    output u1 bubble,
    input logic bubble1, bubble2
);
    always_comb begin
        rd1 = scra;
        rd2 = scrb;
        unique case (ctl.op)
             ALUW: begin
                if (ctl.alufunc == DIV || ctl.alufunc == REM) begin
                    rd1 = {{32{scra[31]}}, scra[31:0]};
                    rd2 = {{32{scrb[31]}}, scrb[31:0]};
                end
                else if (ctl.alufunc == DIVU || ctl.alufunc == REMU) begin
                    rd1 = {{32{1'b0}}, scra[31:0]};
                    rd2 = {{32{1'b0}}, scrb[31:0]};
                end
                bubble = bubble1 | bubble2;
            end
            ALU: begin
                rd2 = scrb;
                bubble = bubble1 | bubble2;
            end
            ALUI, ALUIW, LD: begin
                rd2 = {{52{instr[31]}}, instr[31:20]};
                bubble = bubble1;
            end
            LUI: begin
                rd2 = {{32{instr[31]}}, instr[31:12], 12'b0};
                bubble = bubble1;
            end
            SD: begin
                rd2 = {{52{instr[31]}}, instr[31:25], instr[11:7]};
                bubble = bubble1;
            end
            AUIPC: begin
                rd1 = pc;
                rd2 = {{32{instr[31]}}, instr[31:12], 12'b0};
                bubble = 0;
            end
            JAL, JALR: begin
                rd1 = pc;
                rd2 = 4;
                bubble = 0;
            end
            default: bubble = bubble1 | bubble2;
        endcase 
    end
endmodule

`endif
