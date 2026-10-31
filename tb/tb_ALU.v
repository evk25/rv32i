`timescale 1ns / 1ns

module tb_ALU();
    `include "riscv_params.vh"

    wire [31:0] Y;
    wire        zero;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [2:0]  opcode;

    ALU dut (
        .SrcA       (A),
        .SrcB       (B),
        .ALUControl (opcode),
        .ALUResult  (Y),
        .Zero       (zero)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_ALU);
        $monitor("%t op=%b A=%0d B=%0d Y=%0d zero=%b", $time, opcode, $signed(A), $signed(B), $signed(Y), zero);

        #0;
        opcode = ALU_AND; // AND
        A = 32'h0005;
        B = 32'h0004;
        #1;
        opcode = ALU_OR;  // OR
        A = 32'h0007;
        B = 32'h0008;
        #1;
        opcode = ALU_ADD; // ADD
        A = 32'h0005;
        B = 32'h0004;
        #1;
        opcode = ALU_SUB; // SUB
        A = 32'h0009;
        B = 32'h0004;
        #1;
        opcode = ALU_MUL; // MUL
        A = 32'h0007;
        B = 32'h0007;
        #1;
        opcode = ALU_SLL; // SLL (Bit Shift)
        A = 32'h0003;
        B = 32'h0004;
        #1;
        opcode = ALU_SLT; // SLT
        A = -32'sd5;
        B = 32'sd4;
        #1;
        $finish;
    end
endmodule
