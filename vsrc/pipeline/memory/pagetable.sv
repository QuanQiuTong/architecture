`ifndef PAGETABLE_SV
`define PAGETABLE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`endif

module translate (
    input clk, reset, en, 
    input logic [63:0] va,           // 虚拟地址
    input logic [63:0] satp,         // satp寄存器值
    input [1:0] mmode,                
    output logic [63:0] pa,          // 翻译后的物理地址
    output logic valid,              // 地址翻译是否有效
    output logic [63:0] mem_addr,    // 内存访问地址
    output logic mem_req,            // 内存请求信号
    input logic [63:0] pte,          // 内存返回数据
    input logic pte_valid,           // 内存数据有效信号
    output logic done                // 地址翻译完成信号
);
    logic [43:0] ppn;
    logic [1:0] level;     // Current page table level

    enum reg [1:0] {
        IDLE,
        READ_PTE,
        DONE
    } state, next_state;

    // State machine
    always_ff @(posedge clk)
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end

    always_comb begin
        next_state = state;
        valid = 0;
        mem_req = 0;
        mem_addr = 64'b0;
        done = 0;

        case (state)
            IDLE: begin
                if (!en || satp[63:60] == 0 || mmode == 'b11) begin
                    pa = va;
                    valid = 1;
                    next_state = IDLE;
                    done = 1;
                end else if (satp[63:60] == 8) begin
                    ppn = satp[43:0];
                    level = 2;
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
                endcase
                mem_req = 1;
                if (pte_valid) begin
                    if (pte[0] == 0) begin
                        // Invalid PTE
                        valid = 0;
                        next_state = DONE;
                    end else if (pte[3:1] != 'b000) begin
                        // Leaf PTE
                        pa = {8'b0, pte[53:10], va[11:0]};
                        valid = 1;
                        done = 1;
                        next_state = DONE;
                        // next_state = en ? DONE : IDLE;
                    end else begin
                        // Non-leaf PTE
                        ppn = pte[53:10];
                        next_state = (level == 0) ? DONE : READ_PTE;
                        level = level - 1;
                    end
                end
            end

            DONE: begin
                done = 1;
                next_state = en ? DONE : IDLE;
                pa = pa;
            end
            default: begin
                // Do nothing
            end
        endcase
    end

endmodule


`endif