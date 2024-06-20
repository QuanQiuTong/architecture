`ifndef PAGETABLE_SV
`define PAGETABLE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module translate (
    input clk, reset, en, 
    input [63:0] va,           // 虚拟地址
    input [63:0] satp,         // satp寄存器值
    input [1:0]  mmode,                
    output logic [63:0] pa,          // 翻译后的物理地址
    output logic valid,              // 地址翻译是否有效
    output logic [63:0] mem_addr,    // 内存访问地址
    output logic mem_req,            // 内存请求信号
    input logic [63:0] pte,          // 内存返回数据
    input logic pte_valid,           // 内存数据有效信号
    output logic done                // 地址翻译完成信号
);
    wire bare = !en || satp[63:60] == 0 || mmode == 'b11;
    wire got = pte_valid && state == READ_PTE && pte[0] == 1 && pte[3:1] != 'b000;

    enum reg [1:0] {
        IDLE,
        READ_PTE,
        DONE
    } state, next_state;
    reg [43:0] ppn, next_ppn;
    reg [1:0] level, next_level;

    always_ff @(posedge clk) begin
        state <= reset ? IDLE : next_state;
        level <= next_level;
        ppn <= next_ppn;
    end

    always_comb begin
        next_state = state;
        next_level = level;
        next_ppn = ppn;
        case (state)
            IDLE:
                if (bare) begin
                    next_state = IDLE;
                end else if (satp[63:60] == 8) begin
                    next_ppn = satp[43:0];
                    next_level = 2;
                    next_state = READ_PTE;
                end

            READ_PTE:
                if (pte_valid) begin
                    if (pte[0] == 0) begin // Invalid PTE
                        next_state = DONE;
                    end else if (pte[3:1] != 'b000) begin // Leaf PTE
                        next_state = DONE;
                    end else begin
                        next_ppn = pte[53:10];
                        next_state = (level == 0) ? DONE : READ_PTE;
                        next_level = level - 1;
                    end
                end

            DONE:
                next_state = en ? DONE : IDLE;
            default: begin end
        endcase
    end

    assign mem_req = state == READ_PTE;
    always_comb case (level)
        3: mem_addr = {8'b0, ppn, va[47:39], 3'b000};
        2: mem_addr = {8'b0, ppn, va[38:30], 3'b000};
        1: mem_addr = {8'b0, ppn, va[29:21], 3'b000};
        0: mem_addr = {8'b0, ppn, va[20:12], 3'b000};
    endcase
    assign done = bare || state == DONE || got;

    reg [63:0] _pa;
    always_latch
        if (got)
            _pa = {8'b0, pte[53:10], va[11:0]};

    assign pa = bare ? va : _pa;
    
    assign valid = 1; // ignore page fault
endmodule


`endif