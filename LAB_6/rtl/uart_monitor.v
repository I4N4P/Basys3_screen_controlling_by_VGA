// File: uart_monitor.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module uart_monitor (
        input wire clk,
        input wire reset,

        //input wire btn,
        input wire rx, 
        input wire loopback_enable, 
        
        output reg tx, 
        output reg rx_monitor, 
        output reg tx_monitor
        );

        wire clk_100MHz,clk_50MHz;
        wire rst,locked;

        gen_clock my_gen_clock 
        (
                .clk (clk),
                .reset (reset),

                .clk_100MHz (clk_100MHz),
                .clk_50MHz (clk_50MHz),            
                .locked (locked)
        );

        internal_reset my_internal_reset 
        (
                .clk   (clk_50MHz),
                .locked (locked),
                .reset_out (rst)
        );


//         wire tx_full, rx_empty, btn_tick;
//         wire [7:0] rec_data, rec_data1;

//         uart uart_unit 
//         (
//                 .clk (clk_50MHz),
//                 .reset (rst),

//                 .rd_uart (btn_tick),
//                 .wr_uart (btn_tick), 
//                 .rx (rx), 
//                 .w_data (rec_data1),
//                 .tx_full (tx_full), 
//                 .rx_empty (rx_empty),
//                 .r_data (rec_data), 
//                 .tx (tx)
//         );


//            debounce btn_db_unit
//       (.clk(clk_50MHz), .reset(reset), .sw(btn),
//        .db_level(), .db_tick(btn_tick));
//         // incremented data loops back
//         assign rec_data1 = rec_data + 1;

        always @ (posedge clk_100MHz) begin
                if (rst) begin 
                        rx_monitor <= 1'b0;
                        tx_monitor <= 1'b0;
                        tx         <= 1'b0;
                end else begin
                        if (loopback_enable)
                                tx <= rx;
                        else
                                tx <= 0;
                        rx_monitor <= rx;
                        tx_monitor <= tx;    
                        
                end      
        end


endmodule
