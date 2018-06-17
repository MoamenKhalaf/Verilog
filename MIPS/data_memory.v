
/* ------------ Data memory ------------- */
// there is where the load and store instructions read or write the data from it.
// it has a single read-write port.
/* if write enable (WE) is active the memory write the 32-bit data (WD) in the specified 
   adress at the rising edge of the clock. */
// if write enable (WE) is low it read adress (A) into RD.
// the read operation is done combinationally.

module data_memory (clk , reset , A , RD , WD , WE);
  
  input clk,    // system clock.
        reset,  // reset input to initialize the system.
        WE;     // write enable input to decide if read or write.
  
  input [31:0] A;  // 32-bit address 
  input [31:0] WD; // 32-bit to store in the memory.
  
  output [31:0] RD; // 32-bit data read from the memory.
  
  reg [31:0] RD = 32'h00000000;
  reg [31:0] memory [0:4];  // memory size 2048 element.
  
  wire [4:0] WEline; // write enable to each element of the memory. 
  integer i;
  
  assign WEline = (WE << A); // write '1' into write enable line for the selected element
  
  // sequential circuit for write operation
  always@ (posedge clk or negedge reset)
  begin
    if (!reset) // active low reset for initialization
        for (i=0 ; i < 5 ; i=i+1)
            memory [i] = 32'h00000000;
    else // at the rising edge of the clock the write operation is performed if the WE is one
      for (i=0 ; i < 5 ; i=i+1)
          if (WEline [i])  memory [i] = WD;
  end
  
  // combinational circuit for read operation
  always@ (*)
  begin
    if (!reset) RD = 32'h00000000;
    else if (!WE)
      if (A < 5)
        RD = memory [A]; // read the content of the memory to RD if WE = 0
      else
        RD = 32'h00000000;
    else
       RD = 32'h00000000;

    
  end
  
endmodule

    
