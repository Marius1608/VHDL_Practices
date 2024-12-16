library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity XOR_gate_test is
end XOR_gate_test;


architecture Behavioral of XOR_gate_test is
component XOR_gate
        port(
            A: in std_logic;
            B: in std_logic;  
            C: out std_logic 
        );
end component;

signal A,B: std_logic := '0';
signal C: std_logic;

begin
test: XOR_gate 
      port map ( A => A, B => B, C => C);
process
    begin
    A <= '0'; B <= '0'; wait for 20 ns;
    A <= '0'; B <= '1'; wait for 20 ns;   
    A <= '1'; B <= '0'; wait for 20 ns;
    A <= '1'; B <= '1'; wait for 20 ns;
    wait;
    end process;
end Behavioral;
