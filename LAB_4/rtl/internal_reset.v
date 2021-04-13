// File: internal_reset.v
// This is the module design for Lab #3.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module internal_reset (
        input   wire pclk,
        input   wire locked,
        output  reg  reset_out
        );


        always @(negedge pclk or negedge locked) begin
                if(!locked)
                        reset_out <= 1'b1;
                else 
                        reset_out <= 1'b0;
        end

    /*reg  reset_out_nxt;

    reg [10:0] counter=11'b0;
    reg [10:0] counter_nxt;

    always @(posedge pclk)
        begin
            reset_out <=reset_out_nxt;
            counter <= counter_nxt;
        end

    always @(negedge locked)
        begin
            counter_nxt <=11'b0;
            reset_out <=1'b1;
            
        end


    always @*
        begin
            if(counter_nxt > 100)
                begin
                    reset_out_nxt =1'b0;
                    counter_nxt=counter;
                end
            else 
                begin
                    reset_out_nxt =reset_out;
                    counter_nxt=counter+1;
                end

        end */
endmodule
