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
set ip_xact_name_busdef [lindex $argv 2]
set ip_xact_name_absdef [lindex $argv 3]
set ip_xact_version [lindex $argv 4]
set project_output_dir [lindex $argv 5]

# IP-XACT
# Bus Definition

set bus_definition \
    [ipx::create_bus_definition \
        $ip_xact_vendor \
        $ip_xact_library \
        $ip_xact_name_busdef \
        $ip_xact_version]

set_property \
    -dict [list \
        xml_file_name [file join $project_output_dir $ip_xact_name_busdef.xml] \
        direct_connection true \
        is_addressable false \
        max_masters 1 \
        max_slaves 1] \
    -objects $bus_definition

ipx::save_bus_definition $bus_definition

# IP-XACT
# Abstraction Definition

set abstraction_definition \
    [ipx::create_abstraction_definition \
        $ip_xact_vendor \
        $ip_xact_library \
        $ip_xact_name_absdef \
        $ip_xact_version]

set_property \
    -dict [list \
        xml_file_name [file join $project_output_dir $ip_xact_name_absdef.xml] \
        bus_type_vlnv $ip_xact_vendor:$ip_xact_library:$ip_xact_name_busdef:$ip_xact_version] \
    -objects $abstraction_definition

# IP-XACT
# Ports

foreach {
    port_name
    port_properties
} [list \
    activate \
        [list \
            master_presence required \
            master_direction out \
            master_width 1 \
            slave_presence required \
            slave_direction in \
            slave_width 1] \
    is_activated \
        [list \
            master_presence required \
            master_direction in \
            master_width 1 \
            slave_presence required \
            slave_direction out \
            slave_width 1] \
    deactivate \
        [list \
            master_presence required \
            master_direction in \
            master_width 1 \
            slave_presence required \
            slave_direction out \
            slave_width 1] \
    send_credit \
        [list \
            master_presence required \
            master_direction in \
            master_width 1 \
            slave_presence required \
            slave_direction out \
            slave_width 1] \
    send_credit_back \
        [list \
            master_presence required \
            master_direction out \
            master_width 1 \
            slave_presence required \
            slave_direction in \
            slave_width 1] \
    push \
        [list \
            master_presence required \
            master_direction out \
            master_width 1 \
            slave_presence required \
            slave_direction in \
            slave_width 1] \
    data \
        [list \
            is_data true \
            master_presence required \
            master_direction out \
            slave_presence required \
            slave_direction in] \
] {
    set bus_abstraction_port \
        [ipx::add_bus_abstraction_port \
            $port_name \
            $abstraction_definition]

    set_property \
        -dict $port_properties \
        -objects $bus_abstraction_port
}

ipx::save_abstraction_definition $abstraction_definition
