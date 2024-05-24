// 参考往年 https://gitlab.com/fudan-systa/arch-2023spring-fudan/-/blob/main/vsrc/include/pipes.sv

`ifndef __PIPES_SV
`define __PIPES_SV
`ifdef VERILATOR
`include "include/common.sv"
`endif
package pipes;
	import common::*;
/* Define instrucion decoding rules here */

/* Define pipeline structures here */
typedef struct packed {
	logic ismem;
	creg_addr_t dst; // 不写入时置为x0
	word_t data;
} tran_t;
typedef struct packed {
	decode_op_t op;
	alufunc_t alufunc;
	logic regwrite;
} control_t;
typedef struct packed {
	logic valid;
	u32 instr;
	u64 pc;
	error_t error;
} fetch_data_t;
typedef struct packed {
	logic valid;
	u64 pc;
	u32 instr;
	control_t ctl;
	creg_addr_t dst;
	word_t srca, srcb;	
	word_t rd2,rd1;
	logic[11:0] csrdst;
	word_t csr;
	error_t error;
} decode_data_t;
typedef struct packed {
	u64 pc;
	logic valid;
	u32 instr;
	control_t ctl;
	creg_addr_t dst;
	word_t rd2;
	word_t result;
	logic[11:0] csrdst;
	word_t csr;
	error_t error;
} excute_data_t;
typedef struct packed {
	u64 pc;
	logic valid;
	u32 instr;
	control_t ctl;
	creg_addr_t dst;
	word_t result;
	word_t addr;
	logic[11:0] csrdst;
	word_t csr;
	error_t error;
} memory_data_t;
endpackage

`endif
