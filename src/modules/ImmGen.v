`default_nettype none

module ImmGen (
   input wire [31:0] instr, // 32 bit wide instruction wire
   input wire [1:0]	immSrc, // 2 bit wide opcode control from the decoder 
   output reg [31:0] extImm // 23 bit wide output 
);
	// Immediate Generator is used by I, S, B, U, J type instructions [L2b, S13]
	`include "riscv_params.vh"

	// // The opcode is the lower 7 bits of the instruction
	// wire [6:0] opcode = Instr[6:0];

	always @(*) begin
		case (immSrc)
			// Prevent the line from holding the previous value
			default:
				extImm = 32'b0;

			// I-Type
			IMM_SRC_I:
				extImm = {{20{instr[31]}}, instr[31:20]};
			// S-Type
			IMM_SRC_S:
				extImm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
			// B-Type
			IMM_SRC_B:
				extImm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25],instr[11:8], 1'b0};

			// J-Type
			IMM_SRC_J:
				extImm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
		endcase
	end
endmodule

`default_nettype wire