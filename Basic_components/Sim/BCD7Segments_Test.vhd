library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BCD7Segment_Test is
end BCD7Segment_Test;


architecture Behavioral of BCD7Segment_Test is
    component BCD7Segment
        Port (
            A: in std_logic_vector(3 downto 0); 
            B: out std_logic_vector(6 downto 0)  
        );
    end component;

    signal A: std_logic_vector(3 downto 0) := (others => '0');
    signal B: std_logic_vector(6 downto 0);

begin
    Test: BCD7Segment port map (A => A, B => B);
    Sim: process
    begin
        A <= "0000"; wait for 20 ns;
        A <= "0001"; wait for 20 ns;
        A <= "0010"; wait for 20 ns;
        A <= "0011"; wait for 20 ns;
        A <= "0100"; wait for 20 ns;
        A <= "0101"; wait for 20 ns;
        A <= "0110"; wait for 20 ns;
        A <= "0111"; wait for 20 ns;
        A <= "1000"; wait for 20 ns;
        A <= "1001"; wait for 20 ns;
        A <= "1010"; wait for 20 ns;  
        wait;
    end process;
end Behavioral;
