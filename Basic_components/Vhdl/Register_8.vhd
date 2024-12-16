library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Register_4 is
    Port (
          D: in std_logic_vector(3 downto 0);
          Clk: in std_logic;
          Q: out std_logic_vector(3 downto 0);
          Q_neg: out std_logic_vector(3 downto 0)
         );
end Register_4;


architecture Behavioral of Register_4 is
signal Tmp: std_logic_vector(3 downto 0);
begin
    process(Clk)
    begin
        if rising_edge(Clk)then
            Tmp<=D;
         end if;
     end process;        
Q<=Tmp;
Q_neg<=not Tmp;
end Behavioral;
