library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity D_Flip_Flop is
    Port (
          D: in std_logic;
          Clk: in std_logic;
          Q: out std_logic;
          Q_neg: out std_logic
         );
end D_Flip_Flop;


architecture Behavioral of D_Flip_Flop is
signal Tmp: std_logic;
begin
    process(Clk)
    begin
        if rising_edge(Clk)then
            Tmp<=D;
         end if;
     end process;        
Q<=Tmp;
Q_neg<=Tmp;
end Behavioral;
