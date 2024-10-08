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

`ifndef HS2WAY_IO_SV
`define HS2WAY_IO_SV

interface hs2way_io #(parameter int g_data_size) (
    input logic p_reset_n,
    input logic p_clock
);

    logic p_push;
    logic p_wait_n;
    logic [(g_data_size - 1):0] p_data;

    clocking ioMasterDriver @(posedge p_clock);
        default input #1step output #1ns;
        output p_push;
        input p_wait_n;
        output p_data;
    endclocking: ioMasterDriver

    modport master_driver (
        clocking ioMasterDriver,
        input p_reset_n,
        input p_clock,
        output p_push,
        input p_wait_n,
        output p_data
    );

    clocking ioMasterMonitor @(posedge p_clock);
        default input #1step output #1ns;
        input p_push;
        input p_wait_n;
        input p_data;
    endclocking: ioMasterMonitor

    modport master_monitor (
        clocking ioMasterMonitor,
        input p_reset_n,
        input p_clock,
        input p_push,
        input p_wait_n,
        input p_data
    );

    clocking ioSlaveDriver @(posedge p_clock);
        default input #1ns output #3ns;
        input p_push;
        output p_wait_n;
        input p_data;
    endclocking: ioSlaveDriver

    modport slave_driver (
        clocking ioSlaveDriver,
        input p_reset_n,
        input p_clock,
        input p_push,
        output p_wait_n,
        input p_data
    );

    clocking ioSlaveMonitor @(posedge p_clock);
        default input #1step output #1ns;
        input p_push;
        input p_wait_n;
        input p_data;
    endclocking: ioSlaveMonitor

    modport slave_monitor (
        clocking ioSlaveMonitor,
        input p_reset_n,
        input p_clock,
        input p_push,
        input p_wait_n,
        input p_data
    );

endinterface: hs2way_io

`endif
