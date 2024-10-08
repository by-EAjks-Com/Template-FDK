//  Template-FDK, by-EAjks.Com FPGA Design Best Practices
//  Copyright (c) 2022-2024 Andrea and Eric DELAGE <Contact@by-EAjks.Com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

`ifndef SCOREBOARD_SVH
`define SCOREBOARD_SVH

class scoreboard #(parameter int g_data_size) extends uvm_scoreboard;

    `uvm_component_param_utils(scoreboard #(.g_data_size(g_data_size)))

    uvm_analysis_imp #(.T(hs2way_sequence_item #(.g_data_size(g_data_size))), .IMP(scoreboard #(.g_data_size(g_data_size)))) m_item_collected_export;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        this.m_item_collected_export = new("m_item_collected_export", this);
    endfunction: build_phase

    virtual function void write(hs2way_sequence_item #(.g_data_size(g_data_size)) item);
        `uvm_info (this.get_type_name(), $sformatf("Received Transaction : \n%s", item.sprint()), UVM_MEDIUM)
    endfunction: write

endclass: scoreboard

`endif
