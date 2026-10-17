
// Opcodes
localparam [6:0] OP_RTYPE  = 7'b0110011;
localparam [6:0] OP_IMM    = 7'b0010011;
localparam [6:0] OP_LOAD   = 7'b0000011;
localparam [6:0] OP_STORE  = 7'b0100011;
localparam [6:0] OP_BRANCH = 7'b1100011;
localparam [6:0] OP_JALR   = 7'b1100111;
localparam [6:0] OP_JAL    = 7'b1101111;
localparam [6:0] OP_LUI    = 7'b0110111;
localparam [6:0] OP_HALT   = 7'b1111111;

// ImmGen
localparam [1:0] IMM_SRC_I = 2'b00;
localparam [1:0] IMM_SRC_S = 2'b01;
localparam [1:0] IMM_SRC_B = 2'b10;
localparam [1:0] IMM_SRC_J = 2'b11;