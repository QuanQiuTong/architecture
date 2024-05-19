`ifndef __DECODE_SV
`define __DECODE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/decode/decoder.sv"
`include "pipeline/decode/immediate.sv"
`endif

module decode
    import common::*;
    import pipes::*;(
    input                clk, reset, stope, stopm, branch,
    output logic         stopd,
    input  fetch_data_t  dataF,
    output decode_data_t dataD,
    input  word_t        q1, q2,
    output [4:0]         rs1, rs2,
    input  tran_t        trane, tranm
);
    control_t ctl;
    decode_op_t op;
    alufunc_t alufunc;
    logic regwrite;
    word_t temp1, temp2;
    logic bubble, bubble1, bubble2;

    decoder decoder(
        .instr(dataF.instr),
        .op(op),
        .alufunc(alufunc),
        .regwrite(regwrite)
    );

    assign ctl = '{op, alufunc, regwrite};

    assign rs2 = dataF.instr[24:20];
    assign rs1 = dataF.instr[19:15];

    wire [4:0] _dst = (dataD.ctl.regwrite && dataD.valid) ? dataD.dst : 0;

    assign temp1 = rs1 != 0 ? (rs1 == trane.dst ? trane.data : rs1 == tranm.dst ? tranm.data : q1) : q1;
    assign bubble1 = rs1 != 0 && (rs1 == _dst || (rs1 == trane.dst && trane.ismem));

    assign temp2 = rs2 != 0 ? (rs2 == trane.dst ? trane.data : rs2 == tranm.dst ? tranm.data : q2) : q2;
    assign bubble2 = rs2 != 0 && (rs2 == _dst || (rs2 == trane.dst && trane.ismem));

    word_t rd1, rd2;

    immediate immediate(
        .scra(temp1),
        .scrb(temp2),
        .pc(dataF.pc),
        .ctl(ctl),
        .instr(dataF.instr),
        .rd1,
        .rd2,
        .bubble,
        .bubble1,
        .bubble2
    );

    assign stopd = bubble && dataF.valid;

    always_ff @(posedge clk)
        if (reset) begin
            dataD.valid <= 0;
            dataD.pc    <= 0;
            dataD.instr <= 0;
            dataD.ctl   <= 0;
            dataD.dst   <= 0;
            dataD.srca  <= 0;
            dataD.srcb  <= 0;
            dataD.rd1   <= 0;
            dataD.rd2   <= 0;
        end
        else
        if (!stope & !stopm) begin 
            dataD.valid <= ~(branch | bubble) & dataF.valid;
            dataD.pc    <= dataF.pc;
            dataD.instr <= dataF.instr;
            dataD.ctl   <= ctl;
            dataD.dst   <= dataF.instr[11:7];
            dataD.srca  <= rd1;
            dataD.srcb  <= rd2;
            dataD.rd1   <= temp1;
            dataD.rd2   <= temp2;
        end
endmodule

`endif