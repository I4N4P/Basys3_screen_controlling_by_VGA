// File: draw_rect.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect (
  input   wire pclk,
  input   wire rst,

  input   wire [10:0] vcount_in,
  input   wire vsync_in, 
  input   wire vblnk_in, 
  input   wire [10:0] hcount_in,
  input   wire hsync_in, 
  input   wire hblnk_in, 
  input   wire [11:0] rgb_in,

  output  reg [10:0] vcount_out,
  output  reg vsync_out, 
  output  reg vblnk_out, 
  output  reg [10:0] hcount_out,
  output  reg hsync_out, 
  output  reg hblnk_out, 
  output  reg [11:0] rgb_out
  );

  // This are the parameters of the rectangle.

  localparam RECT_X_POSITION = 30;
  localparam RECT_Y_POSITION = 30;
  localparam RECT_HEIGHT = 100;
  localparam RECT_WIDTH = 200;
  localparam RECT_COLOR = 12'h4_4_4;;
  
  reg [11:0] rgb_nxt;

  // Synchronical logic
  
  always @(posedge pclk) 
  begin
    // pass these through if rst not activ then put 0 on the output.
    if (rst) 
      begin
        vcount_out <= 11'b0;
        hcount_out <= 11'b0;
        vsync_out  <= 1'b0;
        vblnk_out  <= 1'b0; 
        hsync_out  <= 1'b0;
        hblnk_out  <= 1'b0; 
        rgb_out    <= 12'h0_0_0;
      end
    else 
      begin
        vcount_out <= vcount_in;
        hcount_out <= hcount_in;
        vsync_out  <= vsync_in;
        vblnk_out  <= vblnk_in; 
        hsync_out  <= hsync_in;
        hblnk_out  <= hblnk_in;
        rgb_out    <= rgb_nxt;
      end
 end
  // Combinational logic
always @*
  begin
    if (hcount_in>=RECT_X_POSITION && vcount_in>=RECT_Y_POSITION 
        && hcount_in<=RECT_WIDTH+RECT_X_POSITION && vcount_in<=RECT_HEIGHT+RECT_Y_POSITION) 

        rgb_nxt=RECT_COLOR;
    else
        rgb_nxt=rgb_in;
  end

endmodule
