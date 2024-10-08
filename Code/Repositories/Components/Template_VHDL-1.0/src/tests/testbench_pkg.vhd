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

package testbench_pkg is

    type t_testbench_handler_in is record
        generate_p_reset_n : std_logic;
        generate_p_clock : std_logic;
        p_s_push : std_logic;
        p_s_data : std_logic_vector(3 downto 0);
    end record t_testbench_handler_in;

    type t_testbench_handler_out is record
        p_reset_n : std_logic;
        p_clock : std_logic;
        p_s_wait_n : std_logic;
        p_m_push : std_logic;
        p_m_data : std_logic_vector(3 downto 0);
    end record t_testbench_handler_out;

end package testbench_pkg;

package body testbench_pkg is

end package body testbench_pkg;
