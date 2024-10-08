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

# IP-XACT
# Component

set core \
    [ipx::create_core \
        $ip_xact_vendor \
        $ip_xact_library \
        $ip_xact_name \
        $ip_xact_version]

set_property \
    -dict [list \
        xml_file_name [file join $project_output_dir component.xml] \
        supported_families [list \
            kintexu Production \
            kintexuplus Production \
            virtexu Production \
            virtexuplus Production]] \
    -objects $core

# IP-XACT
# Model Views

# ... simulation

set file_group_simulation [ipx::add_file_group -type simulation {} $core]

set_property \
    -dict [list \
        language VHDL \
        model_name top_level] \
    -objects $file_group_simulation

foreach {
    file_name
    file_properties
} [list \
    [file join models top_level.vhd] \
        [list \
            type vhdlSource \
            library_name $library_name \
            used_in [list ipstatic]] \
] {
    set file \
        [ipx::add_file \
            $file_name \
            $file_group_simulation]

    set_property \
        -dict $file_properties \
        -objects $file
}

# ... synthesis

set file_group_synthesis [ipx::add_file_group -type synthesis {} $core]

set_property \
    -dict [list \
        language VHDL \
        model_name top_level] \
    -objects $file_group_synthesis

foreach {
    file_name
    file_properties
} [list \
    [file join constraints top_level.xdc] \
        [list \
            scoped_to_ref top_level \
            used_in [list synthesis implementation]] \
    [file join constraints top_level_ooc.xdc] \
        [list \
            scoped_to_ref top_level \
            used_in [list synthesis implementation out_of_context]] \
    [file join models top_level.vhd] \
        [list \
            type vhdlSource \
            library_name $library_name] \
] {
    set file \
        [ipx::add_file \
            $file_name \
            $file_group_synthesis]

    set_property \
        -dict $file_properties \
        -objects $file
}

# IP-XACT
# Model Parameters

foreach {
    parameter_name
    parameter_properties_hdl
    parameter_properties_user
    parameter_properties_gui
} [list \
    g_data_size \
        [list \
            data_type positive \
            display_name {Data Size} \
            value 8 \
            value_format long \
            value_resolve_type generated] \
        [list \
            display_name {Data Size} \
            value 8 \
            value_format long \
            value_resolve_type user \
            value_validation_type range_long \
            value_validation_range_minimum 1 \
            value_validation_range_maximum 8] \
        [list \
            display_name {Data Size} \
            widget textEdit] \
] {
    set parameter_hdl \
        [ipx::add_hdl_parameter \
            $parameter_name \
            $core]

    set_property \
        -dict $parameter_properties_hdl \
        -objects $parameter_hdl

    set parameter_user \
        [ipx::add_user_parameter \
            $parameter_name \
            $core]

    set_property \
        -dict $parameter_properties_user \
        -objects $parameter_user

    set parameter_gui \
        [ipgui::add_param \
            -name $parameter_name \
            -component $core]

    set_property \
        -dict $parameter_properties_gui \
        -objects $parameter_gui
}

# IP-XACT
# Model Ports

foreach {
    port_name
    port_properties
} [list \
    p_reset_n \
        [list \
            direction in \
            type_name std_logic] \
    p_clock \
        [list \
            direction in \
            type_name std_logic] \
    p_s_push \
        [list \
            direction in \
            type_name std_logic] \
    p_s_wait_n \
        [list \
            direction out \
            type_name std_logic] \
    p_s_data \
        [list \
            direction in \
            type_name std_logic_vector \
            size_left_dependency {(spirit:decode(id('MODELPARAM_VALUE.g_data_size')) - 1)} \
            size_right 0] \
    p_m_push \
        [list \
            direction out \
            type_name std_logic] \
    p_m_data \
        [list \
            direction out \
            type_name std_logic_vector \
            size_left_dependency {(spirit:decode(id('MODELPARAM_VALUE.g_data_size')) - 1)} \
            size_right 0] \
] {
    set port \
        [ipx::add_port \
            $port_name \
            $core]

    set_property \
        -dict $port_properties \
        -objects $port
}

# IP-XACT
# Bus Interfaces

# ... reset_n

set bus_interface_reset_n [ipx::add_bus_interface reset_n $core]

set_property \
    -dict [list \
        bus_type_vlnv xilinx.com:signal:reset:1.0 \
        abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 \
        interface_mode slave] \
    -objects $bus_interface_reset_n

foreach {
    port_name_logical
    port_name_physical
} [list \
    RST p_reset_n \
] {
    set port_map \
        [ipx::add_port_map \
            $port_name_logical \
            $bus_interface_reset_n]

    set_property \
        -name physical_name -value $port_name_physical \
        -objects $port_map
}

foreach {
    parameter_name
    parameter_properties
} [list \
    POLARITY [list value ACTIVE_LOW] \
] {
    set bus_parameter \
        [ipx::add_bus_parameter \
            $parameter_name \
            $bus_interface_reset_n]

    set_property \
        -dict $parameter_properties \
        -objects $bus_parameter
}

# ... clock

set bus_interface_clock [ipx::add_bus_interface clock $core]

set_property \
    -dict [list \
        bus_type_vlnv xilinx.com:signal:clock:1.0 \
        abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 \
        interface_mode slave] \
    -objects $bus_interface_clock

foreach {
    port_name_logical
    port_name_physical
} [list \
    CLK p_clock \
] {
    set port_map \
        [ipx::add_port_map \
            $port_name_logical \
            $bus_interface_clock]

    set_property \
        -name physical_name -value $port_name_physical \
        -objects $port_map
}

foreach {
    parameter_name
    parameter_properties
} [list \
    ASSOCIATED_RESET [list value p_reset_n] \
    ASSOCIATED_BUSIF [list value s:m] \
] {
    set bus_parameter \
        [ipx::add_bus_parameter \
            $parameter_name \
            $bus_interface_clock]

    set_property \
        -dict $parameter_properties \
        -objects $bus_parameter
}

# ... s

set bus_interface_s [ipx::add_bus_interface s $core]

set_property \
    -dict [list \
        bus_type_vlnv $ip_xact_vendor:interfaces:handshaking_twoway:1.0 \
        abstraction_type_vlnv $ip_xact_vendor:interfaces:handshaking_twoway_rtl:1.0 \
        interface_mode slave] \
    -objects $bus_interface_s

foreach {
    port_name_logical
    port_name_physical
} [list \
    push p_s_push \
    wait_n p_s_wait_n \
    data p_s_data \
] {
    set port_map \
        [ipx::add_port_map \
            $port_name_logical \
            $bus_interface_s]

    set_property \
        -name physical_name -value $port_name_physical \
        -objects $port_map
}

# ... m

set bus_interface_m [ipx::add_bus_interface m $core]

set_property \
    -dict [list \
        bus_type_vlnv $ip_xact_vendor:interfaces:handshaking_oneway:1.0 \
        abstraction_type_vlnv $ip_xact_vendor:interfaces:handshaking_oneway_rtl:1.0 \
        interface_mode master] \
    -objects $bus_interface_m

foreach {
    port_name_logical
    port_name_physical
} [list \
    push p_m_push \
    data p_m_data \
] {
    set port_map \
        [ipx::add_port_map \
            $port_name_logical \
            $bus_interface_m]

    set_property \
        -name physical_name -value $port_name_physical \
        -objects $port_map
}

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core
