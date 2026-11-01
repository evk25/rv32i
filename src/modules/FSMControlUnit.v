`default_nettype none
module FSMControlUnit (
    input wire [31:0] Instr,
    input wire clk, rst, Zero,

    output reg IRWrite,
    output wire PCWrite,
    output reg PCUpdate,
    
    output reg RegWrite,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg Jump,
    output reg Branch,
    output reg [2:0] ALUControl,
    output reg [1:0] ALUSrcA, ALUSrcB, ImmSrc,

    output reg Jalr,
    output reg Halt
);
	`include "riscv_params.vh"

    // State Defs
    localparam [2:0] ST_IF  = 3'd0;
    localparam [2:0] ST_ID  = 3'd1;
    localparam [2:0] ST_EX  = 3'd2;
    localparam [2:0] ST_MEM = 3'd3;
    localparam [2:0] ST_WB  = 3'd4;


    // State Regs & init
    reg [2:0] current_state = ST_IF, next_state = ST_IF;

    always @(posedge clk) begin
        if (rst)
            current_state <= ST_IF;
        else
            current_state <= next_state;
    end


    wire [6:0] op = Instr[6:0];
    wire [2:0] funct3 = Instr[14:12];
    wire funct7_0 = Instr[25];

    wire op_5 = op[5];
    wire funct7_5 = Instr[30];

    reg [1:0] ALUOp = 2'b00;

    assign PCWrite = PCUpdate | (Branch & (Instr[12] ? ~Zero : Zero));

    // next state and main control logic
    always @(*) begin
        next_state = current_state;
        PCUpdate = 1'b0;
        Branch = 1'b0;
        IRWrite = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        Halt = 1'b0;

        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        ALUOp = ALU_OP_MEM;
        ResultSrc = RESULT_SRC_ALU;

        ALUControl = ALU_ADD;
        ImmSrc = IMM_SRC_I;
        // ALUSrc = ALU_SRC_REG;

        case (current_state)

            ST_IF: begin
                IRWrite = 1'b1;
                PCUpdate = 1'b1;
                ALUSrcA = ALU_SRCA_PC;
                ALUSrcB = ALU_SRCB_FOUR;
                ALUOp = ALU_OP_MEM;
                ResultSrc = RESULT_SRC_PCPL;

                next_state = ST_ID;
            end

            ST_ID: begin
                ALUSrcA = ALU_SRCA_OLDPC;
                ALUSrcB = ALU_SRCB_IMM;
                ALUOp = ALU_OP_MEM;

                if (op == OP_HALT) begin
                    Halt       = 1'b1;
                    next_state = ST_ID;
                end else begin
                    next_state = ST_EX;
                end
            end

            ST_EX: begin
                case (op)
                    OP_RTYPE: begin
                        ALUSrcA = ALU_SRCA_REG;
                        ALUSrcB = ALU_SRCB_REG;
                        ALUOp = ALU_OP_MATH;
                        next_state = ST_WB;
                    end

                    OP_IMM: begin
                        ALUSrcA = ALU_SRCA_REG;
                        ALUSrcB = ALU_SRCB_IMM;
                        ALUOp = ALU_OP_MATH;
                        next_state = ST_WB;
                    end
                    OP_LOAD, OP_STORE: begin
                        ALUSrcA = ALU_SRCA_REG;
                        ALUSrcB = ALU_SRCB_IMM;
                        ALUOp = ALU_OP_MEM;
                        next_state = ST_MEM;
                    end

                    OP_BRANCH: begin
                        ALUSrcA = ALU_SRCA_REG;
                        ALUSrcB = ALU_SRCB_REG;
                        ALUOp = ALU_OP_BRANCH;
                        ResultSrc = RESULT_SRC_ALU;
                        Branch = 1'b1;
                        next_state = ST_IF; 
                    end

                    OP_JAL: begin
                        ALUSrcA = ALU_SRCA_OLDPC;
                        ALUSrcB = ALU_SRCB_FOUR;
                        ALUOp = ALU_OP_MEM;
                        ResultSrc = RESULT_SRC_ALU;
                        PCUpdate = 1'b1;
                        next_state = ST_WB;
                    end

                    OP_JALR: begin
                        ALUSrcA = ALU_SRCA_REG;
                        ALUSrcB = ALU_SRCB_IMM;
                        ALUOp = ALU_OP_MEM;
                        ResultSrc = RESULT_SRC_PCPL;
                        PCUpdate = 1'b1;
                        next_state = ST_WB;
                    end

                    default: next_state = ST_IF;
                endcase
            end

            ST_MEM: begin
                ResultSrc = RESULT_SRC_ALU;
                if (op == OP_LOAD) begin
                    next_state = ST_WB;
                end else begin // OP_STORE
                    MemWrite   = 1'b1;
                    next_state = ST_IF;
                end
            end

            ST_WB: begin // R-type, I-type, LW, JAL, JALR
                RegWrite = 1'b1;
                if (op == OP_LOAD) begin
                    ResultSrc = RESULT_SRC_MEM;  
                end else if (op == OP_JALR) begin
                    ALUSrcA   = ALU_SRCA_OLDPC;
                    ALUSrcB   = ALU_SRCB_FOUR;
                    ALUOp     = ALU_OP_MEM;
                    ResultSrc = RESULT_SRC_PCPL;
                end else begin
                    ResultSrc = RESULT_SRC_ALU;
                end
                next_state = ST_IF;
            end

            default: next_state = ST_IF;
        endcase

        // Main Decoder
        case (op)
            OP_LOAD: begin
                ImmSrc = IMM_SRC_I;
            end
            OP_STORE: begin
                ImmSrc = IMM_SRC_S;
            end
            OP_BRANCH: begin
                ImmSrc = IMM_SRC_B;
            end
            OP_IMM: begin
                ImmSrc = IMM_SRC_I;
            end
            OP_JAL: begin
                ImmSrc = IMM_SRC_J;
            end
            OP_JALR: begin
                ImmSrc = IMM_SRC_I;
            end
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