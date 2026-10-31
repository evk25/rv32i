`timescale 1ns / 1ns

module tb_imm_gen;
    `include "riscv_params.vh"

    reg  [31:0] instr;
    reg  [1:0]  immSrc;
    wire [31:0] out;

    ImmGen TEST (
        .Instr  (instr),
        .ImmSrc (immSrc),
        .ImmExt (out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_imm_gen);
        $display("time | ImmSrc | instr (hex) | ImmExt (hex) | ImmExt (signed dec)");
        $monitor("%4t |   %b   |  %h   |   %h   | %0d", $time, immSrc, instr, out, $signed(out));

        #0;
        immSrc = IMM_SRC_I;
        instr  = 32'b00000000011100000000000000010011; // I-type: +7
        #1;
        immSrc = IMM_SRC_I;
        instr  = 32'b11100000011100000000000000010011; // I-type: -505 (0xfffffe07)
        #1;
        immSrc = IMM_SRC_S;
        instr  = 32'b11100000011100000000000000100011; // S-type: -512 (0xfffffe00)
        #1;
        immSrc = IMM_SRC_S;
        instr  = 32'b00000000011100000000000110100011; // S-type: +3
        #1;
        immSrc = IMM_SRC_B;
        instr  = 32'b00000000000000000000000101100011; // B-type: +2
        #1;
        immSrc = IMM_SRC_B;
        instr  = 32'b00000010000000000000000001100011; // B-type: +32 (0x20)
        #1;
        immSrc = IMM_SRC_B;
        instr  = 32'b00000000000000000000000011100011; // B-type: +2048 (0x800)
        #1;
        immSrc = IMM_SRC_B;
        instr  = 32'b10000000000000000000000001100011; // B-type: -4096 (0xfffff000)
        #1;
        immSrc = IMM_SRC_J;
        instr  = 32'h008000ef;                         // J-type: +8
        #1;
        $finish;
    end
endmodule
