`ifndef _FETCH_SV
`define _FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module fetch
    import common::*;
    import pipes::*;(
    input               clk, reset, branch, stop,
    output fetch_data_t dataF,
    output ibus_req_t   ireq,
    input  ibus_resp_t  iresp,
    input  [63:0]       jump
);
    reg [63:0] pc;

    assign ireq.addr = pc;
    always_ff @(posedge clk) begin
        pc <= reset ? 64'h80000000 : pc_next;
        ireq.valid = pc == pc_next;
    end

    logic pc_stop = (~iresp.data_ok) | stop;
    wire[63:0] pc_next = reset      ? 64'h80000000 :
                         branch     ? jump         :
                         pc_stop    ? pc           :
                                      pc + 4;

    always_ff @(posedge clk)
        if (!stop) begin
            dataF.valid <= iresp.data_ok & ~branch;
            dataF.instr <= iresp.data;
            dataF.pc <= pc;
        end
endmodule

`endif