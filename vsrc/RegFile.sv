`ifndef __REGFILE_SV
`define __REGFILE_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif 

module RegFile (
    input we, clk,
    input [63:0] in,
    input [4:0] rs1, rs2, rd,
    output logic written,
    output [63:0] out1, out2,
    output logic [63:0] regs [0:31]
    );
    reg [63:0] register[0:31];
    assign register[0] = 0;
       
    assign out1 = register[rs1];
    assign out2 = register[rs2];

    always_ff @(posedge clk)
        if (we && rd != 0 && !written)
            begin register[rd] <= in; written <= 1; end
        else if (we && rd == 0 && !written)
            written <= 1;

    assign regs = register;
endmodule

`endif