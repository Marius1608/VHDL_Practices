library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder_3_8 is
      Port ( 
            A: in std_logic_vector(2 downto 0);
            D: out std_logic_vector(7 downto 0)
            );
end Decoder_3_8;


architecture Behavioral of Decoder_3_8 is
begin
    process(A)
    begin
        case A is
            when "000" => D <= "00000001";  
            when "001" => D <= "00000010";  
            when "010" => D <= "00000100";  
            when "011" => D <= "00001000";  
            when "100" => D <= "00010000";  
            when "101" => D <= "00100000";  
            when "110" => D <= "01000000"; 
            when "111" => D <= "10000000";  
            when others => D <= "00000000"; 
        end case;
    end process;
end Behavioral;
