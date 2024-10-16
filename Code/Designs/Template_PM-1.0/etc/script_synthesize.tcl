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

set work_directory [file join . Synthesis]

if { [file exists $work_directory] } {
    file delete -force -- $work_directory
}

set_param board.repoPaths [concat \
    ${repositories_boards}]

open_project [file join . Assembly $ip_xact_name.xpr]

save_project_as $ip_xact_name $work_directory

set_property \
    -dict [list \
        flow {Vivado Synthesis 2024} \
        strategy {Flow_PerfOptimized_high}] \
    -objects [get_runs synth_1]

launch_run [get_runs synth_1] -jobs 8

wait_on_run [get_runs synth_1]

open_run [get_runs synth_1]

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
