`default_nettype none
module ControlUnit (
    input wire [31:0] Instr,
    
    output reg RegWrite,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg Jump,
    output reg Branch,
    output reg [2:0] ALUControl,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,

    output reg Jalr,
    output reg Halt
);
	`include "riscv_params.vh"
    
    wire [6:0] op = Instr[6:0];
    wire [2:0] funct3 = Instr[14:12];
    wire funct7_0 = Instr[25];

    wire op_5 = op[5];
    wire funct7_5 = Instr[30];

    reg [1:0] ALUOp = 2'b00;

    always @(*) begin
        ResultSrc = RESULT_SRC_ALU;
        MemWrite = 1'b0;
        ALUControl = ALU_ADD;
        ALUSrc = ALU_SRC_REG;
        ALUOp = ALU_OP_MEM;
        ImmSrc = IMM_SRC_I;
        Branch = 1'b0;
        Jump = 1'b0;
        RegWrite = 1'b0;
        Jalr = 1'b0;
        Halt = 1'b0;

        // Main Decoder
        case (op)
            OP_LOAD: begin
                RegWrite = 1'b1;
                ImmSrc = IMM_SRC_I;
                ALUSrc = ALU_SRC_IMM;
                ResultSrc = RESULT_SRC_MEM;
                ALUOp = ALU_OP_MEM;
            end
            OP_STORE: begin
                ImmSrc = IMM_SRC_S;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
                ALUOp = ALU_OP_MEM;
            end
            OP_RTYPE: begin
                RegWrite = 1'b1;
                ResultSrc = RESULT_SRC_ALU;
                ALUOp = ALU_OP_MATH;
            end
            OP_BRANCH: begin
                ImmSrc = IMM_SRC_B;
                Branch = 1'b1;
                ALUOp = ALU_OP_BRANCH;
            end
            OP_IMM: begin
                RegWrite = 1'b1;
                ImmSrc = IMM_SRC_I;
                ALUSrc = ALU_SRC_IMM;
                ResultSrc = RESULT_SRC_ALU;
                ALUOp = ALU_OP_MATH;
            end
            OP_JAL: begin
                RegWrite = 1'b1;
                ImmSrc = IMM_SRC_J;
                ResultSrc = RESULT_SRC_PCPL;
                Jump = 1'b1;
            end
            OP_JALR: begin
                RegWrite = 1'b1;
                ResultSrc = RESULT_SRC_PCPL;
                ImmSrc = IMM_SRC_I;
                ALUSrc = ALU_SRC_IMM;
                ALUOp = ALU_OP_MEM;
                Jump = 1'b1;
                Jalr = 1'b1;
            end
            OP_HALT: 
                Halt = 1'b1;
        endcase

        // ALU Decoder
        // Refer to DDCArv_Ch7 Slide 32
        casez({ALUOp, funct3, op_5 & funct7_5, op_5 & funct7_0})
            {ALU_OP_MEM, 3'b???, 2'b??}: ALUControl = ALU_ADD;
            {ALU_OP_BRANCH, 3'b???, 2'b??}: ALUControl = ALU_SUB;
            {ALU_OP_MATH, F3_ADD_SUB, 2'b00}: ALUControl = ALU_ADD;    
            {ALU_OP_MATH, F3_ADD_SUB, 2'b10}: ALUControl = ALU_SUB;    
            {ALU_OP_MATH, F3_SLT, 2'b??}: ALUControl = ALU_SLT;
            {ALU_OP_MATH, F3_OR, 2'b??}: ALUControl = ALU_OR;
            {ALU_OP_MATH, F3_AND, 2'b??}: ALUControl = ALU_AND;
            {ALU_OP_MATH, F3_SLL, 2'b??}: ALUControl = ALU_SLL;
            {ALU_OP_MATH, F3_ADD_SUB, 2'b01}: ALUControl = ALU_MUL;
        endcase
    end
endmodule
`default_nettype wire