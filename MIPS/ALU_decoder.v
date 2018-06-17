/*
this module control the function of the ALU
when the opcode is 000000 (R-type) ALUOp = 10
else the the ALUOp = 00 ==> lw&sw , ALUOp = 01 ==> beq


ALUOp        funct     ALUControl
00	           x          010 add
x1             x          110 sub
1x		    100000		  010 add		
1x          100010        110 sub
1x          100100        000 and
1x          100101        001 or
1x          101010        111 slt

*/


module ALU_decoder (funct , ALUOp , ALUControl);

	input [3:0] funct; //the four least significant bits of the funct field as input to determine the operation to perform
	input [1:0] ALUOp; // 2-bit control signals which is used in conjunction with functfield to compute ALUControl

	output [2:0] ALUControl; // 3-bit control the operation of the ALU

	reg [2:0] ALUControl;

	always @(funct or ALUOp)
	begin

		case (ALUOp)

			2'b00 : ALUControl = 3'b010; // case of lw,sw instructions

			2'b01 : ALUControl = 3'b110; // case of beq instruction

			2'b10 : // case of R-type instruction
			begin

				case (funct)

					4'b0000 : ALUControl = 3'b010; // addition

					4'b0010 : ALUControl = 3'b110; // subtraction

					4'b0100 : ALUControl = 3'b000; // logical anding

					4'b0101 : ALUControl = 3'b001; // logical oring

					4'b1010 : ALUControl = 3'b111; // select less than which set the output only if A < B

					default : ALUControl = 3'b011;

				endcase

			end

			default : ALUControl = 3'b011;

		endcase

	end

endmodule