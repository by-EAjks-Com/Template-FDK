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

`ifndef VIRTUAL_SEQUENCE_SVH
`define VIRTUAL_SEQUENCE_SVH

class virtual_sequence #(parameter int g_data_size) extends uvm_sequence #(.REQ(hs2way_sequence_item #(.g_data_size(g_data_size))));

    `uvm_object_param_utils(virtual_sequence #(.g_data_size(g_data_size)))
    `uvm_declare_p_sequencer(virtual_sequencer #(.g_data_size(g_data_size)))

    hs2way_sequence_parent #(.g_data_size(g_data_size)) m_hs2way_sequence_parent;

    function new(string name = "virtual_sequence");
        super.new(name);
    endfunction: new

    virtual task pre_body();
        if (this.starting_phase != null) begin
            this.starting_phase.raise_objection(this);
        end
    endtask: pre_body

    virtual task body();
        this.m_hs2way_sequence_parent = hs2way_sequence_parent #(.g_data_size(4))::type_id::create("m_hs2way_sequence_parent");
        fork
            this.m_hs2way_sequence_parent.start(this.p_sequencer.m_hs2way_master_sequencer);
        join
    endtask: body

    virtual task post_body();
        if (this.starting_phase != null) begin
            this.starting_phase.drop_objection(this);
        end
    endtask: post_body

endclass: virtual_sequence

`endif
