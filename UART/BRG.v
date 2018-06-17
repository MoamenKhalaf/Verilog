
/* ------ baud rate generatoor ------- */
// the system clock rate is 50 MHz.
// the used baud rate is 19,200 bit per second.
// The used sampling rate is 16 times the baud rate, which means that each
// serial bit is sampled 16 times.
// the baud rate generator needs a mod-163 counter.

module BRG (clock,reset,tick,br_choice);
  
input clock, // the system clock which is 50MHz.
      reset; // reset input to initialize the counter at the power up.
input [1:0] br_choice; // input to choose the baud rate 
                      // 00 ==> 2400 bps
                      // 01 ==> 4800 bps
                      // 10 ==> 9600 bps
                      // 11 ==> 19,200 bps
      
output tick; // this signaal function as clock to the UART whose rate 16 times the baud rate .

reg [7:0] count; // mod-163 counter to generate the sampling rate which is 16 times the baud rate.
reg tick = 1'b1 ;

always @ (posedge clock , negedge reset)
begin
  if (!reset)  count <= 8'b00000000; // active low reset to initialize the counter to zero at the power up.
  else if (br_choice == 2'b00)
      begin
        if (count == 10'b1010001100)
          begin
          tick = !tick;
          count <= 10'b0000000000;
          end
        else
          count <= count + 1;
      end
  
  else if (br_choice == 2'b01)
      begin
        if (count == 10'b0101000110)
          begin
          tick = !tick;
          count <= 10'b0000000000;
          end
        else
          count <= count + 1;
      end 
      
  else if (br_choice == 2'b10)
      begin
        if (count == 10'b0010100011)
          begin
          tick = !tick;
          count <= 10'b0000000000;
          end
        else
          count <= count + 1;
      end  
      
  else if (br_choice == 2'b11)
      begin
        if (count == 10'b0001010010)
          begin
          tick = !tick;
          count <= 10'b0000000000;
          end
        else
          count <= count + 1;
      end   
    
   
 
end



endmodule

