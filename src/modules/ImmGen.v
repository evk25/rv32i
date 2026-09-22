module ImmGen (
   input [31:0] instr, //32 bit instruction
   output [31:0] out //  output reg [31:0] out;
);

	// Wire for opcode (Lowest 7 bits of Inst)
	wire [6:0] opcode = instr[6:0];

	// Immediate Generator is used by I, S, B, U, J type instructions [L2b, S13]
	// I-Type
	localparam OP_JALR 		= 7'b1100111; // JALR
	localparam OP_LOAD 		= 7'b0000011; // LB LH LW LBU LHU
	localparam OP_IMM 		= 7'b0010011; // ADDI SLTI SLTIU XORI ORI ANDI

	// S-Type
	localparam OP_STORE 		= 7'b0100011; // SB SH SW

	// SB-Type
	localparam OP_BRANCH		= 7'b1100011; // BEQ BNE BLT BGE BLTU BGEU

	// U-Type
	localparam OP_LUI		= 7'b0110111; // LUI AUIPC

	// UJ-type
	localparam OP_JAL		= 7'b1101111; // JAL

	always @(*) begin
		case (opcode)
			// I-Type
			OP_JALR, OP_IMM, OP_LOAD:
				out = {{20{instr[31]}}, instr[31:20]};
			// S-Type
			OP_STORE:
				out = {};

			// SB-Type
			OP_STORE:
				out = {};

			// U-Type
			OP_LUI:
				out = {};

			//UJ-Type
			OP_JAL:
				out = {};

			default:
				out = 32'd0;
		endcase
	end






    //I-type
	// finish your design here
					  // S-type
					  // SB type
					  // JAL
					  // JALR
					  // L-type
						; // default


endmodule
