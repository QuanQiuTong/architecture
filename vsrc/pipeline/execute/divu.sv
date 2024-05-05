`ifndef __DIVU_SV
`define __DIVU_SV

module divu(
    input logic  clk,valid,
    input [63:0] a, b,
    output logic [63:0] quot,
    output logic [63:0] rem,
    output logic data_ok
);
    int i = 0;
    logic waiting;

    always_ff @(posedge clk)
        if (valid) begin
            if (i == 0 && waiting == 0) begin
                data_ok = 0;
                quot = 0;
                rem = 0;
                i = 1;
            end
            if (waiting == 1) begin
                waiting = 0;
                quot = 0;
                rem = 0;
                i = 0;
                waiting = 0;
                data_ok = 0;
            end
            if (i == 65) begin
                data_ok = 1;
                i = 0;
                waiting = 1;
            end
            if (i >= 1) begin
                if (i == 1) rem = 0;
                rem = (rem << 1) + {63'b0, a[64 - i]};
                quot = quot << 1;
                if (rem >= b) begin
                    rem -= b;
                    quot += 1;
                end
                i += 1;
            end
        end
        else begin
            quot = 0;
            rem = 0;
            i = 0;
            waiting = 0;
            data_ok = 0;
        end
endmodule

`endif
