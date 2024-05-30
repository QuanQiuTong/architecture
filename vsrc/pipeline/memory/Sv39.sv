module Sv39 (
    input logic clk,
    input logic reset,
    input logic [63:0] va,           // 虚拟地址
    input logic [63:0] satp,         // satp寄存器值
    output logic [63:0] pa,          // 翻译后的物理地址
    output logic valid,              // 地址翻译是否有效
    output logic [31:0] mem_addr,    // 内存访问地址
    output logic mem_req,            // 内存请求信号
    input logic [63:0] mem_data,     // 内存返回数据
    input logic mem_data_valid       // 内存数据有效信号
);

    typedef enum logic [1:0] {
        IDLE,
        READ_L1,
        READ_L2,
        READ_L3,
        TRANSLATE
    } state_t;

    state_t state, next_state;

    logic [18:0] vpn[2:0];           // 虚拟页号
    logic [8:0]  ppn[2:0];           // 物理页号
    logic [63:0] pte;                // 页表项
    logic [1:0] level;               // 当前页表级别
    logic [63:0] base_addr;          // 基地址

    // 分解虚拟地址为虚拟页号
    assign vpn[2] = va[38:30];
    assign vpn[1] = va[29:21];
    assign vpn[0] = va[20:12];

    // satp寄存器中的页表基地址
    assign base_addr = {satp[43:0], 12'b0};

    // 状态机
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        mem_req = 0;
        valid = 0;

        case (state)
            IDLE: begin
                if (va != 64'b0) begin
                    level = 2;
                    mem_addr = base_addr[31:0] + (vpn[2] * 8);
                    mem_req = 1;
                    next_state = READ_L1;
                end
            end

            READ_L1: begin
                if (mem_data_valid) begin
                    pte = mem_data;
                    if (pte[0] == 0) begin  // 如果页表项无效
                        next_state = IDLE;
                    end else begin
                        level = 1;
                        mem_addr = {pte[53:10], vpn[1], 3'b0};
                        mem_req = 1;
                        next_state = READ_L2;
                    end
                end
            end

            READ_L2: begin
                if (mem_data_valid) begin
                    pte = mem_data;
                    if (pte[0] == 0) begin  // 如果页表项无效
                        next_state = IDLE;
                    end else begin
                        level = 0;
                        mem_addr = {pte[53:10], vpn[0], 3'b0};
                        mem_req = 1;
                        next_state = READ_L3;
                    end
                end
            end

            READ_L3: begin
                if (mem_data_valid) begin
                    pte = mem_data;
                    if (pte[0] == 0) begin  // 如果页表项无效
                        next_state = IDLE;
                    end else begin
                        ppn[2] = pte[53:28];
                        ppn[1] = pte[27:19];
                        ppn[0] = pte[18:10];
                        next_state = TRANSLATE;
                    end
                end
            end

            TRANSLATE: begin
                pa = {ppn[2], ppn[1], ppn[0], va[11:0]};
                valid = 1;
                next_state = IDLE;
            end
        endcase
    end
endmodule