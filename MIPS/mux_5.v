/*this mux has two data inputs and one output every port is 5bit
it has a 1 bit selector which select one of the two inputs to pass it to the output
*/ 

module mux_5 (d0,d1,s,out);

	input [4:0] d0; // first data input 5 bit
	input [4:0] d1; // second data input 5 bit
	input s; //sellector 1 bit

	output [4:0] out; // output 5 bit

	assign out = (s)? d1 : d0; //test the sellector "s" 
	/*if it is low ==> the output "out" = the first data input "d0"
	if it is high ==> the output "out" = the second data input "d1"*/



endmodule