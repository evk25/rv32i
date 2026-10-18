`default_nettype none
module DataMemory (
    input wire clk,
    input wire WE,

    input wire [31:0] A,
    input wire [31:0] WD,

    output wire [31:0] RD
);
	`include "riscv_params.vh"

    reg [31:0] mem [255:0]; // 256 words * 4 words/byte = 1024 bytes

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    assign RD = mem[A[9:2]];

    always @(posedge clk) begin
        if (WE) begin
            mem[A[9:2]] <= WD;
        end
    end
endmodule
`default_nettype wire