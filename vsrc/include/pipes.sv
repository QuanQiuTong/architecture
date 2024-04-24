`ifndef __PIPES_SV
`define __PIPES_SV
`ifdef VERILATOR
`include "include/common.sv"
`endif
package pipes;
	import common::*;
/* Define instrucion decoding rules here */

// parameter F7_RI = 7'bxxxxxxx;
parameter F7_ALUI=   7'b0010011;
parameter F7_ALU=    7'b0110011;
parameter F7_ALUW=	 7'b0111011;
parameter F7_ALUIW=	 7'b0011011;
parameter F7_LUI=    7'b0110111;
parameter F7_JAL=    7'b1101111;
parameter F7_BRANCH= 7'b1100011;
parameter F7_LD=     7'b0000011;
parameter F7_SD=     7'b0100011;
parameter F7_AUIPC=  7'b0010111;
parameter F7_JALR=   7'b1100111;

parameter F7_FIRST_ADD=7'b0000000;
parameter F7_FIRST_SUB=7'b0100000;
parameter F7_FIRST_MUL=7'b0000001;

/* Define pipeline structures here */
typedef enum logic[5:0] {
	NOP,ALUI,ALU,ALUW,ALUIW,LUI,JAL,BEQ,LD,SD,AUIPC,JALR,BNE,BLT,BGE,BLTU,BGEU
} decode_op_t;
typedef struct packed {
	u1 ismem;
	creg_addr_t dst;// 不是写操作该数置为0
	word_t data;
} tran_t;
typedef struct packed {
	decode_op_t op;
	alufunc_t alufunc;
	u1 regwrite;
} contral_t;
typedef struct packed {
	u1 valid;
	u32 instr;
	u64 pc;
} fetch_data_t;
typedef struct packed {
	u1 valid;
	u64 pc;
	u32 instr;
	contral_t ctl;
	creg_addr_t dst;
	word_t srca, srcb;	
	word_t rd2,rd1;
} decode_data_t;
typedef struct packed {
	u64 pc;
	u1 valid;
	u32 instr;
	contral_t ctl;
	creg_addr_t dst;
	word_t rd2;
	word_t result;
} excute_data_t;
typedef struct packed {
	u64 pc;
	u1 valid;
	u32 instr;
	contral_t ctl;
	creg_addr_t dst;
	word_t result;
	word_t addr;
} memory_data_t;
endpackage

`endif
