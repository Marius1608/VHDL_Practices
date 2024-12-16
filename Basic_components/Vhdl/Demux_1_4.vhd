library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Demux_1_4 is
    Port (
        A: in std_logic;         
        Mode: in std_logic_vector(1 downto 0);  
        Out0,Out1,Out2,Out3: out std_logic                  
    );
end Demux_1_4;


architecture Behavioral of Demux_1_4 is
begin
    process(A, Mode)
    begin
        Out0 <= '0'; Out1 <= '0'; Out2 <= '0'; Out3 <= '0';
        case Mode is
            when "00" => Out0 <= A;  
            when "01" => Out1 <= A;  
            when "10" => Out2 <= A;  
            when "11" => Out3 <= A;  
            when others => 
                Out0 <= '0'; Out1 <= '0'; Out2 <= '0'; Out3 <= '0';
        end case;
    end process;
end Behavioral;
