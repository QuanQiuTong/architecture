`ifndef __DIV_SV
`define __DIV_SV

`ifdef VERILATOR
`include "pipeline/execute/divu.sv"
`else

`endif

module div
	import common::*;
	import pipes::*;(
    input logic clk,
    input u64 srca, srcb,
	output u64 quot,
    output u64 rem,
    output logic data_ok,
    input valid
);
    wire [63:0] uq, ur;
    divu _(clk, srca[63] ? -srca : srca, srcb[63] ? -srcb : srcb, uq, ur, data_ok, valid);

    assign quot = srca[63] ^ srcb[63] ? -uq : uq;
    assign rem = srca[63] ? -ur : ur;
endmodule

`endif
