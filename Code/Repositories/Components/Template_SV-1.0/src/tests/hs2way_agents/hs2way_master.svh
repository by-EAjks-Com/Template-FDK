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

`ifndef HS2WAY_MASTER_SVH
`define HS2WAY_MASTER_SVH

class hs2way_master #(parameter int g_data_size = 16) extends uvm_agent;

    `uvm_component_param_utils(hs2way_master #(.g_data_size(g_data_size)))

    hs2way_master_sequencer #(.g_data_size(g_data_size)) m_sequencer;
    hs2way_master_driver #(.g_data_size(g_data_size)) m_driver;
    hs2way_master_monitor #(.g_data_size(g_data_size)) m_monitor;

    uvm_analysis_port #(.T(hs2way_sequence_item #(.g_data_size(g_data_size)))) m_analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (this.get_is_active() == UVM_ACTIVE) begin
            this.m_sequencer = hs2way_master_sequencer #(.g_data_size(g_data_size))::type_id::create("m_sequencer", this);
            this.m_driver = hs2way_master_driver #(.g_data_size(g_data_size))::type_id::create("m_driver", this);
        end
        this.m_monitor = hs2way_master_monitor #(.g_data_size(g_data_size))::type_id::create("m_monitor", this);
        this.m_analysis_port = new("m_analysis_port", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (this.get_is_active() == UVM_ACTIVE) begin
            this.m_driver.seq_item_port.connect(this.m_sequencer.seq_item_export);
        end
        this.m_monitor.m_item_collected_port.connect(this.m_analysis_port);
    endfunction

endclass: hs2way_master

`endif
