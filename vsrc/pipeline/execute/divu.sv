`ifndef __DIVU_SV
`define __DIVU_SV

`ifdef VERILATOR

`else

`endif

module divu
	import common::*;
	import pipes::*;(
    input logic clk,
    input u64 a, b,
	output u64 quot,
    output u64 rem,
    output logic data_ok,
    input valid
);
    int i=0;
    //int j=0;
    logic waiting;
    always_ff @( posedge clk ) begin
        if (valid) begin
            if (i==0&&waiting==0) begin
                data_ok=0;
                quot=0;
                rem=0;
                i=1;
            end
            if (waiting==1) begin
                waiting=0;
                quot=0;
                rem=0;
                i=0;
                waiting=0;
                data_ok=0;
            end
            if (i==65) begin
                //if (a[63]!=b[63]) quot=0-$signed(quot);
                data_ok=1;
                i=0;
                waiting=1;
            end
            if (i>=1) begin
                //j=i;
                if (i==1) rem=0;
                //debug=rem;
                rem=(rem<<1)+{63'b0,a[64-i]};
                //debug1=rem;
                quot=quot<<1;
                if (rem>=b) begin
                    rem-=b;
                    quot+=1;
                end
                i+=1; 
            end
        end
        else begin
            quot=0;
            rem=0;
            i=0;
            waiting=0;
            data_ok=0;
        end
    end
endmodule

`endif
