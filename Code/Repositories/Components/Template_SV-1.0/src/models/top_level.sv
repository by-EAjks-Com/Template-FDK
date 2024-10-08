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

module top_level #(
    parameter int g_data_size
) (
    input logic p_reset_n,
    input logic p_clock,
    input logic p_s_push,
    input logic [(g_data_size - 1):0] p_s_data,
    output logic p_s_wait_n,
    output logic p_m_push,
    output logic [(g_data_size - 1):0] p_m_data
);

    logic [3:0] s_reset_on_clock = '1;

    logic s_s_wait_n = 1'b0;
    logic s_m_push = 1'b0;
    logic [(g_data_size - 1):0] s_m_data = '0;

    always_ff @(
        negedge p_reset_n,
        posedge p_clock
    ) begin

        if  (p_reset_n == 1'b0) begin
            s_reset_on_clock <= '1;
        end
        else begin
            s_reset_on_clock <= {1'b0, s_reset_on_clock[3:1]};
        end

    end

    always_ff @(
        posedge p_clock
    ) begin

        automatic logic v_s_queue_is_empty = 1'b1;
        automatic logic [(g_data_size - 1):0] v_s_data = '0;

        if (v_s_queue_is_empty == 1'b1) begin
            if (
                (p_s_push == 1'b1) &&
                (s_s_wait_n == 1'b1)
            ) begin
                v_s_queue_is_empty = 1'b0;
                s_s_wait_n <= 1'b0;
                v_s_data = p_s_data;
            end
            else begin
                v_s_queue_is_empty = 1'b1;
                s_s_wait_n <= 1'b1;
            end
        end
        else begin
            v_s_queue_is_empty = 1'b0;
            s_s_wait_n <= 1'b0;
        end

        if (v_s_queue_is_empty == 1'b0) begin
            s_s_wait_n <= 1'b1;
            s_m_push <= 1'b1;
            s_m_data <= v_s_data;
        end
        else begin
            s_m_push <= 1'b0;
        end

        if (s_reset_on_clock[0] == 1'b1) begin
            v_s_queue_is_empty = 1'b1;
            s_s_wait_n <= 1'b0;
            s_m_push <= 1'b0;
        end

    end

    assign p_s_wait_n = s_s_wait_n;
    assign p_m_push = s_m_push;
    assign p_m_data = s_m_data;

endmodule
