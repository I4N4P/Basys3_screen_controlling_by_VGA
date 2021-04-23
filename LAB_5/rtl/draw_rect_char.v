// File: draw_rect.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_char (
        input   wire pclk,
        input   wire rst,

        input   wire [11:0] vcount_in,
        input   wire vsync_in, 
        input   wire vblnk_in, 
        input   wire [11:0] hcount_in,
        input   wire hsync_in, 
        input   wire hblnk_in, 
        input   wire [11:0] rgb_in,
        input   wire [7:0] char_pixel,

        output  reg [11:0] vcount_out,
        output  reg vsync_out, 
        output  reg vblnk_out, 
        output  reg [11:0] hcount_out,
        output  reg hsync_out, 
        output  reg hblnk_out, 
        output  reg [11:0] rgb_out,
        output  reg [10:0] char_addr
        );

        // This are the parameters of the rectangle.

        localparam RECT_HEIGHT = 64;
        localparam RECT_WIDTH = 48;
        
        reg [11:0] rgb_nxt = 12'b0;
        reg [10:0] pixel_addr_nxt = 12'b0;
        

        wire [11:0] vcount_out_s2,hcount_out_s2; 
        wire vsync_out_s2, hsync_out_s2;
        wire vblnk_out_s2, hblnk_out_s2;
        wire [11:0] rgb_out_s2;

        delay #(
                .WIDTH (28),
                .CLK_DEL(2)
        ) timing_delay (
                .clk (pclk),
                .rst (rst),
                .din ( {hcount_in, hsync_in, hblnk_in, vcount_in, vsync_in, vblnk_in}),
                .dout ({hcount_out_s2, hsync_out_s2, hblnk_out_s2, vcount_out_s2, vsync_out_s2, vblnk_out_s2})
        );

        delay #(
                .WIDTH (12),
                .CLK_DEL(2)
        ) rgb_delay (
                .clk (pclk),
                .rst (rst),
                .din (rgb_in),
                .dout (rgb_out_s2)
        );


        // Synchronical logic
        
        always @(posedge pclk) 
        begin
        // pass these through if rst not activ then put 0 on the output.
        if (rst) 
        begin
                vcount_out <= 12'b0;
                hcount_out <= 12'b0;
                vsync_out  <= 1'b0;
                vblnk_out  <= 1'b0; 
                hsync_out  <= 1'b0;
                hblnk_out  <= 1'b0; 
                rgb_out    <= 12'h0_0_0;
                char_addr  <= 12'h0_0_0;

        end
        else 
        begin
                vcount_out <= vcount_out_s2;
                hcount_out <= hcount_out_s2;

                vsync_out  <= vsync_out_s2;
                hsync_out  <= hsync_out_s2;
                
                vblnk_out  <= vblnk_out_s2; 
                hblnk_out  <= hblnk_out_s2;
                rgb_out    <= rgb_nxt;
                
                char_addr  <= pixel_addr_nxt;

        end
        end
        // Combinational logic
        always @* begin
                // rectangle generator
                if (hblnk_out_s2 || vblnk_out_s2) begin
                        rgb_nxt = rgb_out_s2;
                end else begin
                        //if (hcount_out_s2 >= xpos && hcount_out_s2 < xpos + RECT_WIDTH && vcount_out_s2 >= ypos && vcount_out_s2 < ypos + RECT_HEIGHT)
                        rgb_nxt = rgb_out_s2; 
                        //else 
                        //rgb_nxt = rgb_out_s2;  
                end
                pixel_addr_nxt = {hcount_in[9:3], hcount_in[3:0]};
        end
endmodule
