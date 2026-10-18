// Evan Kaba
// Common macros across RISC-V RV32I Processor function units

// op
localparam [6:0] OP_RTYPE  = 7'b0110011;
localparam [6:0] OP_IMM    = 7'b0010011;
localparam [6:0] OP_LOAD   = 7'b0000011;
localparam [6:0] OP_STORE  = 7'b0100011;
localparam [6:0] OP_BRANCH = 7'b1100011;
localparam [6:0] OP_JALR   = 7'b1100111;
localparam [6:0] OP_JAL    = 7'b1101111;
localparam [6:0] OP_LUI    = 7'b0110111;
localparam [6:0] OP_HALT   = 7'b1111111;

// ImmSrc
localparam [1:0] IMM_SRC_I = 2'b00;
localparam [1:0] IMM_SRC_S = 2'b01;
localparam [1:0] IMM_SRC_B = 2'b10;
localparam [1:0] IMM_SRC_J = 2'b11;

// ALUOp
localparam [1:0] ALU_OP_MEM = 2'b00; // lw sw
localparam [1:0] ALU_OP_BRANCH = 2'b01; // beq bne,
localparam [1:0] ALU_OP_MATH = 2'b10; // R-type I-type

// ALUControl
localparam [2:0] ALU_ADD = 3'b000;
localparam [2:0] ALU_SUB = 3'b001;
localparam [2:0] ALU_AND = 3'b010;
localparam [2:0] ALU_OR = 3'b011;
localparam [2:0] ALU_SLT = 3'b101;
localparam [2:0] ALU_SLL = 3'b110;
localparam [2:0] ALU_MUL = 3'b111;
// ALU SRC Mux
localparam ALU_SRC_REG = 1'b0;
localparam ALU_SRC_IMM = 1'b1;

// funct3_2:0
localparam [2:0] F3_ADD_SUB = 3'b000;
localparam [2:0] F3_SLT = 3'b010;
localparam [2:0] F3_OR = 3'b110;
localparam [2:0] F3_AND = 3'b111;
localparam [2:0] F3_SLL = 3'b001;

// Result Src Mux
localparam [1:0] RESULT_SRC_ALU = 2'b00;
localparam [1:0] RESULT_SRC_MEM = 2'b01;
localparam [1:0] RESULT_SRC_PCPL = 2'b10;

// Program Counter Source Mux
localparam PC_SRC_INCRMT = 1'b0;
localparam PC_SRC_TARGET = 1'b1;
