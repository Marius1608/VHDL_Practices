library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WallaceTreeMultiplier is
    Port (
        A : in STD_LOGIC_VECTOR(3 downto 0); 
        B : in STD_LOGIC_VECTOR(3 downto 0); 
        P : out STD_LOGIC_VECTOR(7 downto 0)  
    );
end WallaceTreeMultiplier;

architecture Behavioral of WallaceTreeMultiplier is
    signal P0, P1, P2, P3 : STD_LOGIC_VECTOR(7 downto 0); 
    signal Sum1, Sum2 : STD_LOGIC_VECTOR(7 downto 0); 
    signal C1, C2 : STD_LOGIC_VECTOR(7 downto 0); 

    component FullAdder is
        Port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

begin
   
    P0 <= ("0000" & A) when B(0) = '1' else (others => '0'); 
    P1 <= ("000" & A & "0") when B(1) = '1' else (others => '0');  
    P2 <= ("00" & A & "00") when B(2) = '1' else (others => '0'); 
    P3 <= ("0" & A & "000") when B(3) = '1' else (others => '0'); 

    F0: FullAdder port map(P0(0), P1(0), '0', Sum1(0), C1(0));
    F1: FullAdder port map(P0(1), P1(1), C1(0), Sum1(1), C1(1));
    F2: FullAdder port map(P0(2), P1(2), C1(1), Sum1(2), C1(2));
    F3: FullAdder port map(P0(3), P1(3), C1(2), Sum1(3), C1(3));
    F4: FullAdder port map(Sum1(0), P2(0), '0', Sum2(0), C2(0));
    F5: FullAdder port map(Sum1(1), P2(1), C2(0), Sum2(1), C2(1));
    F6: FullAdder port map(Sum1(2), P2(2), C2(1), Sum2(2), C2(2));
    F7: FullAdder port map(Sum1(3), P2(3), C2(2), Sum2(3), C2(3));
    
    P <=  C2(3 downto 0) & Sum2(3 downto 0);

end Behavioral;
