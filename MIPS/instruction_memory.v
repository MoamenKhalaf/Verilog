/*
this memory is where the instructions saved 
this module takes the 32-bit adress of the current instruction from the PC
and then output the 32-bit instruction to be executed
it is a cominational doesn't need any clock

*/

module instruction_memory (A , instr);

	input [31:0] A;  // 32-bit adress for the instructionm
	output [31:0] instr; // 32-bit instruction to be executed
	
	reg [31:0] instr;
	reg [31:0] instr_mmry [0:45]; // array to save the instructions
	

	//integer i;

always @ (A)
begin

	instr_mmry[0]= 32'b00100000000100000000000000000000;
	instr_mmry[1]= 32'b00100000000100010000000000000000;
	instr_mmry[2]= 32'b00100000000100100000000000000000;
	instr_mmry[3]= 32'b00100000000101010000000000000000;
	instr_mmry[4]= 32'b00100000000010000000000001100100;				
	instr_mmry[5]= 32'b00100000000010010000000011111111;
	instr_mmry[6]= 32'b00100000000010100000000011010100;										
	instr_mmry[7]= 32'b00100000000010110000000000000000;

	instr_mmry[8]= 32'b00010001000100010000000000000100;
	instr_mmry[9]= 32'b00100010000100000111010100110000;
	instr_mmry[10]= 32'b00100010001100010000000000000001;
	instr_mmry[11]= 32'b00100010101101010011101010011000;
	instr_mmry[12]= 32'b00001000000000000000000000001000;
 	

	instr_mmry[13]= 32'b10001100000100110000000000001011;
	instr_mmry[14]= 32'b00000010011010010110000000101010;
	instr_mmry[15]= 32'b00010001100010110000000000000111;
	instr_mmry[16]= 32'b00000010011010100110000000101010;
 	instr_mmry[17]= 32'b00010001100010110000000000001011;
	instr_mmry[18]= 32'b00100010011101000000011000000000;
	instr_mmry[19]= 32'b10101100000101000000000000001100;
	instr_mmry[20]= 32'b00010010000100100000000000010001;
	instr_mmry[21]= 32'b00100010010100100000000000001010;
	instr_mmry[22]= 32'b00001000000000000000000000001101;


	instr_mmry[23]= 32'b00100010011101000001111100000000;
	instr_mmry[24]= 32'b10101100000101000000000000001100;
	instr_mmry[25]= 32'b00100010011101000001111000000000;
	instr_mmry[26]= 32'b10101100000101000000000000001100;
	instr_mmry[27]= 32'b00100000000100100000000000000000;
	instr_mmry[28]= 32'b00001000000000000000000000100011;


	instr_mmry[29]= 32'b00100010011101000001011100000000;
	instr_mmry[30]= 32'b10101100000101000000000000001100;
	instr_mmry[31]= 32'b00100010011101000001011000000000;
	instr_mmry[32]= 32'b10101100000101000000000000001100;
	instr_mmry[33]= 32'b00100000000100100000000000000000;
	instr_mmry[34]= 32'b00001000000000000000000000100011;

	instr_mmry[35]= 32'b00010010010101010000000000001000;
	instr_mmry[36]= 32'b00100010010100100000000000000011;
	instr_mmry[37]= 32'b00001000000000000000000000100011;


	instr_mmry[38]= 32'b00100010011101000000011100000000;
	instr_mmry[39]= 32'b10101100000101000000000000001100;
	instr_mmry[40]= 32'b00100010011101000000011000000000;
	instr_mmry[41]= 32'b10101100000101000000000000001100;
	instr_mmry[42]= 32'b00100000000100100000000000000000;
	instr_mmry[43]= 32'b00001000000000000000000000001101;


	instr_mmry[44]= 32'b00100000000100100000000000000000;
	instr_mmry[45]= 32'b00001000000000000000000000001101;

	

	/* for (i = 46 ; i < 64 ; i = i + 1) // make all the instruction memories that is not used equal to zero
	begin
		instr_mmry [i] = 32'd0;
	end */







	instr = instr_mmry [A>>2]; // output the instruction to to be executed
end
	


endmodule