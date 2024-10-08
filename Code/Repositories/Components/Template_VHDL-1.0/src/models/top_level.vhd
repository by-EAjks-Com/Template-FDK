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

entity top_level is

    generic(
        g_data_size : positive
    );

    port(
        p_reset_n : in std_logic;
        p_clock : in std_logic;
        p_s_push : in std_logic;
        p_s_wait_n : out std_logic;
        p_s_data : in std_logic_vector((g_data_size - 1) downto 0);
        p_m_push : out std_logic;
        p_m_data : out std_logic_vector((g_data_size - 1) downto 0)
    );

end entity top_level;

architecture rtl of top_level is

    signal s_reset_on_clock : std_logic_vector(3 downto 0) := (others => '1');

    signal s_s_wait_n : std_logic := '0';
    signal s_m_push : std_logic := '0';
    signal s_m_data : std_logic_vector((g_data_size - 1) downto 0) := (others => '0');

    attribute async_reg : string;
    attribute async_reg of s_reset_on_clock : signal is "true";

begin

    main_process_on_clock :
    process(
        p_reset_n,
        p_clock
    )

        variable v_s_queue_is_empty : boolean := true;
        variable v_s_data : std_logic_vector((g_data_size - 1) downto 0);

    begin

        if  (p_reset_n  = '0')
        then s_reset_on_clock <= (others => '1');
        else if rising_edge(p_clock)
             then s_reset_on_clock <= '0' & s_reset_on_clock(3 downto 1);
             end if;
        end if;

        if rising_edge(p_clock) then

            if  (v_s_queue_is_empty  = true)
            then if ((p_s_push  = '1') and
                     (s_s_wait_n  = '1'))
                 then v_s_queue_is_empty := false;
                      s_s_wait_n <= '0';
                      v_s_data := p_s_data;
                 else v_s_queue_is_empty := true;
                      s_s_wait_n <= '1';
                 end if;
            else v_s_queue_is_empty := false;
                 s_s_wait_n <= '0';
            end if;

            if  (v_s_queue_is_empty  = false)
            then v_s_queue_is_empty := true;
                 s_s_wait_n <= '1';
                 s_m_push <= '1';
                 s_m_data <= v_s_data;
            else s_m_push <= '0';
            end if;

            if  (s_reset_on_clock(0)  = '1')
            then v_s_queue_is_empty := true;
                 s_s_wait_n <= '0';
                 s_m_push <= '0';
            end if;

        end if;

    end process main_process_on_clock;

    p_s_wait_n <= s_s_wait_n;
    p_m_push <= s_m_push;
    p_m_data <= s_m_data;

end architecture rtl;
