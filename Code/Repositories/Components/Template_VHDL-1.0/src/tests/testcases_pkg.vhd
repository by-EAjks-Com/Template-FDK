--  Template-FDK, by-EAjks.Com FPGA Design Best Practices
--  Copyright (c) 2022-2024 Andrea and Eric DELAGE <Contact@by-EAjks.Com>
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <https://www.gnu.org/licenses/>.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library template_vhdl_v1_0;
use template_vhdl_v1_0.testbench_pkg;

package testcases_pkg is

    procedure run_testcase_0(
        signal p_testbench_handler_in : out testbench_pkg.t_testbench_handler_in;
        signal p_testbench_handler_out : in testbench_pkg.t_testbench_handler_out;
        constant c_testcase_0_root : in string
    );

end package testcases_pkg;

package body testcases_pkg is

    procedure run_testcase_0(
        signal p_testbench_handler_in : out testbench_pkg.t_testbench_handler_in;
        signal p_testbench_handler_out : in testbench_pkg.t_testbench_handler_out;
        constant c_testcase_0_root : in string
    ) is
    begin

        p_testbench_handler_in.generate_p_reset_n <= '0';
        p_testbench_handler_in.generate_p_clock <= '0';
        p_testbench_handler_in.p_s_push <= '0';
        p_testbench_handler_in.p_s_data <= B"0000";

        wait for 1 ns;

        p_testbench_handler_in.generate_p_reset_n <= '1';
        p_testbench_handler_in.generate_p_clock <= '1';

        for i in 1 to 10
        loop wait until rising_edge(p_testbench_handler_out.p_clock);
        end loop;

        p_testbench_handler_in.p_s_push <= '1';
        p_testbench_handler_in.p_s_data <= B"1111";

        for i in 1 to 10
        loop wait until rising_edge(p_testbench_handler_out.p_clock);
        end loop;

        p_testbench_handler_in.p_s_push <= '1';
        p_testbench_handler_in.p_s_data <= B"0000";

        for i in 1 to 10
        loop wait until rising_edge(p_testbench_handler_out.p_clock);
        end loop;

        p_testbench_handler_in.p_s_push <= '0';
        p_testbench_handler_in.p_s_data <= B"1111";

        for i in 1 to 10
        loop wait until rising_edge(p_testbench_handler_out.p_clock);
        end loop;

        wait for 1 ns;

        p_testbench_handler_in.generate_p_reset_n <= '0';
        p_testbench_handler_in.generate_p_clock <= '0';

    end procedure run_testcase_0;

end package body testcases_pkg;
