// File: uart_monitor.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module uC (
                input wire clk,
                input wire reset,

                input wire [3:0] sw,
                input wire btPC,
                input wire btEX,
                //input wire uCrst,
                //input wire rx, 
                input wire monRFData_enable, 
                input wire monInstr_enable, 
                input wire monPC_enable, 
                
                // output reg tx, 

                output wire [3:0] an,
                output wire [7:0] seg
        );
        localparam WIDTH          = 16;
        localparam IRAM_ADDR_BITS = 8;

        wire clk_100MHz,clk_50MHz;
        wire rst,locked;

        wire tx_full, rx_empty,tx_w;
        wire [7:0] rec_data;

        wire PCenable,extCtl;
        wire [15:0] monPC,monRFData,monInstr;

        reg [15:0] data,data_nxt = 16'b0;
        reg tick,tick_nxt = 1'b0;
        reg flag,flag_nxt;

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
                .clk (clk_100MHz),
                .locked (locked),

                .reset_out (rst)
        );

        micro #(
                .WIDTH (WIDTH),
                .IRAM_ADDR_BITS(IRAM_ADDR_BITS)
        ) u_micro (
                .clk (clk_100MHz),
                .reset (rst),
                //wire [IRAM_ADDR_BITS-1:0] iram_wa,
                //wire      iram_wen,
                //wire [WIDTH-1:0]   iram_din,
                .PCenable (PCenable),  //program counter enable
                .extCtl (extCtl),      //external program control signal (e.g. button)
                .monRFSrc (sw),  //select register for monitoring
                .monRFData(monRFData), //contents of monitored register
                .monInstr (monInstr),
                .monPC (monPC)
        );

        // uart my_uart 
        // (
        //         .clk (clk_50MHz),
        //         .reset (rst),

        //         .rd_uart (tick),
        //         .wr_uart (btn_tick), 
        //         .rx (rx), 
        //         .w_data (data[7:0]),

        //         .tx_full (tx_full), 
        //         .rx_empty (rx_empty),
        //         .r_data (rec_data), 
        //         .tx (tx_w)
        // );

        debounce PC_Inc_Button
        (
                .clk (clk_100MHz), 
                .reset (rst), 
              
                .sw (btPC),

                .db_level (), 
                .db_tick (PCenable)
        );

        debounce EXCtl_Button
        (
                .clk (clk_100MHz), 
                .reset (rst), 
              
                .sw (btEX),

                .db_level (extCtl), 
                .db_tick ()
        );

        disp_hex_mux reg_data_disp_hex
        ( 
                .clk (clk_100MHz), 
                .reset (rst),

                .hex3 (data[15:12]), 
                .hex2 (data[11:8]), 
                .hex1 (data[7:4]), 
                .hex0 (data[3:0]),
                .dp_in (4'b1111),

                .an (an), 
                .sseg (seg)
        );

        // display and send ASCII synchronical logic

        always @ (posedge clk_100MHz) begin
                if (rst) begin 
                        data <= 8'b0;
                        // tick <= 1'b0;
                        // flag <= 1'b0;
                end else begin
                        data <= data_nxt;
                        // tick <=tick_nxt;
                        // flag <= flag_nxt;
                end      
        end

        // display and send ASCII combinational logic

        always @ * begin
               case ({monRFData_enable,monInstr_enable,monPC_enable}) 
               3'b001: data_nxt = monPC;
               3'b010: data_nxt = monInstr;
               3'b100: data_nxt = monRFData;
               default : data_nxt = 8'b0;
               endcase
                // tick_nxt = 1'b0;
                // if (rx_empty == 0) begin
                //         if (flag)
                //                 data_nxt = {data[7:0],rec_data};
                //         else
                //                 data_nxt = data;
                //         flag_nxt = 1'b0;
                //         tick_nxt = 1'b1;
                // end else begin
                        // flag_nxt = 1'b1;
                        // data_nxt = data;    
                // end 
        end

endmodule
