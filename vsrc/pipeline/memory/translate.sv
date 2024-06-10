`ifndef PAGETABLE_SV
`define PAGETABLE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module translate (
    input clk, reset, en, 
    input [63:0] va,                 // 虚拟地址
    input [63:0] satp,               // satp寄存器值
    input [1:0] mmode,               // 当前特权级
    output logic [63:0] pa,          // 翻译后的物理地址
    output logic valid,              // 地址翻译是否有效
    output logic [63:0] mem_addr,    // 内存访问地址
    output logic mem_req,            // 内存请求信号
    input logic [63:0] mem_data,     // 内存返回数据
    input logic mem_data_valid,      // 内存数据有效信号
    output logic done                // 地址翻译完成信号
);
    wire [3:0] mode = satp[63:60];

    logic [63:0] pte;      // Page table entry
    logic [43:0] ppn;      // Next level PPN
    logic [2:0] level;     // Current page table level

    enum logic { IDLE, READ_PTE } state, next_state;
    always_ff @(posedge clk)
        if (reset) state <= IDLE;
        else state <= next_state;

    always_comb begin
        next_state = state;
        mem_req = 0;
        valid = 0;
        pa = 64'b0;
        mem_addr = 64'b0;
        done = 0;

        unique case (state)
            IDLE: begin
                if (mode == 0 || mmode == 'b11) begin
                    // Bare mode, no translation
                    pa = va;
                    valid = 1;
                    next_state = IDLE;
                    done = 1;
                end else if (mode == 8 || mode == 9) begin
                    // Sv39 or Sv48
                    ppn = satp[43:0];
                    level = (mode == 8) ? 2 : 3;
                    next_state = en ? READ_PTE : IDLE;
                    done = !en;
                end
            end

            READ_PTE: begin
                case (level)
                    3: mem_addr = {8'b0, ppn, va[47:39], 3'b000};
                    2: mem_addr = {8'b0, ppn, va[38:30], 3'b000};
                    1: mem_addr = {8'b0, ppn, va[29:21], 3'b000};
                    0: mem_addr = {8'b0, ppn, va[20:12], 3'b000};
                    default: mem_addr = 64'b0;
                endcase
                mem_req = 1;
                if (mem_data_valid) begin
                    pte = mem_data;
                    if (pte[0] == 0) begin
                        // Invalid PTE
                        valid = 0;
                        next_state = IDLE;
                    end else if (pte[3:1] != 'b000) begin
                        // Leaf PTE
                        pa = {8'b0, pte[53:10], va[11:0]};
                        valid = 1;
                        done = 1;
                        next_state = IDLE;
                    end else begin
                        // Non-leaf PTE
                        ppn = pte[53:10];
                        level = level - 1;
                        next_state = (level == 0) ? IDLE : READ_PTE;
                    end
                end
            end
        endcase
    end

endmodule


`endif