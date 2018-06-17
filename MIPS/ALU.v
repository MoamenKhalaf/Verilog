
/* ------------- arithmetic logic unit ---------------- */
// ALU perform some logical and arithmetic operations which help excution of the program.
/*
      F                 function
     000                A and B
     001                A or B
     010                A + B
     011                not used
     100                A and (not B)
     101                A or (not B)
     110                A - B
     111                SLT
*/
// SLT instruction set the output to one only if A < B othewise the output equal zero.

module ALU (A,B,F,y,zero_flag);
  
  input [31:0] A; // 32-bit input to the ALU (operand)
  input [31:0] B; // 32-bit input to the ALU (operand)
  input [2:0] F; // 3-bit selector to select which operation to perform
  
  output [31:0] y; // 32-bit output of the ALU
  output zero_flag; // flag which is asserted when the output y equal to zero
  
  reg [31:0] y; // 32-bit output of the ALU
  reg [32:0] buffer = {1'b0,32'h00000000}; // buufer to temporary save addition result to avoid overflow. 
  
  always @ (F or A or B) // combinational logic with inputs F,A,B
  begin
    case (F) 
      3'b000: // in case of F= 000 ==> y=A&b
        begin
          y = A & B;
        end
      
      3'b001: // in case of F=001 ==> y=A|B
        begin
          y = A | B;
        end
      
      3'b010: // in case of F==010 ==> y=A+B
        begin
          buffer = {1'b0,A} + B; // put the result of two 31-bit number addition in 32-bit to avoid overflow
          y = buffer [31:0]; // assign y to the lower 31-bit of the buffer
        end
      
      3'b100: // in case of F=100 ==> y= A&(~B)
        begin
          y = (~B) & A;
        end
      
      3'b101: // in case of F=101 ==> y=A|(~B)
        begin
          y = (~B) | A;
        end
      
      3'b110: // in case of F=110 ==> y=A-B
        begin
          y = A - B;
        end
      
      3'b111: // in case of F=111 ==> set the output to one only if A<B
        begin
          if ( A < B )  y = 32'h00000001;
          
          else y = 32'h00000000;
        end
      
      default: // default case is the output y=0
        begin
          y = 32'h00000000;
        end
    endcase
  end
  
  assign zero_flag = (y) ? 1'b0:1'b1; // zero_flag indicate if the output equal zero or not

endmodule
