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
use template_vhdl_v1_0.testbench;
use template_vhdl_v1_0.testcases_pkg;

entity testcases is

    generic(
        g_testbench_root : string;
        g_testcase_0_root : string;
        g_run_all_testcases : boolean;
        g_run_testcase_0 : boolean
    );

end entity testcases;

architecture behavioral of testcases is

    signal s_testbench_handler_in : testbench_pkg.t_testbench_handler_in;
    signal s_testbench_handler_out : testbench_pkg.t_testbench_handler_out;

begin

    testcase_execution :
    process
    begin

        if ((g_run_all_testcases  = true) or
            (g_run_testcase_0  = true))
        then testcases_pkg.run_testcase_0(
                 p_testbench_handler_in => s_testbench_handler_in,
                 p_testbench_handler_out => s_testbench_handler_out,
                 c_testcase_0_root => g_testcase_0_root
             );
        end if;

        assert (false) severity failure;

    end process testcase_execution;

    testcase_timeout :
    process
    begin

        wait for 1 ms;

        assert (false) severity failure;

    end process testcase_timeout;

    i_testbench :
        entity template_vhdl_v1_0.testbench(behavioral)
            generic map(
                g_testbench_root => g_testbench_root
            )
            port map(
                p_testbench_handler_in => s_testbench_handler_in,
                p_testbench_handler_out => s_testbench_handler_out
            );

end architecture behavioral;
