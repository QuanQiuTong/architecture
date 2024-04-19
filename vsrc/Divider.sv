`ifndef DIVIDER_SV
`define DIVIDER_SV

module Divider (
    input clk, en,
    input [63:0] dividend, divisor,
    output logic [63:0] quotient, remainder,
    output compl
    );
    logic [63:0] temp_dividend;

    int i;
    always_ff @(posedge clk)
        if(en) begin
            temp_dividend = dividend;
            quotient = 0;
            remainder = 0;
            i = 63;
        end
        else if(i >= 0) begin
            remainder = remainder << 1;
            remainder[0] = dividend[i];
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1;
            end
            i = i - 1;
        end
    assign compl = i == -1;
endmodule

`endif