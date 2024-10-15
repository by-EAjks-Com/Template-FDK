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

set work_directory [file join . Simulation]

if { [file exists $work_directory] } {
    file delete -force -- $work_directory
}

create_project device_under_test $work_directory -part xcku025-ffva1156-1-c

set_property \
    -dict [list \
        target_language Verilog \
        default_lib $library_name \
        ip_repo_paths [concat \
            $repositories_components \
            $repositories_interfaces]] \
    -objects [current_project]

update_ip_catalog -rebuild

# System
# Generation

create_bd_design system

# Let's create all instances.

create_bd_cell -type ip -vlnv $ip_xact_vendor:$ip_xact_library:$ip_xact_name:$ip_xact_version i_device_under_test

set_property \
    -dict [list \
        CONFIG.g_data_size 4] \
    -objects [get_bd_cells i_device_under_test]

# Let's connect pins to ports.

make_bd_pins_external -name p_reset_n [get_bd_pins i_device_under_test/p_reset_n]
make_bd_pins_external -name p_clock [get_bd_pins i_device_under_test/p_clock]
make_bd_intf_pins_external -name p_s [get_bd_intf_pins i_device_under_test/s]
make_bd_pins_external -name p_m_wait_n [get_bd_pins i_device_under_test/p_m_wait_n]
make_bd_intf_pins_external -name p_m [get_bd_intf_pins i_device_under_test/m]

regenerate_bd_layout
save_bd_design
close_bd_design [current_bd_design]

# System
# Simulation

make_wrapper -files [get_files [file join $work_directory device_under_test.srcs sources_1 bd system system.bd]] -top

add_files -fileset [get_filesets sim_1] -norecurse [file join $work_directory device_under_test.gen sources_1 bd system hdl system_wrapper.v]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs2way_agents hs2way_io.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs2way_agents hs2way_master_pkg.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs2way_agents hs2way_slave_pkg.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs1way_agents hs1way_io.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs1way_agents hs1way_master_pkg.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests hs1way_agents hs1way_slave_pkg.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests environment env_pkg.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests testbench.sv]
add_files -fileset [get_filesets sim_1] -norecurse [file join $project_source_dir tests tests_pkg.sv]

set_property \
    -dict [list \
        top testbench] \
    -objects [get_filesets sim_1]

update_compile_order -fileset [get_filesets sources_1]
update_compile_order -fileset [get_filesets sim_1]

set_property \
    -name target_simulator \
    -value XSim \
    -objects [current_project]

set_property \
    -dict [list \
        xsim.compile.xvlog.more_options {-L uvm -uvm_version 1.2} \
        xsim.elaborate.xelab.more_options {-L uvm -uvm_version 1.2} \
        xsim.simulate.xsim.more_options {-testplusarg UVM_TESTNAME=test_basic -testplusarg UVM_VERBOSITY=UVM_LOW} \
        xsim.simulate.runtime {0 us}] \
    -objects [get_filesets sim_1]

launch_simulation -step all -simset [get_filesets sim_1] -mode behavioral

set wg_device_under_test [add_wave_group {Device Under Test}]

add_wave /testbench/i_template_sv_v1_0/system_i/i_device_under_test/inst -into $wg_device_under_test

run all
