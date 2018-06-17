/*This is the code for sign extintion block .
In I-type instructions the imm field 16 bit we need the 16 bit to be extended to 32 bits.
So the MSB (sign bit) will be rebeated for the upper 16 bit .   
if MSB = 1 ==> negative number.
if MSB = 0 ==> positive number.
it has 16 bit input (imm field) & 32 bit output (extended imm).
*/

module sign_extintion (imm , signimm);

	input [15:0] imm; //16 bit input (imm field)
	output [31:0] signimm; //32 bit output (extended imm).

	reg [31:0] signimm; //32 bit output (extended imm).

	integer i;

	
	always @ (imm)
	begin

		signimm [15:0] = imm; //add the imm to the lower 16 bit.

		for (i = 16 ; i < 32 ; i = i + 1) //extend the MSB to the upper 16 bit.
		begin

			signimm[i] = imm[15];

		end 
		 
	end
	
endmodule
