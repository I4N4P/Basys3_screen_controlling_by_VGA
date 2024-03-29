// File: vga_example.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,

  inout wire ps2_clk, 
  inout wire ps2_data,

  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire pclk_mirror

  );


  wire clk100MHz;
  wire pclk;
  wire locked;
  wire reset;

  wire [11:0]xpos,ypos,xpos_mem,ypos_mem;

  wire [3:0] red_out,green_out,blue_out;

  wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out, hcount_out;  // here is the change of the size of variable in order to mould with MouseDisplay
  wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out, hsync_out;
  wire vblnk, hblnk,vblnk_out_b, hblnk_out_b,vblnk_out, hblnk_out;
  wire [11:0] rgb_out_b,rgb_out;

  wire blank;
  
  reg vsync_out_M, hsync_out_M;

 /*Converts 100 MHz clk into 40 MHz pclk.
  *his uses a vendor specific primitive
  *called MMCME2, for frequency synthesis.
  *wire clk_in;
  *wire locked;
  *wire clk_fb;
  *wire clk_ss;
  *wire clk_out;
  *
  *(* KEEP = "TRUE" *) 
  *(* ASYNC_REG = "TRUE" *)
  *reg [7:0] safe_start = 0;
  *
  *IBUF clk_ibuf (.I(clk),.O(clk_in));
  *
  *MMCME2_BASE #(
  *  .CLKIN1_PERIOD(10.000),
  *  .CLKFBOUT_MULT_F(10.000),
  *  .CLKOUT0_DIVIDE_F(25.000))
  *clk_in_mmcme2 (
  *  .CLKIN1(clk_in),
  *  .CLKOUT0(clk_out),
  *  .CLKOUT0B(),
  *  .CLKOUT1(),
  *  .CLKOUT1B(),
  *  .CLKOUT2(),
  *  .CLKOUT2B(),
  *  .CLKOUT3(),
  *  .CLKOUT3B(),
  *  .CLKOUT4(),
  *  .CLKOUT5(),
  *  .CLKOUT6(),
  *  .CLKFBOUT(clkfb),
  *  .CLKFBOUTB(),
  *  .CLKFBIN(clkfb),
  *  .LOCKED(locked),
  *  .PWRDWN(1'b0),
  *  .RST(1'b0)
  *);
  *
  *BUFH clk_out_bufh (.I(clk_out),.O(clk_ss));
  *always @(posedge clk_ss) safe_start<= {safe_start[6:0],locked}; 
  *
  *BUFGCE clk_out_bufgce (.I(clk_out),.CE(safe_start[7]),.O(pclk));
  */ 
    
  clk_generator my_clk_generator(
    .clk(clk),
    .clk100MHz(clk100MHz),
    .clk40MHz(pclk),
    .reset(rst),
    .locked(locked)
  );
  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

  internal_reset my_internal_reset(
    .pclk(pclk),
    .locked(locked),
    .reset_out(reset)
  );
  MouseCtl my_MouseCtl(
    .clk(clk100MHz),
    .rst(reset),
    
    .value(12'b0),
    .setx(1'b0),
    .sety(1'b0),
    .setmax_x(1'b0),
    .setmax_y(1'b0),
    .ps2_clk(ps2_clk), 
    .ps2_data(ps2_data),
    .xpos(xpos),
    .ypos(ypos)
  );

  position_memory my_position_memory(
    .pclk(pclk),
    .rst(reset),

    .xpos_in(xpos),
    .ypos_in(ypos),
    .xpos_out(xpos_mem),
    .ypos_out(ypos_mem)
  
  );
  
  // Instantiate the vga_timing module

  vga_timing my_timing (
    .pclk(pclk),
    .rst(reset),
    
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk)
  );

  draw_background my_draw_background (
    .pclk(pclk),
    .rst(reset),

    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),

    .vcount_out(vcount_out_b),
    .vsync_out(vsync_out_b),
    .vblnk_out(vblnk_out_b),
    .hcount_out(hcount_out_b),
    .hsync_out(hsync_out_b),
    .hblnk_out(hblnk_out_b),
    .rgb_out(rgb_out_b)
  );
  draw_rect my_draw_rect (
    .pclk(pclk),
    .rst(reset),

    .xpos(xpos_mem),
    .ypos(ypos_mem),

    .vcount_in(vcount_out_b),
    .vsync_in(vsync_out_b),
    .vblnk_in(vblnk_out_b),
    .hcount_in(hcount_out_b),
    .hsync_in(hsync_out_b),
    .hblnk_in(hblnk_out_b),
    .rgb_in(rgb_out_b),
    
    .vcount_out(vcount_out),
    .vsync_out(vsync_out),
    .vblnk_out(vblnk_out),
    .hcount_out(hcount_out),
    .hsync_out(hsync_out),
    .hblnk_out(hblnk_out),
    .rgb_out(rgb_out)
  );

MouseDisplay my_MouseDisplay(
    .pixel_clk(pclk),
    .xpos(xpos_mem),
    .ypos(ypos_mem),

    .vcount(vcount_out),
    .blank(blank),
    .hcount(hcount_out),

    .red_in(rgb_out[11:8]),
    .green_in(rgb_out[7:4]),
    .blue_in(rgb_out[3:0]),

    .red_out(red_out),
    .green_out(green_out),
    .blue_out(blue_out)

  ); 

    // Synchronical logic
  always @(posedge pclk)
    begin
      // signal is delayed since MouseDisplay exist and tiff sim does not work well.
      hsync_out_M <= hsync_out;
      vsync_out_M <= vsync_out;
      
      // Just pass these through.
      hs <= hsync_out_M;
      vs <= vsync_out_M;

      r  <= red_out;
      g  <= green_out;
      b  <= blue_out;
    end

    assign blank=vblnk_out||hblnk_out;
endmodule
