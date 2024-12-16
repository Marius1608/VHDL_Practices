library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity buffer_245 is
    port (
        a    : inout std_logic_vector(7 downto 0);
        b    : inout std_logic_vector(7 downto 0);
        dir  : in std_logic;    
        cs_n : in std_logic     
    );
end buffer_245;


architecture behavioral of buffer_245 is
    signal a_to_b : std_logic_vector(7 downto 0);
    signal b_to_a : std_logic_vector(7 downto 0);
begin
    
    a_to_b <= a;
    b_to_a <= b;
    
    b <= a_to_b when (cs_n = '0' and dir = '1') else (others => 'Z');
    a <= b_to_a when (cs_n = '0' and dir = '0') else (others => 'Z');
end behavioral;