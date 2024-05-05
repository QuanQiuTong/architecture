`ifndef __DIV_SV
`define __DIV_SV

`ifdef VERILATOR
`include "pipeline/execute/divu.sv"
`endif

module div(
    input clk, valid,
    input [63:0]  a, b,
	output [63:0] quot,
    output [63:0] rem,
    output        data_ok
);
    wire [63:0] uq, ur;
    divu _(clk, valid, a[63] ? -a : a, b[63] ? -b : b, uq, ur, data_ok);

    assign quot = a[63] ^ b[63] ? -uq : uq;
    assign rem = a[63] ? -ur : ur;
endmodule

`endif
