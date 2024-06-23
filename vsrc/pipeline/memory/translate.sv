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
    output [63:0] pa,          // 翻译后的物理地址
    output valid,              // 地址翻译是否有效
    output logic [63:0] mem_addr,    // 内存访问地址
    output mem_req,            // 内存请求信号
    input  [63:0] pte,          // 内存返回数据
    input  pte_valid,           // 内存数据有效信号
    output done                // 地址翻译完成信号
);
    wire bare = satp[63:60] == 0 || mmode == 'b11;

    enum reg [1:0] { IDLE, READ_PTE, DONE } state, next_state;
    reg [43:0] ppn, next_ppn;
    reg [1:0] level, next_level;
    reg [63:0] phy_addr, next_pa;

    always_ff @(posedge clk) 
    if (reset) begin
        state <= IDLE;
        level <= 0;
        ppn <= 0;
        phy_addr <= 0;
    end else begin
        state <= next_state;
        level <= next_level;
        ppn <= next_ppn;
        phy_addr <= next_pa;
    end

    always_comb begin
        next_state = state;
        next_level = level;
        next_ppn = ppn;
        next_pa = phy_addr;
        case (state)
        IDLE:
            if (!en || bare) begin
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
                    next_pa = {8'b0, pte[53:10], va[11:0]};
                end else begin
                    next_ppn = pte[53:10];
                    next_state = (level == 0) ? DONE : READ_PTE;
                    next_level = level - 1;
                end
            end

        DONE:
            next_state = en ? DONE : IDLE;
        default:
            begin end
        endcase
    end

    assign mem_req = state == READ_PTE;
    always_comb case (level)
        3: mem_addr = {8'b0, ppn, va[47:39], 3'b000};
        2: mem_addr = {8'b0, ppn, va[38:30], 3'b000};
        1: mem_addr = {8'b0, ppn, va[29:21], 3'b000};
        0: mem_addr = {8'b0, ppn, va[20:12], 3'b000};
    endcase
    assign done = !en || bare || state == DONE;            
    assign pa = bare ? va : phy_addr;
    
    assign valid = 1; // ignore page fault
endmodule


`endif