`ifndef __EXCUTE_SV
`define __EXCUTE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/execute/alu.sv"
`endif

module execute
    import common::*;
	import pipes::*;(
    input           clk, reset, flushde,
    input  decode_data_t dataD,
    output excute_data_t dataE,
    output logic         branch,
    output u64           jump,
    input  logic         stopm,
    output logic         stope
);
    logic bubble;
    control_t ctl;
    assign ctl = dataD.ctl;
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
        .bubble, .valid(dataD.valid)
    );
    assign branch = (ctl.op == JAL || ctl.op == JALR || ctl.op == BZ || ctl.op == BNZ) && dataD.valid;
    always_comb 
    if(ctl.op == JAL) jump = dataD.pc + {{43{instr[31]}}, instr[31], instr[19:12] , instr[20] , instr[30:21], 1'b0};
    else if(ctl.op == JALR) jump = dataD.rd1 + {{52{instr[31]}}, instr[31:20]};
    else if(!(ctl.op ==BZ&&alu_result==1) && !(ctl.op ==BNZ&& alu_result==0)) jump = dataD.pc + 4;
    else jump = dataD.pc + {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

    assign stope = bubble & dataD.valid;
    always_ff @(posedge clk)
        if (reset || flushde)
            dataE.valid  <= 0;
        else if (!stopm) begin
            dataE.valid  <= !bubble && dataD.valid;
            dataE.pc     <= dataD.pc;
            dataE.instr  <= dataD.instr;
            dataE.ctl    <= dataD.ctl;
            dataE.dst    <= dataD.dst;
            dataE.rd2    <= dataD.rd2;
            dataE.result <= alu_result;
            dataE.csr    <= dataD.csr;
            dataE.csrdst <= dataD.csrdst;
            dataE.error  <= dataD.error;
        end
        // 'else' causes verilator fails

endmodule

`endif
