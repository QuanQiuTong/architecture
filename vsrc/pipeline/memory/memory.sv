`ifndef _MEMORY_SV
`define _MEMORY_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module memory
    import common::*;
    import pipes::*;(
    input           clk, reset,
    input excute_data_t  dataE,
    output memory_data_t dataM,
    output dbus_req_t    dreq,
    input dbus_resp_t    dresp,
    output logic         stopm
);
    wire[2:0] funct3 = dataE.instr[14:12];
    wire load = dataE.ctl.op == LD, store = dataE.ctl.op == SD;
    wire [63:0] addr = dataE.result, in = dataE.rd2;

    wire [5:0] off = {addr[2:0], 3'b0};
    wire [63:0] data = dresp.data >> off;
    logic [63:0] out;
	always_comb case(funct3)
		3'b000: out = {{56{data[7]}}, data[7:0]};   // lb
		3'b001: out = {{48{data[15]}}, data[15:0]}; // lh
		3'b010: out = {{32{data[31]}}, data[31:0]}; // lw
		3'b011: out = data;						    // ld
		3'b100: out = {56'b0, data[7:0]}; 			// lbu
		3'b101: out = {48'b0, data[15:0]};			// lhu
		3'b110: out = {32'b0, data[31:0]};			// lwu
		3'b111: begin end							// not used
		endcase
    strobe_t strobe;
    always_comb case(funct3)
		3'b000: begin dreq.size = MSIZE1; strobe = 8'b00000001; end // sb
		3'b001: begin dreq.size = MSIZE2; strobe = 8'b00000011; end // sh
		3'b010: begin dreq.size = MSIZE4; strobe = 8'b00001111; end // sw
		3'b011: begin dreq.size = MSIZE8; strobe = 8'b11111111; end // sd
		default: begin end
		endcase
    assign dreq.addr = addr;
    assign dreq.strobe = store ? strobe << addr[2:0] : 0;
    assign dreq.data = in << off;
    assign dreq.valid = (load | store) & dataE.valid;

    assign stopm = (load | store) & !dresp.data_ok & dataE.valid;

    always_ff @(posedge clk) begin
        dataM.pc     <= dataE.pc;
        dataM.valid  <= !stopm & dataE.valid; // (!(load | store) | dresp.data_ok) & dataE.valid;
        dataM.instr  <= dataE.instr;
        dataM.ctl    <= dataE.ctl;
        dataM.dst    <= dataE.dst;
        dataM.result <= (load | store) ? out : dataE.result;
        dataM.addr   <= dataE.result;
    end
endmodule

`endif