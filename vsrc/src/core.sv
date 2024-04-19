`ifndef __CORE_SV
`define __CORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module core import common::*;(
	input  logic       clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp,
	input  logic       trint, swint, exint
);
	reg [63:0] pc, new_pc, calc_pc, memout;
	wire [4:0] alu_op;
    wire zero, alui, reg_write, jump, branch, u, mem_read, mem_write;
    wire [63:0] imm, q1, q2, result, regs [0:31], regin;
    reg [31:0] instr;
	logic rt, da, ac;
	
	PC _pc (clk, reset, new_pc, pc);

	assign ireq.addr = calc_pc;
	assign ireq.valid = (mem_read | mem_write) ? da : reg_write ? rt : 1;

	always_ff @(posedge clk)
		if (iresp.data_ok) begin instr <= iresp.data; rt <= 0; da <= 0; end

	DMem _DMem(
		.clk(clk),
		.read(mem_read),
		.write(mem_write),
		.func(instr[14:12]),
		.addr(result),
		.in(q2),
		.dresp(dresp),
		.dreq(dreq),
		.compl(da),
		.out(memout)
	 );
	
    ControlUnit _(zero, instr, alu_op, imm, alui, jump, branch, u, reg_write, mem_read, mem_write);

	assign regin = mem_read ? memout : jump ? pc + 4 : u ? pc + imm : result;
    RegFile _RegFile (
        .clk(clk),
        .rs1(instr[19:15]),
		.rs2(instr[24:20]),
		.rd(instr[11:7]),
        .we(mem_read ? da : reg_write & !rt & ac),
		.in(regin),
		.written(rt),
        .out1(q1),
		.out2(q2),
		.regs(regs)
    );

    ALU _ALU (q1, (alui ? imm : q2), alu_op, clk, iresp.addr_ok, ac, result, zero);

	always_latch // reg[64:0] calc_pc_reg; //选择
		if(!rt)	calc_pc = branch ? pc + imm : jump ? {result[63:1], 1'b0} : pc + 4;
	assign new_pc = iresp.addr_ok ? calc_pc : pc;

`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (iresp.data_ok),
		.pc                 (pc),
		.instr              (instr),
		.skip               (0),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (reg_write),
		.wdest              ({3'b000, instr[11:7]}),
		.wdata              (regin)
	);

	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (0),
		.gpr_0              (regs[0]),
		.gpr_1              (regs[1]),
		.gpr_2              (regs[2]),
		.gpr_3              (regs[3]),
		.gpr_4              (regs[4]),
		.gpr_5              (regs[5]),
		.gpr_6              (regs[6]),
		.gpr_7              (regs[7]),
		.gpr_8              (regs[8]),
		.gpr_9              (regs[9]),
		.gpr_10             (regs[10]),
		.gpr_11             (regs[11]),
		.gpr_12             (regs[12]),
		.gpr_13             (regs[13]),
		.gpr_14             (regs[14]),
		.gpr_15             (regs[15]),
		.gpr_16             (regs[16]),
		.gpr_17             (regs[17]),
		.gpr_18             (regs[18]),
		.gpr_19             (regs[19]),
		.gpr_20             (regs[20]),
		.gpr_21             (regs[21]),
		.gpr_22             (regs[22]),
		.gpr_23             (regs[23]),
		.gpr_24             (regs[24]),
		.gpr_25             (regs[25]),
		.gpr_26             (regs[26]),
		.gpr_27             (regs[27]),
		.gpr_28             (regs[28]),
		.gpr_29             (regs[29]),
		.gpr_30             (regs[30]),
		.gpr_31             (regs[31])
	);

    DifftestTrapEvent DifftestTrapEvent(
		.clock              (clk),
		.coreid             (0),
		.valid              (0),
		.code               (0),
		.pc                 (0),
		.cycleCnt           (0),
		.instrCnt           (0)
	);

	DifftestCSRState DifftestCSRState(
		.clock              (clk),
		.coreid             (0),
		.priviledgeMode     (3),
		.mstatus            (0),
		.sstatus            (0 /* mstatus & 64'h800000030001e000 */),
		.mepc               (0),
		.sepc               (0),
		.mtval              (0),
		.stval              (0),
		.mtvec              (0),
		.stvec              (0),
		.mcause             (0),
		.scause             (0),
		.satp               (0),
		.mip                (0),
		.mie                (0),
		.mscratch           (0),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	);
`endif
endmodule
`endif