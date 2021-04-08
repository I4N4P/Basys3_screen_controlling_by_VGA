// File: draw_rect.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_ctl (
  input   wire pclk,
  input   wire rst,

  input   wire[11:0] mouse_xpos,
  input   wire[11:0] mouse_ypos,
  input   wire mouse_left, 

  output  reg [11:0] xpos,
  output  reg [11:0] ypos

  );

  localparam IDDLE       = 0'b00;
  localparam RESET       = 0'b01;
  localparam MOUSE_DOWN  = 0'b10;
  localparam MOUSE_UP    = 0'b11;
  
 reg[20:0] ADD = 1;
  

 reg[1:0] state,state_nxt;

 reg [29:0] freq_div = 0,freq_div_nxt = 0;
 reg [11:0] ypos_tmp = 0,xpos_tmp = 0;
 reg [29:0] xpos_mach = 0,ypos_mach = 0,xpos_mach_nxt = 0,ypos_mach_nxt = 0;
  
  // state register
  
 always @(posedge pclk) 
        begin
                if(rst)
                        state <= RESET;
                else begin
                        state <= state_nxt;
                        ypos  <= ypos_tmp[11:0];
                        xpos  <= xpos_tmp[11:0];

                        xpos_mach <= xpos_mach_nxt[11:0];
                        ypos_mach <= ypos_mach_nxt[11:0];
                        freq_div  <= freq_div_nxt;
                end
        end
  // next state logic
 always @(state or rst or mouse_left) 
        begin
                case(state)
                        IDDLE :         state_nxt = mouse_left ? MOUSE_DOWN : MOUSE_UP;
                        RESET :         state_nxt = rst ? RESET : IDDLE;
                        MOUSE_DOWN :    state_nxt = mouse_left ? MOUSE_DOWN : IDDLE;
                        MOUSE_UP :      state_nxt = mouse_left ? IDDLE : MOUSE_UP;
                        default :       state_nxt = IDDLE;
                endcase
        end 
  // output logic      
 always @* 
        begin

                ADD = ADD;
                xpos_tmp  = xpos_tmp;
                ypos_tmp  = ypos_tmp;

                case(state)
                        RESET :         
                                begin
                                      xpos_tmp  = 12'b0;
                                      ypos_tmp  = 12'b0;  
                                end
                        MOUSE_DOWN :    
                                begin
                                        if(freq_div == 4_000_000) begin
                                                if (xpos_tmp == 752) 
                                                        ADD = -1;
                                                else if (xpos_tmp == 0)
                                                        ADD = 1;
                                                else 
                                                        ADD = ADD;
                                                xpos_mach_nxt = xpos_mach + ADD; 
                                                ypos_mach_nxt = (((284 * xpos_mach) / 100) - ((378*(xpos_mach * xpos_mach)) / 100_000));
                                                freq_div_nxt = 0;
                                        end else begin
                                                xpos_tmp  = xpos_mach[11:0];
                                                ypos_tmp  = ypos_mach[11:0];
                                                freq_div_nxt = freq_div+1;
                                        end
                                end
                        MOUSE_UP :      
                                begin
                                      xpos_tmp  = mouse_xpos;
                                      ypos_tmp  = mouse_ypos;  
                                end
                        default : 
                                begin
                                      xpos_tmp  = mouse_xpos;
                                      ypos_tmp  = mouse_ypos;  
                                end
                endcase    
        end



endmodule
