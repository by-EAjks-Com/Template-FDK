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

`ifndef HS2WAY_SEQUENCE_ITEM_SVH
`define HS2WAY_SEQUENCE_ITEM_SVH

class hs2way_sequence_item #(parameter int g_data_size) extends uvm_sequence_item;

    rand logic[(g_data_size - 1):0] m_data;

    `uvm_object_param_utils_begin(hs2way_sequence_item #(.g_data_size(g_data_size)))
        `uvm_field_int(m_data, UVM_ALL_ON);
    `uvm_object_utils_end

    function new(string name = "hs2way_sequence_item");
        super.new(name);
    endfunction: new

    constraint c1 { this.m_data != '0; };

endclass: hs2way_sequence_item

`endif
