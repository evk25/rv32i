`timescale 1ns / 1ns

module tb_reg_rom;
    reg  [4:0]  addr; // 5-bit word index (0..31)
    wire [31:0] byte_addr = {25'b0, addr, 2'b00}; // byte address = addr * 4
    wire [31:0] q;
    integer i;

    InstructionMemory #(
        .MEM_FILE("prog1.hex")
    ) TEST (
        .A  (byte_addr),
        .RD (q)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_reg_rom);
        $monitor("t=%0d, word_addr=%0d (byte_addr=0x%02h), instr=%h", $time, addr, byte_addr[7:0], q);

        for (i = 0; i < 16; i = i + 1) begin
            addr = i[4:0];
            #1;
        end
        $finish;
    end
endmodule
