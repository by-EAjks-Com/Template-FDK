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
use template_vhdl_v1_0.system_wrapper;
use template_vhdl_v1_0.testbench_pkg;

entity testbench is

    generic(
        g_testbench_root : string
    );

    port(
        p_testbench_handler_in : in testbench_pkg.t_testbench_handler_in;
        p_testbench_handler_out : out testbench_pkg.t_testbench_handler_out
    );

end entity testbench;

architecture behavioral of testbench is

    signal s_testbench_handler_out : testbench_pkg.t_testbench_handler_out;

begin

    generate_p_reset_n :
    process
    begin

        s_testbench_handler_out.p_reset_n <= '1';
        wait for 1 ns;
        loop wait on p_testbench_handler_in.generate_p_reset_n'transaction;
             if  (p_testbench_handler_in.generate_p_reset_n  = '1')
             then s_testbench_handler_out.p_reset_n <= '0';
                  wait for 1 ns;
                  s_testbench_handler_out.p_reset_n <= '1';
                  wait for 1 ns;
             end if;
        end loop;

    end process generate_p_reset_n;

    generate_p_clock :
    process
    begin

        s_testbench_handler_out.p_clock <= '0';
        wait for 4 ns;
        loop if  (p_testbench_handler_in.generate_p_clock /= '1')
             then wait until (p_testbench_handler_in.generate_p_clock  = '1');
             end if;
             s_testbench_handler_out.p_clock <= '1';
             wait for 4 ns;
             s_testbench_handler_out.p_clock <= '0';
             wait for 4 ns;
        end loop;

    end process generate_p_clock;

    p_testbench_handler_out <= s_testbench_handler_out;

    i_template_vhdl_v1_0 :
        entity template_vhdl_v1_0.system_wrapper(structure)
            port map(
                p_reset_n => s_testbench_handler_out.p_reset_n,
                p_clock => s_testbench_handler_out.p_clock,
                p_s_push => p_testbench_handler_in.p_s_push,
                p_s_wait_n => s_testbench_handler_out.p_s_wait_n,
                p_s_data => p_testbench_handler_in.p_s_data,
                p_m_push => s_testbench_handler_out.p_m_push,
                p_m_data => s_testbench_handler_out.p_m_data
            );

end architecture behavioral;
