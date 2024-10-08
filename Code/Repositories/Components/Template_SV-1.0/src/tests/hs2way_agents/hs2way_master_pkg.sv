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

`ifndef HS2WAY_MASTER_PKG_SV
`define HS2WAY_MASTER_PKG_SV

`include "uvm_macros.svh"

package hs2way_master_pkg;

    import uvm_pkg::*;

    `include "hs2way_sequence_item.svh"
    `include "hs2way_sequence_child.svh"
    `include "hs2way_sequence_parent.svh"
    `include "hs2way_master_sequencer.svh"
    `include "hs2way_master_driver.svh"
    `include "hs2way_master_monitor.svh"
    `include "hs2way_master.svh"

endpackage: hs2way_master_pkg

`endif
