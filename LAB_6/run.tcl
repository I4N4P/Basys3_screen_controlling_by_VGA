set project uart_monitor
set top_module uart_monitor
# set top_sim_module draw_rect_ctl
set target xc7a35tcpg236-1
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

proc usage {} {
        puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program\]"
        exit 1
}

proc attach_files {} {
        read_xdc {
                constraints/uart.xdc
        }

        # read_vhdl {
        #         rtl/MouseCtl.vhd
        #         rtl/Ps2Interface.vhd
        #         rtl/MouseDisplay.vhd
        # }

        read_verilog {
                rtl/debounce.v
                rtl/disp_hex_mux.v
                rtl/fifo.v
                rtl/flag_buf.v
                rtl/mod_m_counter.v
                rtl/uart_rx.v
                rtl/uart_tx.v
                rtl/uart.v        
                rtl/uart_monitor.v        
                rtl/gen_clock.v        
                rtl/internal_reset.v        
                rtl/disp_hex_mux.v        
        }

        # sim/draw_rect_ctl_test.v
        # sim/draw_rect_ctl_tb.v

        # add_files -fileset sim_1 {
                
        #         sim/testbench.v
        #         sim/tiff_writer.v
        # }
}

proc make_project {} {
        global top_module
        global target

        file mkdir build
        create_project ${top_module} build -part ${target} -force
        attach_files
}

proc make_bitstream {} {
        global top_module

        set_property top ${top_module} [current_fileset]
        update_compile_order -fileset sources_1
        update_compile_order -fileset sim_1

        launch_runs synth_1 -jobs 8
        wait_on_run synth_1

        launch_runs impl_1 -to_step write_bitstream -jobs 8
        wait_on_run impl_1
}

if {($argc != 1) || ([lindex $argv 0] ni {"simulation" "bitstream" "program"})} {
        usage
}

if {[lindex $argv 0] == "program"} {

        set fexist [file exist ${bitstream_file}]
        puts "bitstream exist : $fexist"
        # if { $fexist == 0 } {
        #         make_project
        #         make_bitstream 
        # }     
        open_hw
        connect_hw_server
        current_hw_target [get_hw_targets *]
        open_hw_target
        current_hw_device [lindex [get_hw_devices] 0]
        refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

        set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

        program_hw_devices [lindex [get_hw_devices] 0]
        refresh_hw_device [lindex [get_hw_devices] 0]
        
        exit
} else {
        make_project
}

if {[lindex $argv 0] == "simulation"} {

        # remove_files -fileset sim_1 {
        #         sim/testbench.v
        #         sim/tiff_writer.v
        # }      

        # remove_files -fileset sources_1 {
        #         rtl/vga_example.v
        #         rtl/vga_timing.v
        #         rtl/draw_background.v
        #         rtl/draw_rect.v
        #         rtl/clk_generator.v
        #         rtl/internal_reset.v
        #         rtl/position_memory.v
        #         rtl/image_rom.v
        #         rtl/signal_synchronizer.v 
                
        #         rtl/MouseCtl.vhd
        #         rtl/Ps2Interface.vhd
        #         rtl/MouseDisplay.vhd
        # } 

        set_property top ${top_module} [current_fileset]
        update_compile_order -fileset sources_1
        update_compile_order -fileset sim_1

        launch_simulation
        # add_wave {{/draw_rect_ctl_test/my_draw_rect_ctl/xpos}} {{/draw_rect_ctl_test/my_draw_rect_ctl/ypos}} 
        start_gui
        # run all
        
} else { 
        
        make_bitstream

        # Sekwencja pokazujaca i zapisujaca schemat rtl
        # start_gui
        # synth_design -rtl -name rtl_1 
        # show_schematic [concat [get_cells] [get_ports]]
        # write_schematic -force -format pdf rtl_schematic.pdf -orientation landscape -scope visible

         exit
}
