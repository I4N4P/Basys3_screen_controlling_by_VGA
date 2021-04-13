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

        localparam PASS_THROUGH    = 2'b00;
        localparam RESET           = 2'b01;
        localparam DRAW_RECT_LEFT  = 2'b10;
        localparam DRAW_RECT_RIGHT = 2'b11;
        
        reg forward,forward_nxt = 1'b1;

        reg[1:0] state,state_nxt;

        reg [29:0] freq_div = 0,freq_div_nxt = 0;
        reg [11:0] ypos_tmp = 0,xpos_tmp = 0;
        reg [11:0] xpos_mach = 0,ypos_mach = 0,xpos_mach_nxt = 0,ypos_mach_nxt = 0;
        
        // state register
        
        always @(posedge pclk) begin
                 if(rst)
                        state <= RESET;
                else
                        state <= state_nxt;        
        end

        // next state logic

        always @(state or rst or mouse_left or forward) begin
                case(state)
                RESET :         
                        if(rst)
                                state_nxt = RESET;
                        else if (mouse_left)
                                state_nxt = forward ? DRAW_RECT_RIGHT : DRAW_RECT_LEFT;
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_LEFT :    
                        if(mouse_left)
                                state_nxt = forward ? DRAW_RECT_RIGHT : DRAW_RECT_LEFT;
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_RIGHT :    
                        if(mouse_left)
                                state_nxt = forward ? DRAW_RECT_RIGHT : DRAW_RECT_LEFT;
                        else
                                state_nxt = PASS_THROUGH;
                PASS_THROUGH :  
                        if(mouse_left)
                                state_nxt = forward ? DRAW_RECT_RIGHT : DRAW_RECT_LEFT;
                        else
                                state_nxt = PASS_THROUGH;
                default :       state_nxt = PASS_THROUGH;
                endcase

        end  

        // output sequential logic 
  
        always @(posedge pclk) begin
                ypos       <= ypos_tmp[11:0];
                xpos       <= xpos_tmp[11:0];
                xpos_mach  <= xpos_mach_nxt;
                ypos_mach  <= ypos_mach_nxt;
                freq_div   <= freq_div_nxt;
                forward    <= forward_nxt;  
        end

        // output combinational logic

        always @* begin

                xpos_mach_nxt   = xpos_mach;
                ypos_mach_nxt   = ypos_mach;
                forward_nxt     = forward;
                ypos_tmp        = ypos_mach[11:0];
                xpos_tmp        = xpos_mach[11:0];
                freq_div_nxt    = freq_div; 

                case (state) 
                RESET : begin         
                        xpos_tmp      = 12'b0;
                        ypos_tmp      = 12'b0;
                        xpos_mach_nxt = 30'b0;
                        ypos_mach_nxt = 30'b0;
                        forward_nxt   = 1'b1;
                        freq_div_nxt  = 30'b0;  
                end
                DRAW_RECT_RIGHT : begin
                        if (xpos_tmp == 752) 
                               forward_nxt = 1'b0;
                       else 
                               forward_nxt = forward;    

                        if(freq_div == 1_000_000) begin 
                                xpos_mach_nxt = xpos_mach + 1;
                                ypos_mach_nxt = (((284 * xpos_mach) / 100) - ((378*(xpos_mach * xpos_mach)) / 100_000));
                                freq_div_nxt = 0;
                        end else begin
                                xpos_tmp  = xpos_mach[11:0];
                                ypos_tmp  = ypos_mach[11:0];
                                freq_div_nxt = freq_div + 1;
                        end        
                end
                DRAW_RECT_LEFT : begin
                        if (xpos_tmp == 0) 
                               forward_nxt = 1'b1;
                       else 
                               forward_nxt = forward;  

                        if(freq_div == 1_000_000) begin 
                                xpos_mach_nxt = xpos_mach - 1;
                                ypos_mach_nxt = (((284 * xpos_mach) / 100) - ((378*(xpos_mach * xpos_mach)) / 100_000));
                                freq_div_nxt = 0;
                        end else begin
                                xpos_tmp  = xpos_mach[11:0];
                                ypos_tmp  = ypos_mach[11:0];
                                freq_div_nxt = freq_div + 1;
                        end        
                end
                PASS_THROUGH : begin     
                        xpos_tmp  = mouse_xpos;
                        ypos_tmp  = mouse_ypos;
                end  
                default : begin
                        xpos_tmp  = mouse_xpos;
                        ypos_tmp  = mouse_ypos;
                end
                endcase    
        end
endmodule
