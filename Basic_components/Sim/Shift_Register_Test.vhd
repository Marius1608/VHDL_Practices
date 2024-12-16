library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Shift_Register_Test is
end Shift_Register_Test;


architecture Behavioral of  Shift_Register_Test is
    component Shift_Register
        port (
            A: in unsigned(7 downto 0);
            Mode: in unsigned(1 downto 0);
            B: out unsigned(7 downto 0)
        );
    end component;

    signal A: unsigned(7 downto 0) := (others => '0');
    signal Mode: unsigned(1 downto 0) := "00";
    signal B: unsigned(7 downto 0);

begin
    Test:Shift_Register port map (A=>A,Mode=>Mode,B=>B);
    Clk_process: process
    begin
        A <= "00000011"; Mode <= "00"; wait for 20 ns;
        A <= "00000011"; Mode <= "01"; wait for 20 ns;
        A <= "00000011"; Mode <= "10"; wait for 20 ns;
        A <= "00000011"; Mode <= "11"; wait for 20 ns;
        wait;
    end process;
end Behavioral;
