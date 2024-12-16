library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity XOR_gate is
    Port( 
          A:in std_logic;
          B:in std_logic;  
          C:out std_logic 
         );
end XOR_gate;


architecture Behavioral of XOR_gate is
begin
    C<=A xor B;
end Behavioral;
