`ifndef __EXCUTE_SV
`define __EXCUTE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/execute/alu.sv"
`else

`endif

module execute
    import common::*;
	import pipes::*;(
    input logic clk, reset,
    input decode_data_t dataD,
    output excute_data_t dataE,
    output u1 branch,
    output u64 jump,
    input logic stopm,
    output logic stope
);
    u1 bubble;
    contral_t ctl = dataD.ctl;
    word_t rd2, rd1;
    u32 instr = dataD.instr;
    word_t alu_result;
    alu alu (
        .clk,
        .a(dataD.srca),
        .b(dataD.srcb),
        .alufunc(ctl.alufunc),
        .result(alu_result),
        .choose(ctl.op == ALUW || ctl.op == ALUIW),
        .ctl, .bubble, .valid(dataD.valid)
    );
    always_comb 
        unique case(ctl.op)
            JAL: 
                jump = dataD.pc + {{43{instr[31]}}, instr[31], instr[19:12] , instr[20] , instr[30:21], 1'b0};
            BZ:
                if (alu_result == 1) 
                    jump = dataD.pc + {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                else 
                    jump = dataD.pc + 4;
            BNZ: 
                if (alu_result == 0) 
                    jump = dataD.pc + {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                else 
                    jump = dataD.pc + 4;
            JALR:
                jump = dataD.rd1 + {{52{instr[31]}}, instr[31:20]};
            default:  jump = dataD.pc; 
    endcase 
    assign branch = ctl.op == JAL || ctl.op == JALR || ctl.op == BZ || ctl.op == BNZ; // && dataD.valid;

    assign stope = bubble & dataD.valid;
    always_ff @(posedge clk) begin
        if (!stopm) begin
            dataE.valid  <= !bubble && dataD.valid;
            dataE.pc     <= dataD.pc;
            dataE.instr  <= dataD.instr;
            dataE.ctl    <= dataD.ctl;
            dataE.dst    <= dataD.dst;
            dataE.rd2    <= dataD.rd2;
            dataE.result <= alu_result;
        end
    end
endmodule

`endif
