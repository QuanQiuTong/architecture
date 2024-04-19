`ifndef __PC_SV
`define __PC_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module PC (
    input clk, reset,
    input [63:0] in,
    output reg [63:0] out
);
    always_ff @(posedge clk)
        out <= reset ? 64'h80000000 : in;
endmodule

`endif