`ifndef _FETCH_SV
`define _FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module fetch
    import common::*;(
    input               clk, reset, branch, stop,
    output logic        valid,
    output reg   [31:0] instr,
    output reg   [63:0] pc,
    output ibus_req_t   ireq,
    input ibus_resp_t   iresp,
    input [63:0]        jump
);
    reg [63:0] _pc;

    logic pc_stop = (~iresp.data_ok) | stop;
    assign ireq.addr = _pc;
    always_ff @(posedge clk) ireq.valid = _pc == pc_next;

    wire[63:0] pc_next = reset      ? 64'h80000000 :
                         branch     ? jump         :
                         pc_stop    ? _pc          :
                                      _pc + 4;

    always_ff @(posedge clk)
        if (reset) begin
            _pc <= 64'h80000000;
            valid <= 0;
        end else begin
            _pc <= pc_next;
            if (!stop) begin
                valid <= iresp.data_ok & ~branch;
                instr <= iresp.data;
                pc <= _pc;
            end
        end
endmodule

`endif