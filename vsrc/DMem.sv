`ifndef DMEM_SV
`define DMEM_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module DMem import common::*;(
    input clk, read, write,
    input [2:0] func,
    input [63:0] addr, in,
    input  dbus_resp_t dresp,
    output dbus_req_t  dreq,
    output logic compl,
	output logic [63:0] out
);
    always_ff @(posedge clk) if (dresp.data_ok) compl <= 1;

	wire [5:0] off = {3'b0, addr[2:0]} << 3;
    wire [63:0] data = dresp.data >> off;
	always_ff @(posedge clk) if (dresp.data_ok)
		case(func)
		3'b000: out <= {{56{data[7]}}, data[7:0]};   // lb
		3'b001: out <= {{48{data[15]}}, data[15:0]}; // lh
		3'b010: out <= {{32{data[31]}}, data[31:0]}; // lw
		3'b011: out <= data;						 // ld
		3'b100: out <= {56'b0, data[7:0]}; 			 // lbu
		3'b101: out <= {48'b0, data[15:0]};			 // lhu
		3'b110: out <= {32'b0, data[31:0]};			 // lwu
		3'b111: begin end							 // not used
		endcase

	logic [7:0] strobe;
	always_comb case(func)
		3'b000: begin dreq.size = MSIZE1; strobe = 8'b00000001; end // sb
		3'b001: begin dreq.size = MSIZE2; strobe = 8'b00000011; end // sh
		3'b010: begin dreq.size = MSIZE4; strobe = 8'b00001111; end // sw
		3'b011: begin dreq.size = MSIZE8; strobe = 8'b11111111; end // sd
		default: begin end
		endcase
	
	assign dreq.valid = (read | write) & !compl;
	assign dreq.addr = addr;
	assign dreq.strobe = read ? 8'b0 : strobe << addr[2:0];
	assign dreq.data = in << off;

endmodule

`endif