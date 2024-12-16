library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX_4_1_Test is
end MUX_4_1_Test;


architecture Behavioral of MUX_4_1_Test is
    component MUX_4_1
        Port (
            A,B,C,D: in std_logic;
            Mode: in std_logic_vector(1 downto 0);
            Out_Mux: out std_logic
        );
    end component;

    signal A: std_logic := '0';
    signal B: std_logic := '0';
    signal C: std_logic := '0';
    signal D: std_logic := '0';
    signal Mode: std_logic_vector(1 downto 0) := "00";
    signal Out_Mux: std_logic;

begin
    Test: MUX_4_1 port map (A=>A, B=>B, C=>C, D=>D, Mode=>Mode, Out_Mux=>Out_Mux);
    Sim: process
    begin
        A <= '1'; B <= '0'; C <= '0'; D <= '0'; Mode <= "00"; wait for 20 ns;
        A <= '0'; B <= '1'; C <= '0'; D <= '0'; Mode <= "01"; wait for 20 ns;
        A <= '0'; B <= '0'; C <= '1'; D <= '0'; Mode <= "10"; wait for 20 ns;
        A <= '0'; B <= '0'; C <= '0'; D <= '1'; Mode <= "11"; wait for 20 ns;
        Mode <= "XX"; wait for 20 ns; 
        wait;
    end process;
end Behavioral;
