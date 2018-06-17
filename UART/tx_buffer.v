
/* ---------- interface circuit ----------- */
/* ----------  one word buffer  ----------- */

module buffer_tx (set_flag,clear_flag,reset,clock,data,out_data,tx_start);
  
input set_flag, // sets the flag to 1 which means there is new word.
      clear_flag, // clears the flag to 0 after the transmission end.
      clock, // main system clock which is 50 MHz.
      reset;
input [7:0] data; // the data to transmit
  
output [7:0] out_data; // the buffer which store the data until the transmission end
output tx_start; // indicates that no new word is available.
       
reg [7:0] out_data;
reg tx_start;

always@(posedge clock or negedge reset)
begin
  if (!reset)
    begin
      out_data <= 8'b11111111;
      tx_start <= 0;
    end
    
  else
    begin
      if (clear_flag)
        begin
          out_data <= 8'b11111111;
          tx_start <= 0;
        end
      else if (set_flag)
        begin
          out_data <= data;
          tx_start <= 1;
        end
    end
      
end
endmodule
