`ifndef __MULTI_SV
`define __MULTI_SV

module multi(
    input   clk,
    input [63:0] a, b,
    output reg[63:0] result,
    output logic data_ok,
    input valid
);
    int i = 0;
    logic waiting = 0;
    
    always_ff @(posedge clk)
        if (valid) begin
            if (i == 0 && waiting == 0) begin
                result = 0;
                i = 1;
                data_ok = 0;
            end
            if (waiting == 1) begin
                i = 0;
                data_ok = 0;
                waiting = 0;
                result = 0;
            end
            if (i == 65) begin
                data_ok = 1;
                i = 0;
                waiting = 1;
            end
            if (i >= 1) begin
                if (b[i]) result += (a << i);
                i++;
            end 
        end else begin
            i = 0;
            data_ok = 0;
            waiting = 0;
            result = 0;
        end
endmodule

`endif

