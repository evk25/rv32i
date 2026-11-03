`timescale 1ns / 1ns

module tb_top();
    parameter MEM_FILE = "prog2.hex";

    reg  clk = 1'b0;
    reg  rst = 1'b0;
    wire Halt;

    always #1 clk = ~clk;

    SingleCycleProcessor #(
        .MEM_FILE(MEM_FILE)
    ) uut (
        .clk  (clk),
        .rst  (rst),
        .Halt (Halt)
    );

    // MultiCycleProcessor #(
    //     .MEM_FILE(MEM_FILE)
    // ) uut (
    //     .clk (clk),
    //     .rst (rst),
    //     .Halt (Halt)
    // );

    // Dump all processor signals plus RegisterFile and DataMemory words
    integer i;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, uut.u_memory.mem[i]);
            $dumpvars(0, uut.u_reg_file.rf[i]);
        end
    end

    // Stop on Halt (or safety timeout) and print non-zero memory words
    integer m;
    initial begin
        if (MEM_FILE == "fact.hex") begin
            #0 uut.u_reg_file.rf[2] = 32'd1024; // Initialize SP (x2) to top of 1024B memory
        end
        fork
            begin
                wait (Halt == 1'b1);
                #10; // Let final clock edge settle for waveform viewer
                $display("=== Halt reached at PC = 0x%08h (Program: %s) ===", uut.PC, MEM_FILE);
            end
            begin
                #10000;
                $display("=== TIMEOUT reached at PC = 0x%08h ===", uut.PC);
            end
        join_any

        $display("--- Non-zero DataMemory words ---");
        for (m = 0; m < 256; m = m + 1) begin
            if (uut.u_memory.mem[m] !== 32'b0) begin
                $display("mem[%0d] (byte addr 0x%03h / %0d) = %0d (0x%08h)",
                         m, m * 4, m * 4, $signed(uut.u_memory.mem[m]), uut.u_memory.mem[m]);
            end
        end
        $finish;
    end
endmodule
