`ifndef CLKMUL_SV
`define CLKMUL_SV

module ClkMul(
    input clk, rst,
    input [63:0] multiplier, multiplicand,
    output logic [127:0] product,
    output compl
);
    reg [7:0] i;
    always_ff @(posedge clk)
        if(rst) begin i = 0; product = 0; end
        else if(i <= 63) begin
            product += (multiplier[i[5:0]] ? {64'b0, multiplicand << i} : 128'b0);
            i++;
        end
    assign compl = i == 64;
endmodule

`endif

module Mul(
    input logic clk, en,
    input logic [63:0] a, b,
    output logic [127:0] product,
    output logic compl
);
    reg[7:0] i = 0;
    always_ff @(posedge clk)
        if(en) begin
            if(i <= 63) begin
                product += (a[i[5:0]] ? {64'b0, b << i} : 128'b0);
                i++;
            end
            if(i == 64) compl = 1;
        end
        else begin
            i = 0;
            compl = 0;
        end
endmodule

