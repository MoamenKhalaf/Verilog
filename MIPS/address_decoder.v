/* --------------- address decoder -------------- */
/* The processor accesses an I/O device using the address and data busses in
   the same way that it accesses memory.*/
// A portion of the address space is dedicated to I/O devices.
// address decoder determines which device communicates with the processor.
// It uses the Address and MemWrite signals to generate control signals for the I/O devices.

module address_decoder (memwrite , address , WE , WEM , RDSel);

	input memwrite; // write enable input from the control unit of the processor
	input [31:0] address; // the address of the device or memory to read from or write in

	output WEM; // write enable for writing in the memory
	output [1:0] RDSel; // 2-bit selectors for the mux which select read data from which device.
	output [2:0] WE; // write enable for I/O devices

	reg WEM;
	reg [1:0] RDSel;
	reg [2:0] WE;

	always @(*)
	begin

		case (address)

			32'd11: // the first device has address 32'd11
				begin
					RDSel = 2'b01; // select  the readdata from the first device
					WEM = 1'b0; // disable writing in the main memory

					if (memwrite) WE = 3'b001; // enble writing in the first device if memwrite = 1
					else WE = 3'b000;

				end

			32'd12: //the second device has address 32'd12
				begin
					RDSel = 2'b10; // select  the readdata from the second device
					WEM = 1'b0; // disable writing in the main memory

					if (memwrite) WE = 3'b010; // enble writing in the second device if memwrite = 1
					else WE = 3'b000;
					
				end

			32'd13: //the third device has address 32'd12
				begin
					RDSel = 2'b11; // select  the readdata from the third device
					WEM = 1'b0; // disable writing in the main memory

					if (memwrite) WE = 3'b100; // enble writing in the third device if memwrite = 1
					else WE = 3'b000;
					
				end

			default: // default case is writing in the main memory
				begin
					RDSel = 2'b00; // select  the readdata from the memory
					WE = 3'b000; // disable writing in the I/O devices

					if (memwrite) WEM = 1'b1; // enble writing in the memory if memwrite = 1
					else WEM = 1'b0;
					
				end

		endcase

	end





endmodule