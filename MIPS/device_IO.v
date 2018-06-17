/* ----------- I/O device ----------- */
// This is the interface module with the processor.
// it can be used as input or output.
// to take a data from the user we need a portion of memory to save the data in it. so in this case this module used as input
// to output data to the user we use this module as output 
// it is simply a portion from the memory has a specified address.
// A store to the specified address sends data to the device.
//A load receives data from the device.

module device_IO (clk , writedata , WE , read , intrface );

	input
		clk, // system clock
		WE; // write enable

	input [31:0] writedata; // 32-bit data to be output to teh user

	output [31:0] read; // 32-bit data read from the input device to be accessed by the processor

	inout [31:0] intrface; // the inout port to read or write data

	reg [31:0] buffer = 32'd0;

	wire [31:0] read ; // buffer to save the data
	

	always @(posedge clk)
	begin

		if (WE)
		begin
			
			buffer = writedata;

			

		end

		else
		begin
			
			buffer = intrface;
			//read <= buffer;

		end

	end

	assign read = buffer;
	assign intrface = buffer;

endmodule