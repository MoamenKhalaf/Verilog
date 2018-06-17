/*
It is a simple adder that adds four to the pc input 
as the MIPS processor is a byte addresable we have to add four to PC addres to get the next instruction to be executed
*/



module add_four (pc , pcplus4);

	input [31:0] pc; //current instruction address
	
	output [31:0] pcplus4;//next instruction address (it will be the input for the mux which select the next addres according to the current instruction)

	wire [31:0] pcplus4;//next instruction adress

	wire [32:0] buffer;//33 bit buffer register to avoid overtflow

	
 	assign	buffer = {1'b0,pc} + 4; // add four to the current instruction address to go to the next instruction and put the result to the buffer register
 	assign	pcplus4 [31:0] = buffer [31:0]; //take the lower 32 bits and pass them to the output  


endmodule