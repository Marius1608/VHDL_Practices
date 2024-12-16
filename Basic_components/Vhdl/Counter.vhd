library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Counter is
    Port(
         Clk: in std_logic;
         Counter: out std_logic_vector(3 downto 0);
         Reset: in std_logic
        );
end Counter;


architecture Behavioral of Counter is
signal Cnt: std_logic_vector(3 downto 0);
begin
process(Clk)
    begin
        if(rising_edge(Clk)) then 
            if Reset='1' then
                cnt<="0000";
            else
                cnt<=cnt+1;
            end if;
         end if;    
    end process;
Counter<=Cnt;
end Behavioral;
