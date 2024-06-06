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
	input  logic       clk, reset,
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
	wire[4:0]  rs1, rs2;
	wire[11:0] csrs;     // CSR source
	wire[63:0] q1, q2, qcsr;
	logic stopf, stopd, stope, stopm, branch;
	wire[63:0] jump;
	tran_t trane,tranm;
	logic flushde, flushall;
	logic[63:0] csrpc;
	dbus_req_t freq, mreq;
	always_comb 
		if(freq.valid)
			dreq = freq;
		else if(mreq.valid)
			dreq = mreq;
		else
			dreq = dbus_req_t'(0);

	fetch fetch(
		.clk, .reset, 
		.ireq, .iresp,
		.dreq(freq), .dresp,
		.branch, .jump,
		.stop(stopd | stope | stopm),
		.flushall,
		.op(decode.op),
		.satp(csr.regs.satp),
		.mode(csr.mode),
		.csrpc,
		.stopf,
		.dataF
	);
	decode decode(
		.clk, .reset,
		.dataF, .dataD,
		.rs1, .rs2, .q1, .q2,
		.branch,
		.stopd, .stope, .stopm,
		.trane, .tranm,
		.csrs, .qcsr, .flushde
	);
	execute execute(
		.clk, .reset,
		.dataD, .dataE,
		.branch, .jump,
		.stope, .stopm,
		.flushde
	);
	memory memory(
		.clk, .reset,
		.dataE, .dataM,
		.dreq(mreq), .dresp,
		.stopm,
		.flushde, .flushall,
		.satp(csr.regs.satp),
		.mode(csr.mode)
	);
	regfile regfile(
		.clk, .reset,
		.we(dataM.ctl.regwrite && dataM.valid),
		.rs1, .rs2, .rd(dataM.dst),
		.in(dataM.result),
		.q1, .q2
	);
	csr csr(
		.clk, .reset,
		.ra(csrs), .rd(qcsr),
		.csrpc,
		.dataM,
		.trint, .swint, .exint,
		.stopm, .stopf,
		.flushde, .flushall
	);
	// if not deal with "page fault", outcome:
	// a5 different at pc = 0x00800019bc, right= 0x000000008000f000, wrong = 0x0000000000000000
    // info:
	// 800019bc:	0204b783          	ld	a5,32(s1)
	assign tranm = '{1, (dataM.ctl.regwrite && dataM.valid && dataM.error == NOERROR ? dataM.dst : 0), dataM.result};
	assign trane.dst = (dataE.ctl.regwrite && dataE.valid) ? dataE.dst : 0;
	assign trane.data = dataE.result;
	assign trane.ismem = (dataE.ctl.op == SD || dataE.ctl.op == LD);

`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (~reset && dataM.valid && dataM.error == NOERROR),
		.pc                 (dataM.pc),
		.instr              (dataM.instr),
		.skip               ((dataM.ctl.op == SD || dataM.ctl.op == LD) && dataM.addr[31] == 0),
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
		.priviledgeMode     (csr.mode_nxt),
		.mstatus            (csr.regs_nxt.mstatus),
		.sstatus            (csr.regs_nxt.mstatus & 64'h800000030001e000),
		.mepc               (csr.regs_nxt.mepc),
		.sepc               (0),
		.mtval              (csr.regs_nxt.mtval),
		.stval              (0),
		.mtvec              (csr.regs_nxt.mtvec),
		.stvec              (0),
		.mcause             (csr.regs_nxt.mcause),
		.scause             (0),
		.satp               (csr.regs_nxt.satp),
		.mip                (csr.regs_nxt.mip),
		.mie                (csr.regs_nxt.mie),
		.mscratch           (csr.regs_nxt.mscratch),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	);
`endif
endmodule
