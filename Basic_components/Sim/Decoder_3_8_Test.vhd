library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder_3_8_Test is
end Decoder_3_8_Test;


architecture Behavioral of Decoder_3_8_Test is
    component Decoder_3_8
        Port (
            A: in std_logic_vector(2 downto 0);
            D: out std_logic_vector(7 downto 0)
        );
    end component;

    signal A: std_logic_vector(2 downto 0) := "000";
    signal D: std_logic_vector(7 downto 0);

begin
    Test: Decoder_3_8 port map (A => A, D => D);
    Sim: process
    begin
        A <= "000"; wait for 20 ns;
        A <= "001"; wait for 20 ns;
        A <= "010"; wait for 20 ns;
        A <= "011"; wait for 20 ns;
        A <= "100"; wait for 20 ns;
        A <= "101"; wait for 20 ns;
        A <= "110"; wait for 20 ns;
        A <= "111"; wait for 20 ns;
        wait;
    end process;
end Behavioral;
