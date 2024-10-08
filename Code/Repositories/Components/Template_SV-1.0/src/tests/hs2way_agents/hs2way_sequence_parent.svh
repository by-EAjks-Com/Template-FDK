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

`ifndef HS2WAY_SEQUENCE_PARENT_SVH
`define HS2WAY_SEQUENCE_PARENT_SVH

class hs2way_sequence_parent #(parameter int g_data_size) extends uvm_sequence #(.REQ(hs2way_sequence_item #(.g_data_size(g_data_size))));

    `uvm_object_param_utils(hs2way_sequence_parent #(.g_data_size(g_data_size)))
    `uvm_declare_p_sequencer(hs2way_master_sequencer #(.g_data_size(g_data_size)))

    hs2way_sequence_child #(.g_data_size(g_data_size)) m_sequence_child_1;
    hs2way_sequence_child #(.g_data_size(g_data_size)) m_sequence_child_2;
    hs2way_sequence_child #(.g_data_size(g_data_size)) m_sequence_child_3;

    function new(string name = "hs2way_sequence_parent");
        super.new(name);
    endfunction: new

    virtual task pre_body();
        if (this.starting_phase != null) begin
            this.starting_phase.raise_objection(this);
        end
    endtask: pre_body

    virtual task body();
        // 1st way to execute the child sequence.
        this.m_sequence_child_1 = hs2way_sequence_child #(.g_data_size(g_data_size))::type_id::create("m_sequence_child_1");
        assert(this.m_sequence_child_1.randomize() with { });
        this.m_sequence_child_1.start(this.p_sequencer, this);
        this.m_sequence_child_1.start(this.p_sequencer, this, 1);
        // 2nd way to execute the child sequence.
        `uvm_do(this.m_sequence_child_2);
        `uvm_do_pri(this.m_sequence_child_2, 1);
        // 3rd way to execute the child sequence.
        this.m_sequence_child_3 = hs2way_sequence_child #(.g_data_size(g_data_size))::type_id::create("m_sequence_child_3");
        `uvm_send(this.m_sequence_child_3)
        `uvm_send_pri(this.m_sequence_child_3, 1)
        `uvm_rand_send(this.m_sequence_child_3)
        `uvm_rand_send_with(this.m_sequence_child_3, {
            m_sequence_item_1.m_data <= 4'b0111;
            m_sequence_item_2.m_data <= 4'b0111;
        })
        `uvm_rand_send_pri(this.m_sequence_child_3, 1)
        `uvm_rand_send_pri_with(this.m_sequence_child_3, 1, {
            m_sequence_item_1.m_data <= 4'b0111;
            m_sequence_item_2.m_data <= 4'b0111;
        })
    endtask: body

    virtual task post_body();
        if (this.starting_phase != null) begin
            this.starting_phase.drop_objection(this);
        end
    endtask: post_body

endclass: hs2way_sequence_parent

`endif
