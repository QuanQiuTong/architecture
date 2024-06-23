`ifndef _FETCH_SV
`define _FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/memory/translate.sv"
`endif

module fetch
    import common::*;
    import pipes::*;(
    input               clk, reset, branch, stop, flushall,
    input  [63:0]       jump, csrpc, satp,
    input  [1:0]        mode,
    input  decode_op_t  op,
    input  ibus_resp_t  iresp,
    input  dbus_resp_t  dresp,
    output dbus_req_t   dreq,
    output ibus_req_t   ireq,
    output fetch_data_t dataF,
    output              stopf
);
    reg [63:0] pc = 64'h80000000;
    
    assign stopf = (~iresp.data_ok) | stop;
    wire[63:0] pc_next = reset      ? 64'h80000000 :
                         flushall   ? csrpc        :
                         branch     ? jump         :
                         stopf      ? pc           :
                                      pc + 4;

    always_ff @(posedge clk)
        pc <= reset ? 64'h80000000 : pc_next;

    logic req, done, valid;
    always_ff @(posedge clk)
        if(req || (op != MRET && op != ECALL)) 
            req = pc == pc_next;
        else // !req && (mret || ecall)
            req = flushall;
    wire [63:0] addr;

    assign ireq.valid = req && done;
    assign ireq.addr = addr;

    translate tr(
        .clk, .reset,
        .en(req),
        .va(pc),
        .satp,
        .mmode(mode),
        .pa(addr),
        .valid,
        .mem_addr(dreq.addr),
        .mem_req(dreq.valid),
        .pte(dresp.data),
        .pte_valid(dresp.data_ok),
        .done
    );
    assign dreq.size = MSIZE8;
    assign dreq.strobe = 0;
    assign dreq.data = 0;

    always_ff @(posedge clk)
        if (reset) begin
            dataF.valid <= 0;
            dataF.instr <= 0;
            dataF.pc <= 0;
            dataF.error <= NOERROR;
        end else if (flushall || ~iresp.data_ok) begin
            dataF.valid <= 0;
        end else if (!stop) begin
            dataF.valid <= ~branch;
            dataF.instr <= iresp.data;
            dataF.pc <= pc;
            dataF.error <= pc[1:0] == 'b00 ? NOERROR : INSTR_MISALIGN;
        end

endmodule

`endif