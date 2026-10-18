`default_nettype none
module RegisterFile (
    input wire clk,
    input wire WE3,

    input wire [4:0] A1,
    input wire [4:0] A2,
    input wire [4:0] A3,
    input wire [31:0] WD3,

    output wire [31:0] RD1,
    output wire [31:0] RD2
);
	`include "riscv_params.vh"

    reg [31:0] rf [31:0]; // 32 registers each 32 bits wide

    assign RD1 = (A1 == 5'b0) ? 32'b0 : rf[A1];
    assign RD2 = (A2 == 5'b0) ? 32'b0 : rf[A2];

    // wipe those regs' clean
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            rf[i] = 32'b0;
        end

    //  rf[2] = 32'd1024; // program 3 stack pointer assignment 
    end

    always @(posedge clk) begin


        if (WE3 && (A3 != 5'b0)) begin
            rf[A3] <= WD3;
        end
    end
endmodule
`default_nettype wire