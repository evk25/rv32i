`default_nettype none
module InstructionMemory #(
    parameter MEM_FILE = "prog1.hex"
) (
    input wire [31:0] A,

    output wire [31:0] RD
);
	`include "riscv_params.vh"

    reg [31:0] rom [0:255];

    integer i;
    initial begin
        // Fill inst mem full of halt ops
        for (i = 0; i < 256; i = i +1) begin
            rom[i] = 32'hFFFFFFFF;
        end
        // Then load program memory
        $readmemh(MEM_FILE, rom, 0);
    end

    assign RD = rom[A[9:2]];

endmodule
`default_nettype wire