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
    wire pc_stop = (~iresp.data_ok) | stop;
    wire[63:0] pc_next = reset      ? 64'h80000000 :
                         branch     ? jump         :
                         pc_stop    ? pc           :
                                      pc + 4;

    assign ireq.addr = pc;
    always_ff @(posedge clk) begin
        pc <= reset ? 64'h80000000 : pc_next;
        ireq.valid = pc == pc_next;
    end

    


    always_ff @(posedge clk)
        if (reset) begin
            dataF.valid <= 0;
            dataF.instr <= 0;
            dataF.pc <= 0;
        end
        else if (!stop) begin
            dataF.valid <= iresp.data_ok & ~branch;
            dataF.instr <= iresp.data;
            dataF.pc <= pc;
        end
endmodule

`endif