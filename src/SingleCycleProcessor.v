`default_nettype none
module SingleCycleProcessor #(
    parameter MEM_FILE = "prog1.hex"
) (
    input wire clk,
    input wire rst,
    output wire Halt,
    output reg [31:0] PC,
    output reg [31:0] Result
);
	`include "riscv_params.vh"

    // PC & Fetch
    // reg [31:0] PC;
    wire [31:0] PCNext, PCPlus4, PCTarget;
    wire [31:0] Instr;

    // Control Wires
    wire PCSrc, MemWrite, ALUSrc, RegWrite, Zero, Jalr, Jump, Branch;
    wire [1:0] ResultSrc;
    wire [2:0] ALUControl;
    wire [1:0] ImmSrc;

    // ALU & ImmGen
    wire [31:0] RD1, RD2, SrcB, ALUResult, WriteData, ImmExt;

    // Memory
    wire [31:0] ReadData;
    // reg [31:0] Result; // reg so I can use a case block for cleanliness

    // ============= IF ============= 
    initial PC = 32'b0; 
    
    always @(posedge clk) begin
        if (rst) PC <= 32'b0;
        else if (!Halt) PC <= PCNext;
    end

    assign PCPlus4 = PC + 32'd4;

    (* dont_touch = "true" *)    
    InstructionMemory #(
        .MEM_FILE(MEM_FILE)
    ) u_inst_mem (
        .A (PC),
        .RD (Instr)
    );


    // ============= ID ============= 
    (* dont_touch = "true" *)
    ControlUnit u_control (
        .Instr (Instr),
        .RegWrite (RegWrite),
        .ResultSrc (ResultSrc),
        .MemWrite (MemWrite),
        .Jump (Jump),
        .Branch (Branch),
        .ALUControl (ALUControl),
        .ALUSrc (ALUSrc),
        .ImmSrc (ImmSrc),
        .Jalr (Jalr),
        .Halt (Halt)
    );
(* dont_touch = "true" *)
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
(* dont_touch = "true" *)
    ImmGen u_imm_gen (
        .Instr (Instr),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );

    // ============= EX ============= 
    assign SrcB = (ALUSrc == ALU_SRC_IMM ? ImmExt : RD2);
(* dont_touch = "true" *)
    ALU u_alu (
        .SrcA (RD1),
        .SrcB (SrcB),
        .ALUControl (ALUControl),
        .ALUResult (ALUResult),
        .Zero (Zero)
    );

    assign PCTarget = PC + ImmExt;

    assign PCSrc = (Branch & (Instr[12] ? ~Zero : Zero)) | Jump;
    
    assign PCNext = Jalr ? ALUResult :
                    PCSrc ? PCTarget :
                          PCPlus4;

    // ============= MEM ============= 
    assign WriteData = RD2;
    (* dont_touch = "true" *)
    DataMemory u_memory (
        .clk (clk),
        .WE (MemWrite),
        .A (ALUResult),
        .WD (WriteData),
        .RD (ReadData)
    );

    // =============  WB ============= 

    always @(*) begin
        case (ResultSrc)
            (RESULT_SRC_ALU): Result = ALUResult;
            (RESULT_SRC_MEM): Result = ReadData;
            (RESULT_SRC_PCPL): Result = PCPlus4;
            default: Result = 32'b0;
        endcase
    end


endmodule
`default_nettype wire