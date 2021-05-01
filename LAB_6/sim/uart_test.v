//Listing 8.5
module uart_test
   (
    input wire clk, reset,
    input wire rx,
    input wire btn,
    output wire tx,
    output wire [3:0] an,
    output wire [7:0] seg, led
   );

wire clk_100MHz,clk_50MHz;
  gen_clock my_gen_clock
  (
  // Clock out ports  
  .clk_100MHz(clk_100MHz),
  .clk_50MHz(clk_50MHz),
  // Status and control signals               
  .reset(), 
  .locked(),
 // Clock in ports
  .clk(clk)
  );


   // signal declaration
   
   wire tx_full, rx_empty, btn_tick;
   wire [7:0] rec_data, rec_data1;

        //reg [7:0] data = 32 ;
   // body
   // instantiate uart
   uart uart_unit
      (.clk(clk_50MHz), .reset(reset), .rd_uart(btn_tick),
       .wr_uart(btn_tick), .rx(rx), .w_data(rec_data1),
       .tx_full(tx_full), .rx_empty(rx_empty),
       .r_data(rec_data), .tx(tx));
   // instantiate debounce circuit
   debounce btn_db_unit
      (.clk(clk_50MHz), .reset(reset), .sw(btn),
       .db_level(), .db_tick(btn_tick));
   // incremented data loops back
   assign rec_data1 = rec_data + 1;
   // LED display
   assign led = rec_data;
   assign an = 4'b1110;
   assign seg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};

endmodule
