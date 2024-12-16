library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CLA_4Biti is
    Port (
        A      : in  STD_LOGIC_VECTOR(3 downto 0); 
        B      : in  STD_LOGIC_VECTOR(3 downto 0); 
        Cin    : in  STD_LOGIC;                    
        S      : out STD_LOGIC_VECTOR(3 downto 0); 
        Cout    : out STD_LOGIC                     
    );
end CLA_4Biti;


architecture Structural of CLA_4Biti is

    signal G : STD_LOGIC_VECTOR(3 downto 0); 
    signal P : STD_LOGIC_VECTOR(3 downto 0); 
    signal C : STD_LOGIC_VECTOR(4 downto 0); 
    
    component FullAdder is
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            Cin    : in  STD_LOGIC;
            S      : out STD_LOGIC;
            Cout    : out STD_LOGIC
        );
    end component;

    component CarryBlock is
        Port (
            G      : in  STD_LOGIC_VECTOR(3 downto 0);
            P      : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin    : in  STD_LOGIC;
            C      : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

begin

    F0: FullAdder port map(A(0), B(0), Cin, S(0), G(0));
    F1: FullAdder port map(A(1), B(1), C(1), S(1), G(1));
    F2: FullAdder port map(A(2), B(2), C(2), S(2), G(2));
    F3: FullAdder port map(A(3), B(3), C(3), S(3), G(3));
    P(0) <= A(0) XOR B(0);
    P(1) <= A(1) XOR B(1);
    P(2) <= A(2) XOR B(2);
    P(3) <= A(3) XOR B(3);
    CB: CarryBlock port map(G, P, Cin, C);
    Cout <= C(4);

end Structural;
