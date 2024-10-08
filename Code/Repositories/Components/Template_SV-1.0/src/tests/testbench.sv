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

`include "uvm_macros.svh"

module testbench;

    import uvm_pkg::*;
    import tests_pkg::*;

    logic p_reset_n = 1'b1;
    logic p_clock = 1'b0;

    // Reset Generation
    initial begin
        p_reset_n = 1'b1;
        #1ns p_reset_n = 1'b0;
        #1ns p_reset_n = 1'b1;
    end

    // Clock Generation
    initial begin
        p_clock = 1'b0;
        forever begin
            #5ns p_clock = ~p_clock;
        end
    end

    hs2way_io #(
        .g_data_size(4)
    ) hs2way_s_if (
        .p_reset_n(p_reset_n),
        .p_clock(p_clock)
    );

    hs1way_io #(
        .g_data_size(4)
    ) hs1way_m_if (
        .p_reset_n(p_reset_n),
        .p_clock(p_clock)
    );

    system_wrapper
        i_template_sv_v1_0 (
            .p_reset_n,
            .p_clock,
            .p_s_push(hs2way_s_if.p_push),
            .p_s_wait_n(hs2way_s_if.p_wait_n),
            .p_s_data(hs2way_s_if.p_data),
            .p_m_push(hs1way_m_if.p_push),
            .p_m_data(hs1way_m_if.p_data)
        );

    initial begin
        uvm_config_db #(virtual hs2way_io #(.g_data_size(4)))::set(uvm_root::get(), "*", "i_template_sv_v1_0_s_if", hs2way_s_if);
        uvm_config_db #(virtual hs1way_io #(.g_data_size(4)))::set(uvm_root::get(), "*", "i_template_sv_v1_0_m_if", hs1way_m_if);
    end

    initial begin
        run_test();
    end

endmodule: testbench
