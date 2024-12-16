library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Demux_1_4_Test is
end Demux_1_4_Test;


architecture Behavioral of Demux_1_4_Test is
    component Demux_1_4
        Port (
            A: in std_logic;         
            Mode: in std_logic_vector(1 downto 0);  
            Out0, Out1, Out2, Out3: out std_logic                  
        );
    end component;

    signal A: std_logic := '0';
    signal Mode: std_logic_vector(1 downto 0) := "00";
    signal Out0, Out1, Out2, Out3: std_logic;

begin
    Test: Demux_1_4 port map (A => A, Mode => Mode, Out0 => Out0, Out1 => Out1, Out2 => Out2, Out3 => Out3);
    Sim: process
    begin
        A <= '1'; Mode <= "00"; wait for 20 ns;
        A <= '1'; Mode <= "01"; wait for 20 ns;
        A <= '1'; Mode <= "10"; wait for 20 ns;
        A <= '1'; Mode <= "11"; wait for 20 ns;
        A <= '0'; Mode <= "00"; wait for 20 ns;
        wait;
    end process;
end Behavioral;
