`ifndef __OFFSET_SV
`define __OFFSET_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/execute/alu.sv"
`else

`endif

module offset
	import common::*;
	import pipes::*;(
    input u1 valid,
    input u32 instr,
    input logic[5:0] op,
    input word_t choose,
    output u64 jump,
    output u1 branch,
    input  u64 pc,
    input u64 jumppc
);
    always_comb 
        unique case(op)
            JAL : begin
                jump=pc+{{43{instr[31]}},{instr[31]},{instr[19:12]},{instr[20]},{instr[30:21]},{1'b0}};
                branch=valid;
            end
            BZ:begin
                if (choose==1) begin
                    jump=pc+{{51{instr[31]}},{instr[31]},{instr[7]},{instr[30:25]},{instr[11:8]},{1'b0}};
                    branch=valid;
                end
                else begin
                    jump=pc+4;
                    branch=valid;
                end
            end
            BNZ: begin
                if (choose==0) begin
                    jump=pc+{{51{instr[31]}},{instr[31]},{instr[7]},{instr[30:25]},{instr[11:8]},{1'b0}};
                    branch=valid;
                end
                else begin
                    jump=pc+4;
                    branch=valid;
                end
            end
            JALR:begin
                jump=jumppc;
                branch=valid;
            end
            default: begin jump=pc; branch=0; end
        endcase 
endmodule

`endif
