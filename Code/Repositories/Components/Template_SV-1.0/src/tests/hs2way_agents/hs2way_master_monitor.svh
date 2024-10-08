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

`ifndef HS2WAY_MASTER_MONITOR_SVH
`define HS2WAY_MASTER_MONITOR_SVH

class hs2way_master_monitor #(parameter int g_data_size) extends uvm_monitor;

    `uvm_component_param_utils(hs2way_master_monitor #(.g_data_size(g_data_size)))

    virtual hs2way_io #(.g_data_size(g_data_size)).master_monitor m_hs2way_if;

    hs2way_sequence_item #(.g_data_size(g_data_size)) m_item_collected;

    uvm_analysis_port #(.T(hs2way_sequence_item #(.g_data_size(g_data_size)))) m_item_collected_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (uvm_config_db #(.T(virtual hs2way_io #(.g_data_size(g_data_size))))::get(this, "", "i_template_sv_v1_0_s_if", this.m_hs2way_if) == 0) begin
            `uvm_fatal(this.get_type_name(), { "virtual interface must be set for: ", this.get_full_name(), ".m_hs2way_if" });
        end
        this.m_item_collected_port = new("m_item_collected_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge this.m_hs2way_if.p_clock);
            if (
                (this.m_hs2way_if.p_reset_n == 1'b1) &&
                (this.m_hs2way_if.ioMasterMonitor.p_push == 1'b1) &&
                (this.m_hs2way_if.ioMasterMonitor.p_wait_n == 1'b1)
            ) begin
                this.m_item_collected = hs2way_sequence_item #(.g_data_size(g_data_size))::type_id::create("m_item_collected");
                this.m_item_collected.m_data = this.m_hs2way_if.ioMasterMonitor.p_data;
                this.m_item_collected_port.write(this.m_item_collected);
            end
        end
    endtask: run_phase

endclass: hs2way_master_monitor

`endif
