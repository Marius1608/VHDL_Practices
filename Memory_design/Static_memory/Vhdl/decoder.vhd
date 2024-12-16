library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity decoder is
    port (
        address      : in std_logic_vector(23 downto 17);
        rd_n         : in std_logic;
        wr_n         : in std_logic;
        sel_module_n : out std_logic_vector(7 downto 0)
    );
end decoder;


architecture behavioral of decoder is
    signal start_address : std_logic_vector(6 downto 0) := "0100000"; 
begin
    process(address, rd_n, wr_n)
    begin
        sel_module_n <= (others => '1'); 
        if unsigned(address) >= unsigned(start_address) then
            if (rd_n = '0' or wr_n = '0') then
                case address(19 downto 17) is
                    when "000" => sel_module_n(0) <= '0';
                    when "001" => sel_module_n(1) <= '0';
                    when "010" => sel_module_n(2) <= '0';
                    when "011" => sel_module_n(3) <= '0';
                    when "100" => sel_module_n(4) <= '0';
                    when "101" => sel_module_n(5) <= '0';
                    when "110" => sel_module_n(6) <= '0';
                    when "111" => sel_module_n(7) <= '0';
                    when others => sel_module_n <= (others => '1');
                end case;
            end if;
        end if;
    end process;
end behavioral;