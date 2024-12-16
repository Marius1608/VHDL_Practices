library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Shift_Register is
        port (  A: in unsigned (7 downto 0);
                Mode: in unsigned (1 downto 0);
                B: out unsigned (7 downto 0));
end Shift_Register;


architecture Behavioral of Shift_Register is
begin
    with Mode select
        B <= A  sll 1 when "00",
             A  srl 1 when "01",
             A  sll 2 when "10",
             A  srl 2 when others;
end Behavioral;
