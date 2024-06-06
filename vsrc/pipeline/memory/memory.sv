`ifndef _MEMORY_SV
`define _MEMORY_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/memory/pagetable.sv"
`endif

module memory
    import common::*;
    import pipes::*;(
    input    clk, reset, flushde, flushall,
    input  excute_data_t dataE,
    output memory_data_t dataM,
    output dbus_req_t    dreq,
    input  dbus_resp_t   dresp,
    output logic         stopm,
    input [63:0]         satp,
    input [1:0] mode
);
    logic valid, mem_req, done;
    wire[63:0] addr, mem_addr;
    translate tr(
        .clk, .reset,
        .en((load | store) & dataE.valid),
        .va(dataE.result),
        .satp,
        .mmode(mode),
        .pa(addr),
        .valid,
        .mem_addr,
        .mem_req,
        .mem_data(dresp.data),
        .mem_data_valid(dresp.data_ok),
        .done
    );

    wire[2:0] funct3 = dataE.instr[14:12];
    wire load = dataE.ctl.op == LD, store = dataE.ctl.op == SD;

    
    msize_t size;
    strobe_t strobe;
    always_comb case(funct3[1:0])
		'b00: begin size = MSIZE1; strobe = 8'b00000001; end // sb
		'b01: begin size = MSIZE2; strobe = 8'b00000011; end // sh
		'b10: begin size = MSIZE4; strobe = 8'b00001111; end // sw
		'b11: begin size = MSIZE8; strobe = 8'b11111111; end // sd
		endcase
    assign dreq.addr = done ? addr : mem_addr;
    assign dreq.strobe = done ? (store ? strobe << addr[2:0] : 0) : 0;
    assign dreq.size = done ? size : MSIZE8;
    assign dreq.valid = done ? (load | store) & dataE.valid : mem_req & dataE.valid;
    
    wire [63:0] in = dataE.rd2;
    wire [5:0] off = {addr[2:0], 3'b0};
    assign dreq.data = in << off;

    wire [63:0] data = dresp.data >> off;
    logic [63:0] out;
	always_comb case(funct3)
		'b000: out = {{56{data[7]}}, data[7:0]};   // lb
		'b001: out = {{48{data[15]}}, data[15:0]}; // lh
		'b010: out = {{32{data[31]}}, data[31:0]}; // lw
		'b011: out = data;						   // ld
		'b100: out = {56'b0, data[7:0]}; 		   // lbu
		'b101: out = {48'b0, data[15:0]};		   // lhu
		'b110: out = {32'b0, data[31:0]};		   // lwu
		'b111: begin out = 0; end				   // not used
		endcase

    // if done but not valid (page fault), don't stop
    assign stopm = ~done | (valid & ((load | store) & !dresp.data_ok & dataE.valid));

    always_ff @(posedge clk) 
    if (reset || flushall)
        dataM.valid  <= 0;
    else if(!flushde) begin
        dataM.pc     <= dataE.pc;
        dataM.valid  <= (!stopm & dataE.valid); // (!(load | store) | dresp.data_ok) & dataE.valid;
        dataM.instr  <= dataE.instr;
        dataM.ctl    <= dataE.ctl;
        dataM.dst    <= dataE.dst;
        dataM.result <= (load | store) ? out : dataE.result;
        dataM.addr   <= dataE.result;
        dataM.csrdst <= dataE.csrdst;
        dataM.csr    <= dataE.csr;
        dataM.error  <= dataE.error != NOERROR ? dataE.error :
                        done & ~valid ? PAGE_FAULT : NOERROR;
    end
endmodule

`endif