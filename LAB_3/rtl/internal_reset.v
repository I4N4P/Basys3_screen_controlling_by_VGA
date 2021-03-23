// File: internal_reset.v
// This is the top level design for EE178 Lab #2.

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

    always @(negedge pclk or negedge locked)
        begin
            if(!locked)
                reset_out <= 1'b1;
            else
                reset_out <= 1'b0;
        end

endmodule

