
/* --------------- 32-word * 32-bit register file --------------- */
// To access operands quickly MIPS processor use 32-bit register as operands source.
// actually MIPS processor stores variables in 18 of 32 element register and the others are used by the OS and pointers.
/*
 Name            Number                   use 
  $0              0                  the constant value 0
  $at             1                  assembler temporary
 $v0-$v1         2-3                 procedure return value
 $a0-$a3         4-7                 procedure arguments
 $t0-$t7         8-15                temporary variables
 $s0-$s7         16-23               saved variables
 $t8-$t9         24-25               temporary variables
 $K0-$K1         26-27               operating sytsem temporaries
  $gp              28                global pointer
  $sp              29                stack pointer
  $fp              30                frame pointer
  $ra              31                procedure return adress
  */
// the register file has two read ports and one wirte port to read and write 32-bit register value.
// the register file read combinationally (whenever read adress change). 
// the register file write only at the rising edge of the clock.

module register_file (clk,reset,A1,A2,A3,RD1,RD2,WD,WE);
  
  input clk,          //the system clock
        reset;        // reset input for the initialization at the power up.
  input [4:0] A1;     // 5-bit adress input for the first read port RD1.
  input [4:0] A2;     // 5-bit adress input for the second read port RD2.
  input [4:0] A3;     // 5-bit adress input for the write port WD.
  input [31:0] WD;    // 32-bit input data to store in the register.
  input  WE;          // write enable inputs to enable the write operation in the register.

  output [31:0] RD1;  // 32-bit data which is read from the register according to adress A1.
  output [31:0] RD2;  // 32-bit data which is read from the register according to adress A2.
 

  reg [31:0] register [0:31]; // 32-word * 32-bit register.
  wire [31:0] WEline;  // write enable to each element of the register.
  reg [31:0] RD1=32'h00000000;
  reg [31:0] RD2=32'h00000000;
  integer i;
  
  assign WEline = (WE << A3);  // write '1' into write enable line for the selected element
  
  // sequential circuit for write operation
  always@ (posedge clk or negedge reset)
  begin
     if (!reset)  // active low reset for initialization
      begin

       
        for(i=0;i<32;i=i+1)
         register [i] = 32'h00000000;
      
      end
      
    else
      begin
        for (i=0 ; i<32 ; i=i+1)
             if (WEline[i])  
              register [i] = WD; // write the 32-bit data into the specified register.
      end
  end
  
  
  // combinational circuit for read operation
  always@ (*)
  begin
    
    // assigning the first read port
    if (A1 == 5'b00000)  RD1 = 32'h00000000; // always the register[0] contain the value 0.
    else
       RD1 = register[A1];   // read the specified register value into RD1.
    
    // assigning the second read port   
    if (A2 == 5'b00000)  RD2 = 32'h00000000;  // always the register[0] contain the value 0.
    else 
       RD2 = register[A2];   // read the specified register value into RD2.
    
      
  end
  
  
endmodule
         
        
