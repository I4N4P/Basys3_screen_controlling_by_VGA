# Basys3_Screen_controlling_by_VGA

In this repository there are directories containing solutions to the problems we were supposed to face during the UEC_2 class.

# In order to run vivado from console
open src catalog in powershell and put:

vivado -nojournal -nolog -mode tcl -source run.tcl -tclargs "prefix"

These are prefixes used in various situations:
        
        program             Starts vivado searchs for a project and programs FPGA
        simulation          Starts vivado searchs for a project and run simulation
        bitstream           Starts vivado searchs for a project and run generate bitstream
        run                 Starts vivado searchs for a project and run generate bitstream and programs FPGA
 
