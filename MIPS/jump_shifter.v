
/* ------- jump shifter ---------- */
// it is a simple module which shift the input to left and adds two zeros in the two LSBs.
// jump instruction jumps directly to the instruction at the specified label.
/* The jump instruction, j, writes a new value into the PC. The two least significant
   bits of the PC are always 0, because the PC is always a multiple of 4.
   The next 26 bits are taken from the jump address field.
   The upper four bits are taken from the old value of the PC. */

module jump_shifter (jump_imm , pcplus4 , pcjump);

	input [25:0] jump_imm; //26-bit input. it is the jump address field.
	input [3:0] pcplus4; // it is the four most siginificant bits of PC+4.

	output [31:0] pcjump; // the address of the instruction to jump to it.

	wire [27:0] buffer; // 28-bit buffer for the shift operation.

	assign buffer = jump_imm << 2; // add two zeros at the LSB.

	assign pcjump = {pcplus4 , buffer}; // add the four most significant bits of PC+4.


endmodule
