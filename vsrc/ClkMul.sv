`ifndef CLKMUL_SV
`define CLKMUL_SV

module ClkMul(
    input clk, en,
    input [63:0] multiplier, multiplicand,
    output logic [127:0] product,
    output compl
);
    reg [7:0] i;
    always_ff @(posedge clk)
        if(en) begin i = 0; product = 0; end
        else if(i <= 63) begin
            product = product + (multiplier[i[5:0]] ? {64'b0, multiplicand << i} : 128'b0);
            i++;
        end
    assign compl = i == 64;
endmodule

`endif