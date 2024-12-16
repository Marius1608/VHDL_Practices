library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity D_Flip_Flop_test is
end D_Flip_Flop_test;


architecture Behavioral of D_Flip_Flop_test is
    component D_Flip_Flop
        Port (  D: in std_logic; 
                Clk: in std_logic; 
                Q: out std_logic; 
                Q_neg: out std_logic);
    end component;

    signal D: std_logic := '0';
    signal Clk: std_logic := '0';
    signal Q, Q_neg: std_logic;
    

begin
    Test: D_Flip_Flop port map (D => D, Clk => Clk, Q => Q, Q_neg => Q_neg);
    Clk_process: process
    begin
        Clk <= '0';
        wait for 10ns;
        Clk <= '1';
        wait for 10ns;
    end process;

    Sim: process
    begin
        D <= '0'; wait for 20 ns;
        D <= '1'; wait for 20 ns;
        D <= '0'; wait for 20 ns;
        D <= '1'; wait for 20 ns;
        wait;
    end process;
end Behavioral;
