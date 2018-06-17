
module uart (tx,rx,clock,reset,tx_set,rx_clr,din_tx,dout_rx,rx_empty,br_choice);
  
  input rx,clock,reset,tx_set,rx_clr;
  input [7:0] din_tx;
  input [1:0] br_choice;
  output tx;
  output rx_empty;
  output [7:0] dout_rx;
  
  wire rx,clock,reset,tx_set,rx_clr;
  wire [7:0] din_tx;
  wire [1:0] br_choice;
  wire tx;
  wire [7:0] dout_rx;
  
  wire s_tick,rx_set,tx_clr,tx_start;
  wire [7:0] rx_data;
  wire [7:0] tx_data;

BRG br (clock,reset,s_tick,br_choice);  
uart_transmitter tx1 (reset,tx,s_tick,tx_clr,tx_start,tx_data);
buffer_tx b1 (tx_set,tx_clr,reset,clock,din_tx,tx_data,tx_start);
uart_receiver rx1 (reset,rx,s_tick,rx_data,rx_set);
buffer_rx b2 (rx_set,rx_clr,reset,clock,rx_data,dout_rx,rx_empty);

endmodule

  
