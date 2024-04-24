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
    input  fetch_data_t dataF,
    output decode_data_t dataD,
    input word_t        q1, q2,
    output [4:0]        rs1, rs2,
    input tran_t        trane, tranm, trand
);
    contral_t ctl;
    word_t temp1, temp2;
    logic bubble, bubble1, bubble2;

    decoder decoder(
        .instr(dataF.instr),
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
    // always_comb begin
    //     temp1 = q1;
    //     bubble1 = 0;
    //     if (rs1 != 0) begin
    //         if (rs1 == trand.dst)
    //             bubble1 = 1;
    //         else if (rs1 == trane.dst) begin
    //             temp1 = trane.data;
    //             bubble1 = trane.ismem;
    //         end
    //         else if (rs1 == tranm.dst)
    //             temp1 = tranm.data;
    //     end
    // end

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
        .pc(dataF.pc),
        .ctl(ctl),
        .instr(dataF.instr),
        .rd1,
        .rd2,
        .bubble,
        .bubble1,
        .bubble2
    );

    assign rs2 = dataF.instr[24:20];
    assign rs1 = dataF.instr[19:15];

    assign stopd = bubble;

    always_ff @(posedge clk)
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