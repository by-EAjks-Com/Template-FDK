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

`ifndef TEST_BASIC_SVH
`define TEST_BASIC_SVH

import uvm_pkg::*;
import hs1way_slave_pkg::*;
import hs2way_master_pkg::*;

class test_basic extends uvm_test;

    `uvm_component_utils(test_basic)

    env #(.g_data_size(4)) m_env;
    virtual_sequence #(.g_data_size(4)) m_sequence;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = env #(.g_data_size(4))::type_id::create("m_env", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        this.m_sequence = virtual_sequence #(.g_data_size(4))::type_id::create("m_sequence", this);
        phase.raise_objection(this);
        this.m_sequence.start(this.m_env.m_virtual_sequencer);
        phase.drop_objection(this);
    endtask: run_phase

endclass: test_basic

`endif
