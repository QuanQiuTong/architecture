`ifndef __CORE_SV
`define __CORE_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/fetch/fetch.sv"
`include "pipeline/decode/decode.sv"
`include "pipeline/execute/execute.sv"
`include "pipeline/memory/memory.sv"
`endif

module core 
	import common::*;
	import pipes::*;(
	input logic clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp,
	input  logic       trint, swint, exint
);
	fetch_data_t  dataF;
	decode_data_t dataD;
	excute_data_t dataE;
	memory_data_t dataM;
	wire[4:0] rs1,rs2;
	word_t q1,q2;
	u1 stopd,stope,stopm,branch;
	u64 jump;
	tran_t trane,tranm,trand;

	fetch fetch(
		.clk, .reset,
		.ireq, .iresp,
		.branch, .jump,
		.stop(stopd | stope | stopm),
		.dataF
	);
	decode decode(
		.clk, .reset,
		.dataF, .dataD,
		.rs1, .rs2, .q1, .q2,
		.branch,
		.trane, .tranm,
		.stopd, .stope, .stopm, .trand
	);
	execute execute(
		.clk, .reset,
		.dataD, .dataE,
		.branch, .jump,
		.stope, .stopm
	);
	memory memory(
		.clk, .reset,
		.dataE, .dataM,
		.dreq, .dresp,
		.stopm
	);
	regfile regfile(
		.clk, .reset, .we(dataM.ctl.regwrite&&dataM.valid),
		.rs1, .rs2, .rd(dataM.dst),
		.in(dataM.result),
		.q1, .q2
	);
	logic skip = (dataM.ctl.op == SD || dataM.ctl.op == LD) && dataM.addr[31] == 0;
	assign tranm.dst = (dataM.ctl.regwrite && dataM.valid) ? dataM.dst : 0;
	assign tranm.data = dataM.result;
	assign tranm.ismem = 1;
	assign trane.dst = (dataE.ctl.regwrite && dataE.valid) ? dataE.dst : 0;
	assign trane.data = dataE.result;
	assign trane.ismem = (dataE.ctl.op == SD || dataE.ctl.op == LD);
	assign trand.dst = (dataD.ctl.regwrite && dataD.valid) ? dataD.dst : 0;
	assign trand.data = 0;
	assign trand.ismem = (dataD.ctl.op == SD || dataD.ctl.op == LD);

`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (~reset&dataM.valid),
		.pc                 (dataM.pc),
		.instr              (dataM.instr),
		.skip               (skip),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (dataM.ctl.regwrite),
		.wdest              ({3'b0,dataM.dst}),
		.wdata              (dataM.result)
	);
	      
	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (0),
		.gpr_0              (regfile.regs_nxt[0]),
		.gpr_1              (regfile.regs_nxt[1]),
		.gpr_2              (regfile.regs_nxt[2]),
		.gpr_3              (regfile.regs_nxt[3]),
		.gpr_4              (regfile.regs_nxt[4]),
		.gpr_5              (regfile.regs_nxt[5]),
		.gpr_6              (regfile.regs_nxt[6]),
		.gpr_7              (regfile.regs_nxt[7]),
		.gpr_8              (regfile.regs_nxt[8]),
		.gpr_9              (regfile.regs_nxt[9]),
		.gpr_10             (regfile.regs_nxt[10]),
		.gpr_11             (regfile.regs_nxt[11]),
		.gpr_12             (regfile.regs_nxt[12]),
		.gpr_13             (regfile.regs_nxt[13]),
		.gpr_14             (regfile.regs_nxt[14]),
		.gpr_15             (regfile.regs_nxt[15]),
		.gpr_16             (regfile.regs_nxt[16]),
		.gpr_17             (regfile.regs_nxt[17]),
		.gpr_18             (regfile.regs_nxt[18]),
		.gpr_19             (regfile.regs_nxt[19]),
		.gpr_20             (regfile.regs_nxt[20]),
		.gpr_21             (regfile.regs_nxt[21]),
		.gpr_22             (regfile.regs_nxt[22]),
		.gpr_23             (regfile.regs_nxt[23]),
		.gpr_24             (regfile.regs_nxt[24]),
		.gpr_25             (regfile.regs_nxt[25]),
		.gpr_26             (regfile.regs_nxt[26]),
		.gpr_27             (regfile.regs_nxt[27]),
		.gpr_28             (regfile.regs_nxt[28]),
		.gpr_29             (regfile.regs_nxt[29]),
		.gpr_30             (regfile.regs_nxt[30]),
		.gpr_31             (regfile.regs_nxt[31])
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
		.sstatus            (0),
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