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

set project_source_dir [file normalize [lindex $argv 0]]
set project_output_dir [file normalize [lindex $argv 1]]

for { set i 2 } { $i < [llength $argv] } { incr i } {

    set project_source [file normalize [lindex $argv $i]]

    # If $project_source starts with $project_source_dir
    if { [string compare -length [string length $project_source_dir] $project_source $project_source_dir] == 0 } {

        # Remove  leading $project_source_dir
        set project_source_short [string replace $project_source 0 [string length $project_source_dir] ""]

        # Replace leading $project_source_dir by $project_output_dir
        set project_output [string replace $project_source 0 [string length $project_source_dir]-1 $project_output_dir]

        if { ![info exists ::env(EAjks_NoEncryption)] } {

            switch -exact -- [file extension $project_source] {

                .sv -
                .v {

                    puts "Copying and encrypting $project_source_short"

                    file mkdir [file dirname $project_output]
                    file copy -force -- $project_source $project_output

                    set encryption_key_file [file join [file dirname [info script]] ieee_1735_2014_public_keys.v]

                    encrypt \
                        -key $encryption_key_file \
                        -lang verilog \
                        -quiet \
                        $project_output

                }

                .vhd -
                .vhdl {

                    puts "Copying and encrypting $project_source_short"

                    file mkdir [file dirname $project_output]
                    file copy -force -- $project_source $project_output

                    set encryption_key_file [file join [file dirname [info script]] ieee_1735_2014_public_keys.vhd]

                    encrypt \
                        -key $encryption_key_file \
                        -lang vhdl \
                        -quiet \
                        $project_output

                }

                default {

                    puts "Copying $project_source_short"

                    file mkdir [file dirname $project_output]
                    file copy -force -- $project_source $project_output

                }

            }

        } {

            switch -exact -- [file extension $project_source] {

                default {

                    puts "Copying $project_source_short"

                    file mkdir [file dirname $project_output]
                    file copy -force -- $project_source $project_output

                }

            }

        }

    } {

        puts "Ignoring $project_source"

    }

}
