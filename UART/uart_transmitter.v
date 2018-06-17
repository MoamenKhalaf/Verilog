
/* ------------ uart transmitter ------------------*/

module uart_transmitter (reset,tx,s_tick,tx_done_tick,tx_start,din);
  
input s_tick, // function as clock for the transmitter.
      reset,
      tx_start; // works as enable which is assertted when there new data.
input [7:0] din; // 8 bits input data.

output tx, // output bit which shiftted bit by bit.
       tx_done_tick; // flag which is assertted when the transsmision is done.
       
reg tx , tx_done_tick;

reg [3:0] sample_count; // 4 bit counter as the transmitter slower than receiver 16 times.
reg [3:0] bit_count; // 4 bit counter which count the transmitted bits.
reg [7:0] data_in = 8'b00000000; // register in which load the 8 bit input data.
// states of the FSM // 
parameter [1:0] idle = 2'b00,
                start = 2'b01,
                data = 2'b11,
                stop = 2'b10;

reg [1:0] state;

always@(posedge s_tick or negedge reset)
begin
  if (!reset)
    begin
      state <= idle;
      sample_count <= 0;
      bit_count <= 0;
      tx_done_tick <= 0;
      tx <= 1;
    end 
  else
    begin
      tx_done_tick <= 0;
      case (state)
        idle:
            begin
              tx <= 1;
              if (tx_start)
                begin
                  state <= start;
                  sample_count<= 0;
                  data_in <= din;
                end
            end
        
        start:
             begin
                   if (sample_count == 4'b1111)
                     begin
                       tx <= 0;
                       state <= data;
                       sample_count <= 0;
                     end
                   else
                     sample_count <= sample_count + 1;
             end
             
        data:
             begin
                   if (sample_count == 4'b1111)
                     begin
                       tx <= data_in[0];
                       data_in <= {1'b1 , data_in[7:1]};
                       sample_count <= 0;
                       if (bit_count == 4'b1000)
                         begin
                           state <= stop;
                           bit_count <= 0;
                         end
                       else
                         bit_count <= bit_count + 1;
                     end
                   else
                     sample_count <= sample_count + 1;
             end  
        
        stop:
            begin
              if (sample_count == 4'b1111)
                begin
                  tx <= 1'b1;
                  tx_done_tick <= 1'b1;
                  state <= idle;
                end
              else
                sample_count <= sample_count + 1;
            end  
        endcase
    
    end
end

endmodule


