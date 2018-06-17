/*
this module calculates the address of the instruction to be executed if beq is true
it takes the branch by adding the branch offset to the program counter.
offset is a positive or negative number, stored in the imm field of the instruction so it has to be sign extended
PC' = PC + 4 + SignImm * 4.
*/

module branch_adder (signimm , pcplus4 , pcbranch);
	input [31:0] signimm; // nuber of instructions to be passed
	input [31:0] pcplus4; // the address of the instruction after beq

	output [31:0] pcbranch; // the address of the instruction to be executed if beq is true

	wire [32:0] buffer; // buufer to temporary save addition result to avoid overflow. 

	wire [31:0] shift_buffer; // a buffer to shif the signed imm in by 2 (signimm * 4)

	assign shift_buffer = signimm << 2; // multiply sign extended adress by 4

	assign buffer = {1'b0 , shift_buffer} + pcplus4; // PC' = PC + 4 + SignImm * 4.

	assign pcbranch = buffer [31:0]; 


endmodule