library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX_4_1 is
       Port( 
          A,B,C,D:in std_logic;
          Mode:in std_logic_vector(1 downto 0);  
          Out_Mux:out std_logic 
         );
end MUX_4_1;


architecture Behavioral of MUX_4_1 is
begin
    with Mode select
        Out_Mux<=A when "00",
                 B when "01",
                 C when "10",
                 D when "11",
                 'X'when others;
end Behavioral;
