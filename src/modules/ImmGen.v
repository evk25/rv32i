`default_nettype none

module ImmGen (
   input wire [31:0] Instr, // 32 bit wide instruction wire
   input wire [1:0]	ImmSrc, // 2 bit wide opcode control from the decoder 
   output reg [31:0] ImmExt // 23 bit wide output 
);
	// Immediate Generator is used by I, S, B, U, J type instructions [L2b, S13]
	`include "riscv_params.vh"

	// // The opcode is the lower 7 bits of the instruction
	// wire [6:0] opcode = Instr[6:0];

	always @(*) begin
		case (ImmSrc)
			// Prevent the line from holding the previous value
			default:
				ImmExt = 32'b0;

			// I-Type
			IMM_SRC_I:
				ImmExt = {{20{Instr[31]}}, Instr[31:20]};
			// S-Type
			IMM_SRC_S:
				ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
			// B-Type
			IMM_SRC_B:
				ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25],Instr[11:8], 1'b0};

			// J-Type
			IMM_SRC_J:
				ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
		endcase
	end
endmodule

`default_nettype wire