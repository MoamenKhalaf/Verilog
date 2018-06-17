/*
this module is the comination of all the other modules we made that preforme the processor instructions 
the inputs of this module are the control signals from the controller 
*/

module data_path (clk , reset , regwrite , regdst , ALUSrc , ALUcontrol , branch  , memtoreg , jump , op , funct , y , rd2 , readdata);

	input 
		clk , // global system clock 
		reset, // system reset
		regwrite, // enable for register file writing operation 
		regdst, // selector for the mux that sellect the instruction type destination register (rt ==> i-type rd ==> r-type)
		ALUSrc,  // selector for the mux that sellect the instruction type operand source (imm ==> i-type rs|rt ==> r-type)
		branch,	// control signal that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.
		//memwrite,	//enable for data memory writing operation 
		memtoreg, /* selector for the mux that sellect WD for the register file whether data 
			        from memory for lw,sw instructions or ALUresult for the others.*/
		jump; // sellector for the jump instruuction address mux 

	input [2:0] ALUcontrol; // 3-bit selector to select which operation to perform

	input [31:0] readdata;

	output [5:0] op; // operation code field that specifies which type of instruction to be excutes
	output [3:0] funct; // function field which specifies the function to perform in R-type instruction

	output [31:0] y;
	output [31:0] rd2;
	

	wire 
		zero_flag, // flag which is asserted when the output y equal to zero in ALU
		pcsrc; // sellector for the mux that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.


	wire [4:0] writereg; // 5-bit adress input for the write port WD in register file



	wire [31:0] pc_i;  // 32-bit adress indicates the next instruction to be excuted in PC
	wire [31:0] pc_o; // 32-bit adress points to the current instruction to be excuted in PC
	wire [31:0] instr; // 32-bit instruction to be executed in instruction memory
	wire [31:0] pcplus4; //next instruction address in add_four
	wire [31:0] signimm; //32 bit output (extinded imm) in sign extintion
	wire [31:0] pcbranch; // the address of the instruction to be executed if beq is true in branch adder
	wire [31:0] rd1; // 32-bit data which is read from the register according to adress A1 in register file
	//wire [31:0] rd2; // 32-bit data which is read from the register according to adress A2 in register file
	wire [31:0] B; // 32-bit input to the ALU (operand) in ALU
	wire [31:0] result; // 32-bit input data to store in the register in register file
	//wire [31:0] readdata; // 32-bit data read from the memory in data memory
	//wire [31:0] y; // 32-bit output of the ALU
	wire [31:0] pcjump; // 32-bit address for jump instruction
	wire [31:0] addr; /* 32-bit address for R-type or branch instruction. 
	                     it is the output of the mux that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.*/

	assign pcsrc = zero_flag & branch;


	mux_32 pc_mux (pcplus4 , pcbranch , pcsrc , addr);

	pc pc1 (pc_i ,pc_o , clk ,reset);

	instruction_memory im (pc_o , instr);

	add_four add_four1 (pc_o , pcplus4);

	register_file reg_file (clk , reset , instr [25:21] , instr [20:16] , writereg , rd1 , rd2 , result , regwrite);

	sign_extintion sign_ext (instr [15:0] , signimm);

	mux_5 reg_write_data_address (instr [20:16] , instr [15:11] , regdst , writereg);

	mux_32 ALU_operand_mux (rd2 , signimm , ALUSrc , B);

	ALU ALU1 (rd1 , B , ALUcontrol , y , zero_flag);

	branch_adder add_branch (signimm , pcplus4 , pcbranch);

	//data_memory data_memory1 (clk , reset , y , readdata , rd2 , memwrite);
	
	mux_32 reg_write_data ( y , readdata , memtoreg , result);

	jump_shifter jump_shifter1 (instr [25:0] , pcplus4 [31:28] , pcjump);

	mux_32 jump_mux (addr, pcjump , jump , pc_i);

	assign op = instr [31:26];
	assign funct = instr [3:0];

endmodule