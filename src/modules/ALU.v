`default_nettype none
module ALU (
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] ALUControl,

    output reg [31:0] ALUResult,
    output wire Zero
);
	`include "riscv_params.vh"

    assign Zero = (ALUResult == 32'b0);
    
    always @(*) begin
        case(ALUControl)
            ALU_ADD: ALUResult = SrcA + SrcB;
            ALU_SUB: ALUResult = SrcA - SrcB;
            ALU_AND: ALUResult = SrcA & SrcB;
            ALU_OR: ALUResult = SrcA | SrcB;
            ALU_SLT: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            ALU_SLL: ALUResult = SrcA << SrcB[4:0];
            ALU_MUL: ALUResult = SrcA * SrcB;
            default: ALUResult = 32'b0;
        endcase
    end
endmodule
`default_nettype wire