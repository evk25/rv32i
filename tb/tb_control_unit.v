`timescale 1ns / 1ps

module tb_control_unit();
    `include "riscv_params.vh"

    reg  [31:0] Instr;
    wire        RegWrite;
    wire [1:0]  ResultSrc;
    wire        MemWrite;
    wire        Jump;
    wire        Branch;
    wire [2:0]  ALUControl;
    wire        ALUSrc;
    wire [1:0]  ImmSrc;
    wire        Jalr;
    wire        Halt;

    ControlUnit dut (
        .Instr      (Instr),
        .RegWrite   (RegWrite),
        .ResultSrc  (ResultSrc),
        .MemWrite   (MemWrite),
        .Jump       (Jump),
        .Branch     (Branch),
        .ALUControl (ALUControl),
        .ALUSrc     (ALUSrc),
        .ImmSrc     (ImmSrc),
        .Jalr       (Jalr),
        .Halt       (Halt)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_control_unit);
        $monitor("%t op=%b f3=%b ALUControl=%b ImmSrc=%b ALUSrc=%b MemWrite=%b ResultSrc=%b Branch=%b Jump=%b Jalr=%b RegWrite=%b Halt=%b",
                 $time, Instr[6:0], Instr[14:12], ALUControl, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, Jump, Jalr, RegWrite, Halt);

        #0;
        Instr = {7'b0000000, 5'd2, 5'd1, F3_ADD_SUB, 5'd5, OP_RTYPE};  // R-type ADD
        #1;
        Instr = {7'b0100000, 5'd2, 5'd1, F3_ADD_SUB, 5'd5, OP_RTYPE};  // R-type SUB
        #1;
        Instr = {7'b0000001, 5'd2, 5'd1, F3_ADD_SUB, 5'd5, OP_RTYPE};  // R-type MUL
        #1;
        Instr = {12'd16,     5'd0, F3_ADD_SUB, 5'd2, OP_IMM};          // I-type ADDI
        #1;
        Instr = {7'b0000000, 5'd2, 5'd1, F3_SLL,     5'd5, OP_IMM};    // I-type SLLI
        #1;
        Instr = {7'b0000000, 5'd5, 5'd1, 3'b010,     5'd0, OP_STORE};  // S-type SW
        #1;
        Instr = {12'd0,      5'd1, 3'b010,           5'd5, OP_LOAD};   // L-type LW
        #1;
        Instr = {7'b0000000, 5'd2, 5'd1, 3'b000,     5'd0, OP_BRANCH}; // B-type BEQ
        #1;
        Instr = {20'd4,                              5'd1, OP_JAL};    // J-type JAL
        #1;
        Instr = {12'd0,      5'd1, 3'b000,           5'd0, OP_JALR};   // I-type JALR
        #1;
        Instr = 32'hFFFFFFFF;                                          // HALT
        #1;
        $finish;
    end
endmodule
