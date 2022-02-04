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
                input wire rx, 
                input wire monRFData_enable, 
                input wire monInstr_enable, 
                input wire monPC_enable, 
                input wire PCenable_auto, 
                
                output wire tx, 
                output wire led, 

                output wire [3:0] an,
                output wire [7:0] seg
        );
        localparam WIDTH          = 16;
        localparam IRAM_ADDR_BITS = 8;
        localparam COUNT = 10 ;

        integer i;

        wire clk_100MHz,clk_50MHz;
        wire rst,locked;

        wire tx_full, rx_empty;
        wire [7:0] rec_data;

        wire PCenable_nxt,extCtl;
        wire [15:0] monPC,monRFData,monInstr;

        reg PCenable;

        reg [3:0] counter,counter_nxt;
        reg [1:0] flag,flag_nxt;

        reg [15:0] reg_out_data,reg_out_data_nxt = 16'b0;
        reg [15:0] uart_data[0:31],uart_data_nxt[0:31];
        reg tick,tick_nxt = 1'b0;

        reg [4:0] iterator,iterator_nxt;
        reg [4:0] iterator2,iterator_nxt2 = 16'b0;
        reg enable_flash,enable_flash_nxt = 1'b0;
        reg [7:0] flash_adr,flash_adr_nxt = 8'b0;

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

        uart my_uart 
        (
                .clk (clk_50MHz),
                .reset (rst),

                .rd_uart (tick),
                .wr_uart (tick), 
                .rx (rx), 
                .w_data (8'b0),

                .tx_full (tx_full), 
                .rx_empty (rx_empty),
                .r_data (rec_data), 
                .tx (tx)
        );

        micro #(
                .WIDTH (WIDTH),
                .IRAM_ADDR_BITS(IRAM_ADDR_BITS)
        ) u_micro (
                .clk (clk_100MHz),
                .reset (rst),
                .iram_wa (flash_adr),
                .iram_wen (enable_flash),
                .iram_din (uart_data[iterator2]),
                .PCenable (PCenable),  //program counter enable
                .extCtl (extCtl),      //external program control signal (e.g. button)
                .monRFSrc (sw),  //select register for monitoring
                .monRFData(monRFData), //contents of monitored register
                .monInstr (monInstr),
                .monPC (monPC)
        );

        debounce PC_Inc_Button
        (
                .clk (clk_100MHz), 
                .reset (rst), 

                .sw (btPC),

                .db_level (), 
                .db_tick (PCenable_nxt)
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

                .hex3 (reg_out_data[15:12]), 
                .hex2 (reg_out_data[11:8]), 
                .hex1 (reg_out_data[7:4]), 
                .hex0 (reg_out_data[3:0]),
                .dp_in (4'b1111),

                .an (an), 
                .sseg (seg)
        );

        always @ (posedge clk_100MHz) begin
                if (PCenable_auto)
                        PCenable <= 1'b1 ;
                else
                        PCenable <= PCenable_nxt;
                
        end

        always @ (posedge clk_100MHz) begin
                if (rst) begin 
                        reg_out_data <= 8'b0;
                        for (i = 0; i < 32; i = i + 1)
                                uart_data[i] <= 16'b0;
                        tick <= 1'b0;
                        counter <= 4'b0;
                        flag  <= 1'b0;
                        iterator <= 5'b0;
                        iterator2 <= 5'b0;
                        enable_flash <= 1'b0;
                        flash_adr <= 8'b0;
                end else begin
                        reg_out_data <= reg_out_data_nxt;
                        uart_data[iterator] <= uart_data_nxt[iterator];
                        tick <=tick_nxt;
                        counter <= counter_nxt;
                        flag  <= flag_nxt;
                        iterator <= iterator_nxt;
                        enable_flash <= enable_flash_nxt;
                        iterator2 <= iterator_nxt2;
                        flash_adr <= flash_adr_nxt;
                end      
        end

                // copy data from uart to immem          
        always @ * begin
                iterator_nxt = iterator;
                flag_nxt = flag;
                tick_nxt = 1'b0;
                enable_flash_nxt = enable_flash;
                counter_nxt = counter;
                flash_adr_nxt = flash_adr;
                iterator_nxt2 = iterator2;
                for (i = 0; i < 32; i = i + 1)
                        uart_data_nxt[i] = uart_data[i];
                if (rx_empty == 0) begin
                        if (counter == COUNT) begin
                                // uart_data_nxt[iterator] = uart_data[iterator];
                                counter_nxt = 0;
                                tick_nxt = 1'b1;
                                if(flag == 1) begin
                                        uart_data_nxt[iterator] = {uart_data[iterator][7:0],rec_data};
                                        iterator_nxt = iterator + 1;
                                        flag_nxt = 2'b0;
                                end else begin
                                        iterator_nxt = iterator;
                                        flag_nxt = flag + 1;
                                        uart_data_nxt[iterator] = {uart_data[iterator][7:0],rec_data};
                                end
                        end else begin
                                uart_data_nxt[iterator] = uart_data[iterator];
                                counter_nxt = counter + 1;
                        end
                end else if ((rx_empty == 1) && (iterator == 25) && (iterator2 <= 25) ) begin   // i am aware about some problems connected with this, yet this is not a commercial project
                        enable_flash_nxt <= 1'b1;
                        if(enable_flash) begin
                                flash_adr_nxt = flash_adr + 1;
                                iterator_nxt2 = iterator2 + 1;
                        end else begin
                                flash_adr_nxt = flash_adr;
                                iterator_nxt2 = iterator2;
                        end
                end else begin
                        uart_data_nxt[iterator] = uart_data[iterator];
                        counter_nxt = 4'b0;
                end 
        end

                // dispaly data on LCD          
        always @ * begin
               case ({monRFData_enable,monInstr_enable,monPC_enable}) 
               3'b001:  reg_out_data_nxt = monPC;
               3'b010:  reg_out_data_nxt = monInstr;
               3'b100:  reg_out_data_nxt = monRFData;
               default: reg_out_data_nxt = 8'b0;
               endcase
        end
        assign led = monRFData[0];
endmodule
