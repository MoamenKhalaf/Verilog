
/* --------- UART Receiver ---------- */
// The receiver shifts in data bit by bit and then reassembles the data.
// We use an oversampling scheme to estimate the middle points of transmitted bits 
// and then retrieve them at these points accordingly.
//  The most commonly used sampling rate is 16 times the baud rate, which means that each
// serial bit is sampled 16 times.

module uart_receiver (reset,rx,s_tick,dout,rx_done_tick);
  
input rx, // receive the data bit by bit from the transmiiter of the other system.
      reset, // reset input to initialize all counters in the design.
      s_tick; // The s_tick signal is the enable tick from the baud rate generator 
              // and there are 16 ticks in a bit interval.
output [7:0] dout; // the register in which The received data presented.
output rx_done_tick; // status signal, It is asserted for one clock cycle after
                     // the receiving process is completed. 
       
reg [3:0] sample_count; // 4 bit counter which count the samples.
reg [2:0] bit_count; // 3 bit counter which count the received data.
reg [7:0] r_data; // register in which the retrieved bits are shifted into and reassembled.
reg rx_done_tick;

// states of FSM //
parameter [1:0] idle  = 2'b00,
                start = 2'b01,
                data  = 2'b11,
                stop  = 2'b10;
                
reg [1:0] state;


always@(posedge s_tick or negedge reset)
begin
  if (!reset) // active low reset which initialize all counters and put the design onto the idle state 
    begin
      state <= idle;
      sample_count <= 0;
      bit_count <= 0;
      r_data <= 0;
      rx_done_tick <= 1'b0;
    end
    
  else
    begin
      rx_done_tick <= 1'b0;
    case (state)
      
    idle:
      if (!rx)
        begin
          state <= start;
          sample_count <= 0;
        end
        
    start:
       if (sample_count == 7)
         begin
           state <= data;
           bit_count <= 0;
           sample_count <= 0;
         end
       else
        sample_count <= sample_count + 1;
        
    data:
       if (sample_count == 15)
         begin
           r_data <= {rx,r_data[7:1]};
           sample_count <= 0;
           if (bit_count == 7)
             begin
                state <= stop;
             end
           else
             begin 
               bit_count <= bit_count + 1;
             end
         end
       else
          sample_count <= sample_count + 1; 
    
    stop:
       if (sample_count == 15)
         begin
           state <= idle;
           sample_count <= 0;
           rx_done_tick <= 1'b1;
         end 
       else
         sample_count <= sample_count + 1;
    endcase
    end     
end 


assign dout = r_data;
endmodule


                        

      


