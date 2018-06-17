
/* ---------------- Program counter ----------------- */
// the program counter is an ordinary 32-bit register.
// program counter input indicate the adrees of the next instruction to be excuted.
// program counter output points the current instruction to be excuted.
/* MIPS initialize PC to 0xBFC00000 and then the operating system loads
   an application program at 0x00400000and begins excuting them */
// for simplicity we will reset the PC to 0x00000000 and place the program there.

module pc (PC_i,PC_o,clk,reset);
  input clk,     // system clock
        reset;   // reset input to initialize the program counter
  input [31:0] PC_i;  // 32-bit address indicates the next instruction to be excuted
  
  output [31:0] PC_o;  // 32-bit address points to the current instruction to be excuted. (it will be the input for the instruction memory)
  
  reg [31:0] PC_o; 
  
  always@ (posedge clk or negedge reset)
  begin
    if (!reset)    // active low reset to initialize the program counter
         PC_o <= 32'h00000000;
         
    else
        PC_o <= PC_i; /* at the rising edge of the clock signal 
                        the addres of the next instruction is assigned to the output of the program counter */
  end
  
endmodule

