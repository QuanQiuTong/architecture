`ifndef __REGFILE_SV
`define __REGFILE_SV

module regfile (
	input		  clk, reset, we,
	input  [4:0]  rs1, rs2, rd,
	input  [63:0] in,
	output [63:0] q1, q2
);
	reg[63:0] regs[31:0], regs_nxt[31:0];

	assign q1 = regs[rs1];
	assign q2 = regs[rs2];

	always_ff @(posedge clk) begin
		regs <= regs_nxt;
		regs[0] <= '0;
	end
	
	for (genvar i = 1; i < 32; i++)
		always_comb
			regs_nxt[i] = (i == rd && we) ? in : regs[i];

endmodule

`endif