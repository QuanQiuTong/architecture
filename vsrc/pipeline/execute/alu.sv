`ifndef __SV
`define __SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/execute/multi.sv"
`include "pipeline/execute/div.sv"
`include "pipeline/execute/divu.sv"
`endif

module alu
	import common::*;
	import pipes::*;(
	input u1 clk,
	input u64 srca, srcb,
	input alufunc_t alufunc,
	output u64 result,
	input logic choose,
	input contral_t ctl,
	input logic valid,
	output u1 bubble
);
	logic [63:0] a, b, c;
	assign a = srca;
	assign b = srcb;
	logic more;
	u1 multibubble, divbubble, divububble;
	u64 multiresult, divresult, remresult, divuresult, remuresult;
	always_comb begin
		c = '0;
		bubble = 0;
		unique case (alufunc)
			ADD: c = a + b;
			XOR: c = a ^ b;
			OR: c = a | b; 
			AND: c = a & b;
			SUB: c = a - b;
			CPYB: c = b;
			COMPARE: c = {63'b0, (a == b)};
			SLT: c = $signed(a) < $signed(b) ? 64'b1 : 64'b0;
			SLTU: c = {63'b0, a < b};
			SLL: c = a << b[5:0];
			SRL: c = a >> b[5:0];
			SRA: c = $signed(a) >>> b[5:0];
			MULT: begin
				c = multiresult + (srcb[0] ? srca : 0);
				bubble = ~multibubble;
			end
			DIV: begin
				if (srcb == 0) begin
					c = '1;
					bubble = 0;
				end
				else begin
					if (srca[63] == srcb[63] && $signed(divresult) >= 0 || srca[63] != srcb[63] && $signed(divresult) <= 0) c = divresult;
					else c = 0 - divresult;
					bubble = ~divbubble;
				end
			end
			REM: begin
				if (srcb == 0) begin
					c = srca;
					bubble = 0;
				end
				else begin
					c = remresult;
					bubble = ~divbubble;
				end
			end
			DIVU: begin
				if (srcb == 0) begin
					c = '1;
					bubble = 0;
				end
				else begin
					c = divuresult;
					bubble = ~divububble;
				end
			end
			REMU: begin
				if (srcb == 0) begin
					c = srca;
					bubble = 0;
				end
				else begin
					c = remuresult;
					bubble = ~divububble;					
				end
			end
			default: bubble = 0;
		endcase
		if (choose) begin
			unique case (ctl.alufunc)
				SLL: c = a << b[4:0];
				SRL: c[31:0] = a[31:0] >> b[4:0];
				SRA: c[31:0] = $signed(a[31:0]) >>> b[4:0];
				default: begin
				end
			endcase
			result = {{32{c[31]}}, c[31:0]};
		end
		else result = c;
	end
	multi multi (
		.clk, .srca, .srcb, .result(multiresult),
		.data_ok(multibubble), .valid((alufunc == MULT) & valid)
	);
	div div (
		.clk, .srca, .srcb, .quot(divresult), .rem(remresult),
		.data_ok(divbubble), .valid(((alufunc == DIV || alufunc == REM) && srcb != 0) & valid)
	);
	divu divu (
		.clk, .srca, .srcb, .quot(divuresult), .rem(remuresult),
		.data_ok(divububble), .valid(((alufunc == DIVU || alufunc == REMU) && srcb != 0) & valid)
	);
endmodule

`endif
