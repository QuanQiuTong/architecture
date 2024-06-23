`ifndef __CSR_PKG_SV
`define __CSR_PKG_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif
package csr_pkg;
	import common::*;

	// csrs
	parameter u12 CSR_MHARTID = 12'hf14;
	parameter u12 CSR_MIE = 12'h304;
	parameter u12 CSR_MIP = 12'h344;
	parameter u12 CSR_MTVEC = 12'h305;
	parameter u12 CSR_MSTATUS = 12'h300;
	parameter u12 CSR_MSCRATCH = 12'h340;
	parameter u12 CSR_MEPC = 12'h341;
	parameter u12 CSR_SATP = 12'h180;
	parameter u12 CSR_MCAUSE = 12'h342;
	parameter u12 CSR_MCYCLE = 12'hb00;
	parameter u12 CSR_MTVAL = 12'h343;


	typedef struct packed {
		reg sd;
		reg [MXLEN-2-36:0] wpri1;
		reg[1:0] sxl;
		reg[1:0] uxl;
		reg[8:0] wpri2;
		reg tsr;
		reg tw;
		reg tvm;
		reg mxr;
		reg sum;
		reg mprv;
		reg[1:0] xs;
		reg[1:0] fs;
		reg[1:0] mpp;
		reg[1:0] wpri3;
		reg spp;
		reg mpie;
		reg wpri4;
		reg spie;
		reg upie;
		reg mie;
		reg wpri5;
		reg sie;
		reg uie;
	} mstatus_t;

	typedef struct packed {
		u4 mode;
		u16 asid;
		u44 ppn;
	} satp_t;
	
	

	typedef struct packed {
		reg[63:0]
		mhartid, // Hardware thread Id, read-only as 0 in this work
		mie,	 // Machine interrupt-enable register
		mip,	 // Machine interrupt pending
		mtvec;	 // Machine trap-handler base address
		mstatus_t
		mstatus; // Machine status register
		reg[63:0]
		mscratch, // Scratch register for machine trap handlers
		mepc,	 // Machine exception program counter
		satp,	 // Supervisor address translation and protection
		mcause,  // Machine trap cause
		mcycle,  // Counter
		mtval;
	} csr_regs_t;
	
endpackage

`endif
