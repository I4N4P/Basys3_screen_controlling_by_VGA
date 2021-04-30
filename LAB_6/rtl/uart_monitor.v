// File: uart_monitor.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module uart_monitor (
        input wire clk,
        input wire rx, 
        input wire tx, 
        input wire loopback_enable, 
        
        output wire rx_monitor, 
        output wire tx_monitor
        );

endmodule
