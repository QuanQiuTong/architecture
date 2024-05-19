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

	always_ff @(posedge clk)
	if (reset) begin
		regs[0] <= 64'b0;
		regs[1] <= 64'b0;
		regs[2] <= 64'b0;
		regs[3] <= 64'b0;
		regs[4] <= 64'b0;
		regs[5] <= 64'b0;
		regs[6] <= 64'b0;
		regs[7] <= 64'b0;
		regs[8] <= 64'b0;
		regs[9] <= 64'b0;
		regs[10] <= 64'b0;
		regs[11] <= 64'b0;
		regs[12] <= 64'b0;
		regs[13] <= 64'b0;
		regs[14] <= 64'b0;
		regs[15] <= 64'b0;
		regs[16] <= 64'b0;
		regs[17] <= 64'b0;
		regs[18] <= 64'b0;
		regs[19] <= 64'b0;
		regs[20] <= 64'b0;
		regs[21] <= 64'b0;
		regs[22] <= 64'b0;
		regs[23] <= 64'b0;
		regs[24] <= 64'b0;
		regs[25] <= 64'b0;
		regs[26] <= 64'b0;
		regs[27] <= 64'b0;
		regs[28] <= 64'b0;
		regs[29] <= 64'b0;
		regs[30] <= 64'b0;
		regs[31] <= 64'b0;
	end else begin
		regs <= regs_nxt;
		regs[0] <= '0;
	end
	
	for (genvar i = 1; i < 32; i++)
		always_comb
			regs_nxt[i] = (i == rd && we) ? in : regs[i];

endmodule

`endif