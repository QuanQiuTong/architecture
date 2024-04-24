`ifndef __DIV_SV
`define __DIV_SV

`ifdef VERILATOR
`include "pipeline/execute/divu.sv"
`endif

module div
	import common::*;
	import pipes::*;(
    input logic clk,
    input u64 a, b,
	output u64 quot,
    output u64 rem,
    output logic data_ok,
    input valid
);
    wire [63:0] uq, ur;
    divu _(clk, a[63] ? -a : a, b[63] ? -b : b, uq, ur, data_ok, valid);

    assign quot = a[63] ^ b[63] ? -uq : uq;
    assign rem = a[63] ? -ur : ur;
endmodule

`endif
