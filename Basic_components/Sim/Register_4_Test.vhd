library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Register_4_Test is
end Register_4_Test;


architecture Behavioral of Register_4_Test is
    component Register_4
        Port (
            D: in std_logic_vector(3 downto 0);
            Clk: in std_logic;
            Q: out std_logic_vector(3 downto 0);
            Q_neg: out std_logic_vector(3 downto 0)
        );
    end component;

    signal D: std_logic_vector(3 downto 0) := "0000";
    signal Clk: std_logic := '0';
    signal Q: std_logic_vector(3 downto 0);
    signal Q_neg: std_logic_vector(3 downto 0);

begin
    Test: Register_4 port map (D=>D,Clk=>Clk,Q=>Q,Q_neg=>Q_neg);
    Clk_process: process
    begin
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end process;

    Sim: process
    begin
        D <= "0001"; wait for 20 ns;
        D <= "0010"; wait for 20 ns;
        D <= "0011"; wait for 20 ns;
        D <= "0100"; wait for 20 ns;
        D <= "0101"; wait for 20 ns;
        wait;
    end process;
end Behavioral;
