library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity WallaceTreeMultiplier_Test is
end WallaceTreeMultiplier_Test;


architecture Behavioral of WallaceTreeMultiplier_Test is

    signal A : STD_LOGIC_VECTOR(3 downto 0);
    signal B : STD_LOGIC_VECTOR(3 downto 0);
    signal P : STD_LOGIC_VECTOR(7 downto 0);

    component WallaceTreeMultiplier is
        Port (
            A : in  STD_LOGIC_VECTOR(3 downto 0); 
            B : in  STD_LOGIC_VECTOR(3 downto 0); 
            P : out STD_LOGIC_VECTOR(7 downto 0)  
        );
    end component;

begin    
    Test: WallaceTreeMultiplier port map (A => A,B => B,P => P);
    process
    begin
        
        A <= "0110"; B <= "0110"; 
        wait for 20 ns;
      
        A <= "0011";  B <= "0011";  
        wait for 20 ns;
        
        A <= "0010";  B <= "0011"; 
        wait for 20 ns;
        
        A <= "0100";  B <= "0101";  
        wait for 20 ns;
        
        A <= "0111";  B <= "0101";  
        wait for 20 ns;
     
        A <= "0000";  B <= "0000";  
        wait for 20 ns;
      
        A <= "0001";  B <= "0001"; 
        wait for 20 ns;
     
        A <= "0010";  B <= "0010";  
        wait for 20 ns;

     
        wait;  
    end process;

end Behavioral;
