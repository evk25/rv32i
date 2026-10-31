`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: tb_alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_alu_control();

	reg 		[4:0] instr_split;	// {instr[30],instr[25], instr[14:12] (funct3)}
	reg 		[1:0] aluop;
	wire	[4:0] aluopcode;

	alu_control TEST(instr_split, aluop, aluopcode);

	initial begin
		$monitor("%t instr_split=%b aluop=%b aluopcode=%b", $time, instr_split, aluop, aluopcode);

		#0;
		instr_split = 5'b10101;
		aluop = 2'b00; 	// Add
		#1;
		aluop = 2'b01; 	// sub
		#1;
		aluop = 2'b10; 	// r-type funct2
		#1;
		aluop = 2'b11; 	// i-type funct3
		#1;
		$stop;

	end
endmodule
