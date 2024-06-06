`ifndef __ALU_SV
`define __ALU_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "pipeline/execute/multi.sv"
`include "pipeline/execute/div.sv"
`include "pipeline/execute/divu.sv"
`endif

module alu
	import common::*;(
	input           clk,
	input [63:0]    a, b,
	input alufunc_t alufunc,
	output logic [63:0]   result,
	input           choose,
	input           valid,
	output logic    bubble
);
	logic [63:0] c;
	wire multibubble, divbubble, divububble;
	wire[63:0] multiresult, quot, rem, quotu, remu;
	always_comb begin
		unique case (alufunc)
			ADD:  c = a + b;
			XOR:  c = a ^ b;
			OR:   c = a | b; 
			AND:  c = a & b;
			SUB:  c = a - b;
			CPYB: c = b;
			EQL:  c = {63'b0, (a == b)};
			SLT:  c = $signed(a) < $signed(b) ? 64'b1 : 64'b0;
			SLTU: c = {63'b0, a < b};
			SLL:  c = a << b[5:0];
			SRL:  c = a >> b[5:0];
			SRA:  c = $signed(a) >>> b[5:0];
			MULT: c = multiresult + (b[0] ? a : 0);
			DIV:  c = (b == 0 ? -1 : quot);
			REM:  c = (b == 0 ? a : rem);
			DIVU: c = (b == 0 ? -1 : quotu);
			REMU: c = (b == 0 ? a : remu);
			ALU_CSRW: c = a;
			ALU_CSRS: c = a;
			default: begin c = 0; end
		endcase
		if (choose) begin
			unique case (alufunc)
				SLL: c = a << b[4:0];
				SRL: c[31:0] = a[31:0] >> b[4:0];
				SRA: c[31:0] = $signed(a[31:0]) >>> b[4:0];
				default: begin end
			endcase
			result = {{32{c[31]}}, c[31:0]};
		end
		else result = c;
	end

	always_comb unique case (alufunc)
		MULT: bubble = ~multibubble;
		DIV, REM: bubble = b != 0 && ~divbubble;
		DIVU, REMU: bubble = b != 0 && ~divububble;
		default: bubble = 0;
	endcase
	multi _mul_(
		.clk, .a, .b, .result(multiresult),
		.data_ok(multibubble), .valid((alufunc == MULT) & valid)
	);
	div div(
		.clk, .a, .b, .quot(quot), .rem(rem),
		.data_ok(divbubble), .valid(((alufunc == DIV || alufunc == REM) && b != 0) & valid)
	);
	divu divu(
		.clk, .a, .b, .quot(quotu), .rem(remu),
		.data_ok(divububble), .valid(((alufunc == DIVU || alufunc == REMU) && b != 0) & valid)
	);
endmodule

`endif
