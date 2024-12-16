library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BCD7Segment is
    Port (
        A: in std_logic_vector(3 downto 0); 
        B: out std_logic_vector(6 downto 0)  
    );
end BCD7Segment;


architecture Behavioral of BCD7Segment is
begin
    process(A)
    begin
        case A is
            when "0000" => B <= "0000001"; 
            when "0001" => B <= "1001111"; 
            when "0010" => B <= "0010010"; 
            when "0011" => B <= "0000110"; 
            when "0100" => B <= "1001100"; 
            when "0101" => B <= "0100100"; 
            when "0110" => B <= "0100000"; 
            when "0111" => B <= "0001111"; 
            when "1000" => B <= "0000000"; 
            when "1001" => B <= "0000100"; 
            when others => B <= "1111111"; 
        end case;
    end process;
end Behavioral;
