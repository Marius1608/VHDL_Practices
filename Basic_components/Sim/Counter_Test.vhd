library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Counter_Test is
end Counter_Test;


architecture Behavioral of  Counter_Test is
    component Counter
        Port (
            Clk: in std_logic;
            Counter: out std_logic_vector(3 downto 0);
            Reset: in std_logic
             );
    end component;

    signal Clk: std_logic := '0';
    signal Reset: std_logic := '0';
    signal Counter_Test: std_logic_vector(3 downto 0);

begin
    Test: Counter port map (Clk=>Clk,Counter=>Counter_Test,Reset=>Reset);
    Clk_process: process
    begin
        while true loop
            Clk <= '0'; wait for 20 ns;
            Clk <= '1'; wait for 20 ns;
        end loop;
    end process;

    Sim: process
    begin
        Reset <= '1'; wait for 20 ns;
        Reset <= '0'; wait for 20 ns;
        wait for 100 ns; 
        Reset <= '1'; wait for 20 ns;
        Reset <= '0'; wait for 20 ns;
        wait;
    end process;
end Behavioral;
