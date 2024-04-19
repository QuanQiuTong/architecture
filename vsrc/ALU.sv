`ifndef __ALU_SV
`define __ALU_SV
`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module ALU import common::*;(
    input [63:0] a, b,
    input [4:0] ctrl,
    input clk, en,
    output compl,
    output logic [63:0] result,
    output zero
);
    wire sd = ctrl == DIV || ctrl == REM || ctrl == DIVW || ctrl == REMW,
         wd = ctrl == DIVW || ctrl == DIVUW || ctrl == REMW || ctrl == REMUW;
    wire mcompl, dcompl;
    wire [63:0] prodh, prodl, quot, rem;

    ClkMul _ClkMul (clk, en, a, b, {prodh, prodl}, mcompl);
    Divider _(clk, en, f(sd, wd, a), f(sd, wd, b), quot, rem, dcompl);

    assign compl = ctrl == MUL || ctrl == MULW ? mcompl :
                   ctrl == DIVU || ctrl == REMU || sd || wd ? dcompl : 1;
    assign zero = (result == 0);
    
    always_comb
    case (ctrl)
        _AND: result = a & b;
        _OR:  result = a | b;
        ADD:  result = a + b;
        SUB:  result = a - b;
        SLT:  result = $signed(a) < $signed(b) ? 1 : 0;
        SLTU: result = a < b ? 1 : 0;
        NOR:  result = ~(a | b);
        _XOR: result = a ^ b;
        CPYB: result = b;
        SLL:  result = a << b[5:0];
        SRL:  result = a >> b[5:0];
        SRA:  result = $signed(a) >>> b[5:0];

        ADDW:  result = sext(a[31:0] + b[31:0]);
        SUBW:  result = sext(a[31:0] - b[31:0]);
        SLLW:  result = sext(a[31:0] << b[4:0]);
        SRLW:  result = sext(a[31:0] >> b[4:0]);
        SRAW:  result = sext($signed(a[31:0]) >>> b[4:0]);
        MUL:   result = prodl;
        DIV:   result = |b ? a[63] ^ b[63] ? -quot : quot : -1;
        DIVU:  result = |b ? quot : -1;
        REM:   result = |b ? a[63] ? -rem : rem : a;
        REMU:  result = |b ? rem : a;
        MULW:  result = sext(prodl[31:0]);
        DIVW:  result = sext(|b[31:0] ? a[31] ^ b[31] ? -quot[31:0] : quot[31:0] : -1);
        DIVUW: result = sext(|b[31:0] ? quot[31:0] : -1);
        REMW:  result = sext(|b[31:0] ? a[31] ? -rem[31:0] : rem[31:0] : a[31:0]);
        REMUW: result = sext(|b[31:0] ? rem[31:0] : a[31:0]);

        default: result = 64'hdeadbeefdeadbeef;
    endcase

    function[63:0] sext (input [31:0] x);
        sext = {{32{x[31]}}, x};
    endfunction
    
    function[63:0] f (input sgn, input word, input [63:0] x);
        f = word ? {32'b0, sgn & x[31] ? -x[31:0] : x[31:0]} : sgn & x[63] ? -x : x;
    endfunction
endmodule

`endif