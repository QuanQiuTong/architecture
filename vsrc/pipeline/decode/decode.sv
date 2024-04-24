`ifndef __DECODE_SV
`define __DECODE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/decode/decoder.sv"
`include "pipeline/decode/immediate.sv"
`include "pipeline/decode/select.sv"
`else
`endif

module decode
    import common::*;
    import pipes::*;(
    input               clk, reset, stope, stopm, branch,
    output logic        stopd,
    input  logic        valid,
    input [31:0]        instr,
    input [63:0]        pc,
    output decode_data_t dataD,
    input word_t        q1, q2,
    output [4:0]        rs1, rs2,
    input tran_t        trane, tranm, trand
);
    contral_t ctl;
    word_t temp1, temp2;
    logic bubble, bubble1, bubble2;

    decoder decoder(
        .raw_instr(instr),
        .op(ctl.op),
        .alufunc(ctl.alufunc),
        .regwrite(ctl.regwrite)
    );

    select select1(
        .ra(rs1),
        .rd(q1),
        .result(temp1),
        .trane,
        .tranm,
        .trand,
        .bubble(bubble1)
    );

    select select2(
        .ra(rs2),
        .rd(q2),
        .result(temp2),
        .trane,
        .tranm,
        .trand,
        .bubble(bubble2)
    );

    word_t rd1, rd2;

    immediate immediate(
        .scra(temp1),
        .scrb(temp2),
        .pc(pc),
        .ctl(ctl),
        .instr(instr),
        .rd1,
        .rd2,
        .bubble,
        .bubble1,
        .bubble2
    );

    assign rs2 = instr[24:20];
    assign rs1 = instr[19:15];

    assign stopd = bubble;

    always_ff @(posedge clk)
        if (!stope & !stopm) begin 
            dataD.valid <= ~(branch | bubble) & valid;
            dataD.pc <= pc;
            dataD.instr <= instr;
            dataD.ctl <= ctl;
            dataD.dst <= instr[11:7];
            dataD.srca <= rd1;
            dataD.srcb <= rd2;
            dataD.rd1 <= temp1;
            dataD.rd2 <= temp2;
        end
endmodule

`endif