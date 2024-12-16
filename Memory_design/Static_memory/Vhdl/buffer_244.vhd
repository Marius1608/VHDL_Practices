library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity buffer_244 is
    port (
        input   : in std_logic_vector(7 downto 0);
        output  : out std_logic_vector(7 downto 0);
        g0_n    : in std_logic;  
        g1_n    : in std_logic   
    );
end buffer_244;


architecture behavioral of buffer_244 is
begin
    output <= input when (g0_n = '0' and g1_n = '0') else (others => 'Z');
end behavioral;