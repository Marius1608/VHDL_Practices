library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_4Biti_Test is
end CLA_4Biti_Test;

architecture Behavioral of CLA_4Biti_Test is

    signal A      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Cin    : STD_LOGIC := '0';
    signal S      : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout   : STD_LOGIC;

    component CLA_4Biti
        Port (
            A      : in  STD_LOGIC_VECTOR(3 downto 0);
            B      : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin    : in  STD_LOGIC;
            S      : out STD_LOGIC_VECTOR(3 downto 0);
            Cout   : out STD_LOGIC
        );
    end component;

begin
    Test: CLA_4Biti Port Map (A => A,B => B,Cin => Cin,S => S,Cout => Cout);  
    Sim: process
    begin
      
        A <= "0000"; B <= "0000"; Cin <= '0';
        wait for 20 ns;

        A <= "0001"; B <= "0001"; Cin <= '0';
        wait for 20 ns;

        A <= "0101"; B <= "0101"; Cin <= '1';
        wait for 20 ns;
     
        A <= "1111"; B <= "0001"; Cin <= '0';
        wait for 20 ns;

        A <= "0110"; B <= "1001"; Cin <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
