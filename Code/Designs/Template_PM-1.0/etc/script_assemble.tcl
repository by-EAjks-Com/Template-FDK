#   Template-FDK, by-EAjks.Com FPGA Design Best Practices
#   Copyright (c) 2022-2024 Andrea and Eric DELAGE <Contact@by-EAjks.Com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

set ip_xact_vendor [lindex $argv 0]
set ip_xact_library [lindex $argv 1]
set ip_xact_name [lindex $argv 2]
set ip_xact_version [lindex $argv 3]
set project_source_dir [lindex $argv 4]
set project_output_dir [lindex $argv 5]
set library_name [lindex $argv 6]
set repositories_boards [split [lindex $argv 7] ","]
set repositories_components [split [lindex $argv 8] ","]
set repositories_interfaces [split [lindex $argv 9] ","]
set quick_compile [lindex $argv 10]
set include_debug [lindex $argv 11]

set work_directory [file join . Assembly]

if { [file exists $work_directory] } {
    file delete -force -- $work_directory
}

set_param board.repoPaths [concat \
    ${repositories_boards}]

create_project $ip_xact_name $work_directory -part xcu50-fsvh2104-2-e

set_property \
    -dict [list \
        board_part xilinx.com:au50:part0:1.3 \
        target_language VHDL \
        default_lib $library_name \
        ip_repo_paths [concat \
            $repositories_components \
            $repositories_interfaces]] \
    -objects [current_project]

update_ip_catalog -rebuild

# System
# Assembly

create_bd_design system

# Let's create all instances.

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:qdma:5.0 \
    i_qdma

apply_bd_automation \
    -rule xilinx.com:bd_rule:qdma \
    -config [list \
        axi_clk {Maximum Data Width} \
        axi_intf AXI_MM_and_AXI_Stream_with_Completion \
        bar_size Disable \
        lane_width X8 \
        link_speed {16.0 GT/s (PCIe Gen 4)}] \
    -objects [get_bd_cells i_qdma]

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 \
    i_axi_bram_controller

set_property \
    -dict [list \
        config.data_width 512] \
    -objects [get_bd_cells i_axi_bram_controller]

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:blk_mem_gen:8.4 \
    i_axi_bram_devices

set_property \
    -dict [list \
        config.memory_type True_Dual_Port_RAM] \
    -objects [get_bd_cells i_axi_bram_devices]

# Let's connect the various reset networks

connect_bd_net \
    [get_bd_pins i_qdma/axi_aresetn] \
    [get_bd_pins i_axi_bram_controller/s_axi_aresetn]

# Let's connect the various clock networks

connect_bd_net \
    [get_bd_pins i_qdma/axi_aclk] \
    [get_bd_pins i_axi_bram_controller/s_axi_aclk]

# Let's connect the remaining interfaces|signals of all instances

connect_bd_intf_net [get_bd_intf_pins i_qdma/M_AXI] [get_bd_intf_pins i_axi_bram_controller/S_AXI]
connect_bd_intf_net [get_bd_intf_pins i_axi_bram_controller/BRAM_PORTA] [get_bd_intf_pins i_axi_bram_devices/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins i_axi_bram_controller/BRAM_PORTB] [get_bd_intf_pins i_axi_bram_devices/BRAM_PORTB]

# Let's map all instances in the various memory address spaces

create_bd_addr_seg -offset {0x0000000000000000} -range {0x0000000000010000} [get_bd_addr_spaces /i_qdma/M_AXI] [get_bd_addr_segs /i_axi_bram_controller/S_AXI/Mem0] a_i_qdma_m_axi_i_axi_bram_controller_s_axi_mem0

regenerate_bd_layout

validate_bd_design

save_bd_design

close_bd_design [current_bd_design]

set_property \
    -dict [list \
        generate_synth_checkpoint 1 \
        synth_checkpoint_mode Hierarchical] \
    -objects [get_files [file join $work_directory $ip_xact_name.srcs sources_1 bd system system.bd]]

generate_target all [get_files [file join $work_directory $ip_xact_name.srcs sources_1 bd system system.bd]]

make_wrapper -files [get_files [file join $work_directory $ip_xact_name.srcs sources_1 bd system system.bd]] -top

add_files -fileset [get_filesets sources_1] -norecurse [file join $work_directory $ip_xact_name.gen sources_1 bd system hdl system_wrapper.vhd]
