`timescale 1ns / 1ps

module tb_reg_file;
    reg         clk, wren;
    reg  [4:0]  rr1, rr2, wr;
    reg  [31:0] wd;
    wire [31:0] rd1, rd2;

    RegisterFile TEST (
        .clk (clk),
        .WE3 (wren),
        .A1  (rr1),
        .A2  (rr2),
        .A3  (wr),
        .WD3 (wd),
        .RD1 (rd1),
        .RD2 (rd2)
    );

    integer i;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_reg_file);
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, TEST.rf[i]);
        end
        $display("wren, wd, rr1, rr2, wr, rd1, rd2");
        clk = 1;
    end

    always #0.50 clk = ~clk;

    always @(posedge clk) begin
        $display("RegWrite=%h, writeData=%h, address1=%h, address2=%h, writeReg=%h, destR1=%h, destR2=%h",
                 wren, wd, rr1, rr2, wr, rd1, rd2);
    end

    initial begin
        #0 wren = 1;
        wr  = 5'h0;
        wd  = 32'h0;  // attempt write to x0
        rr1 = 5'h0;   // rd1 is 32'h0
        rr2 = 5'h0;   // rd2 is 32'h0
        #1 wren = 1;
        wr  = 5'h1;
        wd  = 32'h1;  // write h1 to x1
        rr1 = 5'h0;   // rd1 is 32'h0
        rr2 = 5'h0;   // rd2 is 32'h0
        #1 wren = 1;
        wr  = 5'h2;
        wd  = 32'h2;  // write h2 to x2
        rr1 = 5'h0;   // rd1 is 32'h0
        rr2 = 5'h1;   // rd2 is 32'h1
        #1 wren = 1;
        wr  = 5'h7;
        wd  = 32'h12; // write h12 to x7
        rr1 = 5'h2;   // rd1 is 32'h2
        rr2 = 5'h1;   // rd2 is 32'h1
        #1 wren = 0;
        wr  = 5'h7;
        wd  = 32'h99; // wren=0, don't write
        rr1 = 5'h2;   // rd1 is 32'h2
        rr2 = 5'h7;   // rd2 is 32'h12
        #2;
        $finish;
    end
endmodule
