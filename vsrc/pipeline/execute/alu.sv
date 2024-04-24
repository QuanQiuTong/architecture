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
	input u64 a, b,
	input alufunc_t alufunc,
	output u64 result,
	input logic choose,
	input contral_t ctl,
	input logic valid,
	output u1 bubble
);
	logic [63:0] c;
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
				c = multiresult + (b[0] ? a : 0);
				bubble = ~multibubble;
			end
			DIV: begin
				if (b == 0) begin
					c = '1;
					bubble = 0;
				end
				else begin
					if (a[63] == b[63] && $signed(divresult) >= 0 || a[63] != b[63] && $signed(divresult) <= 0) c = divresult;
					else c = 0 - divresult;
					bubble = ~divbubble;
				end
			end
			REM: begin
				if (b == 0) begin
					c = a;
					bubble = 0;
				end
				else begin
					c = remresult;
					bubble = ~divbubble;
				end
			end
			DIVU: begin
				if (b == 0) begin
					c = '1;
					bubble = 0;
				end
				else begin
					c = divuresult;
					bubble = ~divububble;
				end
			end
			REMU: begin
				if (b == 0) begin
					c = a;
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
	multi _mul_ (
		.clk, .a, .b, .result(multiresult),
		.data_ok(multibubble), .valid((alufunc == MULT) & valid)
	);
	div div (
		.clk, .a, .b, .quot(divresult), .rem(remresult),
		.data_ok(divbubble), .valid(((alufunc == DIV || alufunc == REM) && b != 0) & valid)
	);
	divu divu (
		.clk, .a, .b, .quot(divuresult), .rem(remuresult),
		.data_ok(divububble), .valid(((alufunc == DIVU || alufunc == REMU) && b != 0) & valid)
	);
endmodule

`endif
