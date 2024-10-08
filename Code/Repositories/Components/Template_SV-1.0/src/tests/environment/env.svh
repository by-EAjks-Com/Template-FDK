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

`ifndef ENV_SVH
`define ENV_SVH

class env #(parameter int g_data_size) extends uvm_env;

    `uvm_component_param_utils(env #(.g_data_size(g_data_size)))

    scoreboard #(.g_data_size(g_data_size)) m_scoreboard;
    virtual_sequencer #(.g_data_size(g_data_size)) m_virtual_sequencer;
    hs2way_master #(.g_data_size(g_data_size)) m_hs2way_master;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        this.m_scoreboard = scoreboard #(.g_data_size(g_data_size))::type_id::create("m_scoreboard", this);
        this.m_virtual_sequencer = virtual_sequencer #(.g_data_size(g_data_size))::type_id::create("m_virtual_sequencer", this);
        this.m_hs2way_master = hs2way_master #(.g_data_size(g_data_size))::type_id::create("m_hs2way_master", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        this.m_virtual_sequencer.m_hs2way_master_sequencer = this.m_hs2way_master.m_sequencer;
        this.m_hs2way_master.m_monitor.m_item_collected_port.connect(this.m_scoreboard.m_item_collected_export);
    endfunction: connect_phase

endclass: env

`endif
