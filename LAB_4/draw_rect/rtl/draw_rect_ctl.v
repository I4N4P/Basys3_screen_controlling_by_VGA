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

  localparam S1 = 2.0**-9.0;
  localparam S2 = 2.0**-10.0;
  localparam S3 = 2.0**-11.0;
  localparam S4 = 2.0**-12.0;
  localparam S5 = 2.0**-13.0;
  localparam SF = (-1)*(S1+S2+S3+S4+S5);
  
  localparam S6 = 2.0**-1.0;
  localparam S7 = 2.0**-2.0;
  localparam S8 = 2.0**-4.0;
  localparam S9 = 2.0**-5.0;
  localparam S10 = 2.0;
  localparam SF2 = S6+S7+S8+S9+S10;
  
  
  
 reg[20:0] ADD = 1;
  

 reg[1:0] state,state_nxt;

 reg [11:0] xpos_nxt = 0,ypos_nxt = 0;
 reg [20:0] ypos_tmp = 0,xpos_tmp = 0;
 reg mouse_left_nxt = 0;
  
  // state register
  
 always @(posedge pclk) 
        begin
                if(rst)
                        state <= RESET;
                else
                        state <= state_nxt;
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
                //xpos  = xpos_nxt;
                //ypos  = ypos_nxt; 

                case(state)
                        RESET :         
                                begin
                                      xpos  = 12'b0;
                                      ypos  = 12'b0;  
                                end
                        MOUSE_DOWN :    
                                begin
                                        if (xpos_tmp == 752) 
                                                ADD = -1;//{1'b1,ADD[19:0]};
                                        else if (xpos_tmp == 0)
                                                ADD = 1;//{1'b0,ADD[19:0]};
                                        xpos_tmp  = xpos+ADD; 
                                        xpos      = xpos_tmp[11:0];
                                        ypos_tmp  = (SF)*(xpos_tmp*xpos_tmp) + (SF2*(xpos_tmp));
                                        ypos      = ypos_tmp[11:0];
                                end
                        MOUSE_UP :      
                                begin
                                      xpos  = mouse_xpos;
                                      ypos  = mouse_ypos;  
                                end
                        default : 
                                begin
                                      xpos  = mouse_xpos;
                                      ypos  = mouse_ypos;  
                                end
                endcase    
        end



endmodule
