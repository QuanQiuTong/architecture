`ifndef __SELECT_SV
`define __SELECT_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else
`endif

module select
    import common::*;
    import pipes::*;(
    input [4:0]     ra,
    input word_t    rd,
    input tran_t    trane, tranm, trand,
    output word_t   result,
    output logic    bubble
);
    always_comb begin
        result = rd;
        bubble = 0;
        if (ra != 0) begin
            if (ra == trand.dst)
                bubble = 1;
            else if (ra == trane.dst) begin
                result = trane.data;
                bubble = trane.ismem;
            end
            else if (ra == tranm.dst)
                result = tranm.data;
        end
    end
endmodule

`endif
