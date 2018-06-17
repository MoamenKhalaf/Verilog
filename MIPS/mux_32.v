/*this mux has two data inputs and one output every port is 32bit*/ 

module mux_32 (d0,d1,s,out);

	input [31:0] d0; // first data input 32 bit
	input [31:0] d1; // second data input 32 bit
	input s; //sellector 1 bit

	output [31:0] out; // output 32 bit

	assign out = (s)? d1 : d0; //test the sellector "s" 
	/*if it is low ==> the output "out" = the first data input "d0"
	if it is high ==> the output "out" = the second data input "d1"*/



endmodule