module controller_unit (op , funct , regwrite , regdst , ALUSrc , branch , memwrite , memtoreg , ALUControl , jump);

	input [5:0] op; // 6-bit Opcode field of the instruction which determine the type of the instruction
	input [3:0] funct; //the four least significant bits of the funct field as input to determine the operation to perform


	output
		regwrite, // enable for register file writing operation 
		regdst, // selector for the mux that sellect the instruction type destination register (rt ==> i-type rd ==> r-type)
		ALUSrc,  // selector for the mux that sellect the instruction type operand source (imm ==> i-type rs|rt ==> r-type)
		branch,	// control signal that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.
		memwrite,	//enable for data memory writing operation 
		memtoreg, /* selector for the mux that sellect WD for the register file whether data 
			        from memory for lw,sw instructions or ALUresult for the others.*/ 
		jump; // selector for the mux which select PC', it is asserted only in case of jump instruction

	output [2:0] ALUControl; // 3-bit control the operation of the ALU

	wire [1:0] ALUOp; // 2-bit control signals which is used in conjunction with funct field to compute ALUControl
	
	
// main decoder determine most of the control signals and ALUop which is used in conjunction with funct field to compute ALUControl 
	main_decoder main_decoder1 (op , regwrite , regdst , ALUSrc , branch , memwrite , memtoreg , ALUOp , jump );
	
// ALU decoder which determine the ALUcontrol signal which specifies the operation of ALU
	ALU_decoder ALU_decoder1 (funct , ALUOp , ALUControl);

endmodule