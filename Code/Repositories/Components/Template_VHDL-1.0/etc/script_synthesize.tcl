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
set project_output_dir [lindex $argv 4]
set library_name [lindex $argv 5]
set repositories_boards [split [lindex $argv 6] ","]
set repositories_components [split [lindex $argv 7] ","]
set repositories_interfaces [split [lindex $argv 8] ","]

set work_directory [file join . Synthesis]

if { [file exists $work_directory] } {
    file delete -force -- $work_directory
}

create_project device_under_test $work_directory -part xcku025-ffva1156-1-c

set_property \
    -dict [list \
        target_language vhdl \
        default_lib device_under_test \
        ip_repo_paths [concat \
            $repositories_components \
            $repositories_interfaces]] \
    -objects [current_project]

update_ip_catalog -rebuild

create_ip \
    -vendor $ip_xact_vendor \
    -library $ip_xact_library \
    -name $ip_xact_name \
    -version $ip_xact_version \
    -module_name device_under_test

set_property \
    -dict [list \
        CONFIG.g_data_size 4] \
    -objects [get_ips device_under_test]

set ip_run [create_ip_run [get_ips device_under_test]]

launch_run $ip_run
wait_on_run $ip_run
open_run $ip_run

report_cdc -name cdc
report_clock_interaction -name clock_interaction
report_clock_networks -name clock_networks
report_clock_utilization -name clock_utilization
report_design_analysis -name design_analysis
report_high_fanout_nets -name high_fanout_nets
report_methodology -name methodology
report_timing_summary -name timing_summary
report_timing -name timing
report_utilization -name utilization
