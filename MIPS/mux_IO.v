/* ------------- IO Mux ------------ */
// it selects between memory and the various I/O devices.

module mux_IO (RDM , RD1 , RD2 , RD3 , RDSel , readdata);

	input [31:0] RDM; // readdata from memory
	input [31:0] RD1; // readdata from device 1
	input [31:0] RD2; // readdata from device 2 
	input [31:0] RD3; // readdata from device 3
	input [1:0] RDSel; // readdata selectors to select between memory and the other devices

	output [31:0] readdata; // the selected readdata output from the mux

	reg [31:0] readdata;

	always @(*)
	begin

		case (RDSel)

			2'b00 : readdata = RDM; // case of readdata from memory

			2'b01 : readdata = RD1; // case of readdata from device 1

			2'b10 : readdata = RD2; // case of readdata from device 2

			2'b11 : readdata = RD3; // case of readdata from device 3

		endcase

	end

endmodule