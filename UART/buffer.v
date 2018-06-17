
/* ---------- interface circuit ----------- */
/* ----------  one word buffer  ----------- */
/* the receiver's interface circuit has two functions. First, it provides a mechanism to signal the
availability of a new word and to prevent the received word from being retrieved multiple
times. Second, it can provide buffer space between the receiver and the main system. */


module buffer_rx (set_flag,clear_flag,reset,clock,data,out_data,rx_empty);
  
input set_flag, // sets the flag to 1 which means there is new word.
      clear_flag, // clears the flag to 0 after the main system receive the word.
      clock, // main system clock which is 50 MHz.
      reset;
input [7:0] data; // the received data from the remote system which stored in the buffer.
  
output [7:0] out_data; // the buffer which store the data until the main system receive it.
output rx_empty; // indicates that no new word is available.
       
reg [7:0] out_data;
reg rx_empty;

always@(posedge clock or negedge reset)
begin
  if (!reset)
    begin
      out_data <= 0;
      rx_empty <= 1;
    end
    
  else
    begin
      if (clear_flag)
        begin
          out_data <= 0;
          rx_empty <= 1;
        end
      else if (set_flag)
        begin
          out_data <= data;
          rx_empty <= 0;
        end
    end
      
end
endmodule