// File: vga_example.v
// This is the top level design for EE178 Lab #2.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire pclk_mirror

  );

  // Converts 100 MHz clk into 40 MHz pclk.
  // This uses a vendor specific primitive
  // called MMCME2, for frequency synthesis.
  wire clk100MHz;
  wire pclk;
  wire locked;
  wire reset;
/*  wire clk_in;
  wire locked;
  wire clk_fb;
  wire clk_ss;
  wire clk_out;
  
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg [7:0] safe_start = 0;

  IBUF clk_ibuf (.I(clk),.O(clk_in));

  MMCME2_BASE #(
    .CLKIN1_PERIOD(10.000),
    .CLKFBOUT_MULT_F(10.000),
    .CLKOUT0_DIVIDE_F(25.000))
  clk_in_mmcme2 (
    .CLKIN1(clk_in),
    .CLKOUT0(clk_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(clkfb),
    .CLKFBOUTB(),
    .CLKFBIN(clkfb),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(1'b0)
  );

  BUFH clk_out_bufh (.I(clk_out),.O(clk_ss));
  always @(posedge clk_ss) safe_start<= {safe_start[6:0],locked}; 

  BUFGCE clk_out_bufgce (.I(clk_out),.CE(safe_start[7]),.O(pclk));
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
  // Instantiate the vga_timing module

  wire [10:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out, hcount_out;
  wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out, hsync_out;
  wire vblnk, hblnk,vblnk_out_b, hblnk_out_b,vblnk_out, hblnk_out;
  wire [11:0] rgb_out_b,rgb_out;

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
    // Synchronical logic
  always @(posedge pclk)
    begin
      // Just pass these through.
      hs <= hsync_out;
      vs <= vsync_out;
      r  <= rgb_out[11:8];
      g  <= rgb_out[7:4];
      b  <= rgb_out[3:0];
    end
  //always @(posedge locked) begin
  //  reset <= 1'b1;
  //end
endmodule
