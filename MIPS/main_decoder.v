
/* ------- main decoder of teh controller -------------- */
// this module determine the control signal that controls tha path of the instruction according to the tye of the instruction.
/*
instruction   Opcode    regwrite    regdst    ALUSrc    branch    memwrite    memtoreg    ALUop   jump
  R-Type      000000        1         1           0         0         0           0         10      0
    lw        100011        1         0           1         0         0           1         00      0
    sw        101011        0         x           1         0         1           x         00      0
    beq       000100        0         x           0         1         0           x         01      0
    addi      001000        1         0           1         0         0           0         00      0
    j         000010        0         x           x         x         0           x         xx      1            
*/


module main_decoder (op , regwrite , regdst , ALUSrc , branch , memwrite , memtoreg , ALUOp , jump );

	input [5:0] op; // 6-bit Opcode field that specifies the type of the instruction

	output
		regwrite, // enable for register file writing operation 
		regdst, // selector for the mux that sellect the instruction type destination register (rt ==> i-type rd ==> r-type)
		ALUSrc,  // selector for the mux that sellect the instruction type operand source (imm ==> i-type rs|rt ==> r-type)
		branch,	// control signal that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.
		memwrite,	//enable for data memory writing operation 
		memtoreg, /* selector for the mux that sellect WD for the register file whether data 
			        from memory for lw,sw instructions or ALUresult for the others.*/
		jump; // selector for the mux which select PC', it is asserted only in case of jump instruction

	output [1:0] ALUOp; // 2-bit control signals which is used in conjunction with functfield to compute ALUControl

	reg
		regwrite, // enable for register file writing operation 
		regdst, // selector for the mux that sellect the instruction type destination register (rt ==> i-type rd ==> r-type)
		ALUSrc,  // selector for the mux that sellect the instruction type operand source (imm ==> i-type rs|rt ==> r-type)
		branch,	// control signal that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.
		memwrite,	//enable for data memory writing operation 
		memtoreg, /* selector for the mux that sellect WD for the register file whether data 
			        from memory for lw,sw instructions or ALUresult for the others.*/
		jump; // selector for the mux which select PC', it is asserted only in case of jump instruction

	reg [1:0] ALUOp;



	always @(op)
	begin

		case (op)

			6'b000000 : // the case of R-Type instructions
			begin
				regwrite = 1'b1; // write enable = 1 to enable writing in the register
				regdst = 1'b1; // select rd (instr[15:11]) as the destination register
				ALUSrc = 1'b0; // select the read data port of the register fle as the second operand to ALU
				branch = 1'b0; // sellect PC+4 as the next instruction address
				memwrite = 1'b0; // disable writing in memory
				memtoreg = 1'b0; // select the ALU result as the data to be write in the register file
				jump = 1'b0; // select PC+4 as the next instruction address
				ALUOp = 2'b10; // determine ALUcontrol according to the value of funct field

			end

			6'b100011 : // the case of lw instruction
			begin
				regwrite = 1'b1; // write enable = 1 to enable writing in the register
				regdst = 1'b0; // select rt (instr[20:16]) as the destination register
				ALUSrc = 1'b1; // select the sign extended imm as the second operand to ALU
				branch = 1'b0; // sellect PC+4 as the next instruction address
				memwrite = 1'b0; // disable writing in memory
				memtoreg = 1'b1; // select the read data port of data memory as the data to be write in the register file
				jump = 1'b0; // select PC+4 as the next instruction address
				ALUOp = 2'b00; // making the ALUControl = 010 to perform addition
			end

			6'b101011 : // the case of sw instruction
			begin
				regwrite = 1'b0; // disable writing in register file 
				regdst = 1'b1; // don't care as the addres to the register write port do not matter as regwrite is not asserted
				ALUSrc = 1'b1; // select the sign extended imm as the second operand to ALU
				branch = 1'b0; // sellect PC+4 as the next instruction address
				memwrite = 1'b1; // enable writing in memory
				memtoreg = 1'b0; // don't care as the data to the register write port do not matter as regwrite is not asserted
				jump = 1'b0; // select PC+4 as the next instruction address
				ALUOp = 2'b00; // making the ALUControl = 010 to perform addition
			end

			6'b000100 : // the case of beq instruction
			begin
				regwrite = 1'b0; // disable writing in register file 
				regdst = 1'b1; // don't care as the addres to the register write port do not matter as regwrite is not asserted
				ALUSrc = 1'b0; // select the read data port of the register fle as the second operand to ALU
				branch = 1'b1; // sellect PC+4+signimm*4 as the next instruction address
				memwrite = 1'b0; // disable writing in memory
				memtoreg = 1'b0; // don't care as the data to the register write port do not matter as regwrite is not asserted
				jump = 1'b0; // select PC+4+ signimm*4 as the next instruction address
				ALUOp = 2'b01; // making the ALUControl = 110 to perform subtraction
			end

			6'b001000 : // the case of addi
			begin
				regwrite = 1'b1; // enable writing in register file
				regdst = 1'b0; // select rt (instr[20:16]) as the destination register
				ALUSrc = 1'b1; // select the sign extended imm as the second operand to ALU
				branch = 1'b0; // sellect PC+4 as the next instruction address
				memwrite = 1'b0; // disable writing in memory
				memtoreg = 1'b0; // select the ALU result as the data to be write in the register file
				jump = 1'b0; // select PC+4 as the next instruction address
				ALUOp = 2'b00; // making the ALUControl = 010 to perform addition
			end

			6'b000010 : //the case of j instruction
			begin
				regwrite = 1'b0; // disable writing in register file
				regdst = 1'b1; // don't care as the addres to the register write port do not matter as regwrite is not asserted
				ALUSrc = 1'b0; // don't care as it does not perform a specific operation
				branch = 1'b1; // don't care as the addres already will be specified in the addr field of j instruction
				memwrite = 1'b0; // disable writing in memory
				memtoreg = 1'b0; // don't care as the data to the register write port do not matter as regwrite is not asserted
				jump = 1'b1; // select PC as specified in the addr field in j instruction
				ALUOp = 2'b11; // don't care as it does not perform a specific operation
			end

			default :
			begin
				regwrite = 1'b1;
				regdst = 1'b1;
				ALUSrc = 1'b0;
				branch = 1'b0;
				memwrite = 1'b0;
				memtoreg = 1'b0;
				jump = 1'b0;
				ALUOp = 2'b11;
			end

		endcase

	end



endmodule