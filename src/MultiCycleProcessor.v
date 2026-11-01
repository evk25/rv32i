`default_nettype none
module MultiCycleProcessor #(
    parameter MEM_FILE = "prog1.hex"
) (
    input wire clk,
    input wire rst,
    output wire Halt
);

	`include "riscv_params.vh"

    // PC & Fetch
    reg [31:0] PC, OldPC, Instr, A, B, ALUOut, Data, Result, SrcA, SrcB;
    wire [31:0] PCNext, PCPlus4, PCTarget;
    // wire [31:0] Instr;

    // Control Wires
    wire PCUpdate, PCWrite, IRWrite, PCSrc, MemWrite, RegWrite, Zero, Jalr, Jump, Branch;
    wire [1:0] ResultSrc, ALUSrcA, ALUSrcB, ImmSrc;
    wire [2:0] ALUControl;

    // ALU & ImmGen
    wire [31:0] InstrMemOut, RD1, RD2, ALUResult, ReadData, WriteData, ImmExt;

    // FSM here
    FSMControlUnit u_ctrl (
        .Instr (Instr),

        .clk (clk),
        .rst (rst),
        .Zero (Zero),

        .IRWrite (IRWrite),
        .PCWrite (PCWrite),
        .PCUpdate (PCUpdate),
        .RegWrite (RegWrite),
        .ResultSrc (ResultSrc),
        .MemWrite (MemWrite),
        .Jump (Jump),
        .Branch (Branch),
        .ALUControl (ALUControl),
        .ALUSrcA (ALUSrcA),
        .ALUSrcB (ALUSrcB),
        .ImmSrc (ImmSrc),

        .Jalr (Jalr),
        .Halt (Halt)
    );

    // Datapath Muxes
    always @(*) begin
        case (ALUSrcA)
            ALU_SRCA_PC:    SrcA = PC;
            ALU_SRCA_OLDPC: SrcA = OldPC;
            ALU_SRCA_REG:   SrcA = A;
            default:        SrcA = 32'b0;
        endcase
        case (ALUSrcB)
            ALU_SRCB_REG:   SrcB = B;
            ALU_SRCB_IMM:   SrcB = ImmExt;
            ALU_SRCB_FOUR:  SrcB = 32'd4;
            default:        SrcB = 32'b0;
        endcase
        case (ResultSrc)
            RESULT_SRC_ALU:  Result = ALUOut;
            RESULT_SRC_MEM:  Result = Data;
            RESULT_SRC_PCPL: Result = ALUResult;
            default:         Result = 32'b0;
        endcase
    end


    initial begin
        PC = 32'b0; 
        OldPC = 32'b0;
        Instr = 32'b0;
        A = 32'b0;
        B = 32'b0;
        ALUOut = 32'b0;
        Data = 32'b0;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'b0;
            OldPC <= 32'b0;
            Instr <= 32'b0;
        end else begin
            if (IRWrite) begin
                Instr <= InstrMemOut;
                OldPC <= PC;
            end
            if (PCWrite) begin
                PC <= Result;
            end
            A <= RD1;
            B <= RD2;
            ALUOut <= ALUResult;
            Data <= ReadData;
        end
    end

    // Module Instantiation
    InstructionMemory #(
        .MEM_FILE(MEM_FILE)
    ) u_inst_mem (
        .A (PC),
        .RD (InstrMemOut)
    );

    RegisterFile u_reg_file (
        .clk (clk),
        .WE3 (RegWrite),
        .A1 (Instr[19:15]),
        .A2 (Instr[24:20]),
        .A3 (Instr[11:7]),
        .WD3 (Result),
        .RD1 (RD1),
        .RD2 (RD2)
    );

    ImmGen u_imm_gen (
        .Instr (Instr),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );

    ALU u_alu (
        .SrcA (SrcA),
        .SrcB (SrcB),
        .ALUControl (ALUControl),
        .ALUResult (ALUResult),
        .Zero (Zero)
    );

    DataMemory u_memory (
        .clk (clk),
        .WE (MemWrite),
        .A (Result),
        .WD (B),
        .RD (ReadData)
    );

endmodule
`default_nettype wire