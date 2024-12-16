library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tag_memory is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        write_en: in std_logic;
        index   : in std_logic_vector(12 downto 0);
        tag_in  : in std_logic_vector(13 downto 0);
        tag_out : out std_logic_vector(13 downto 0);
        valid   : out std_logic
    );
end tag_memory;


architecture behavioral of tag_memory is
    type tag_array is array (0 to 8191) of std_logic_vector(14 downto 0); 
    signal tags : tag_array := (others => (others => '0'));
    signal addr_int : integer;
begin
    addr_int <= to_integer(unsigned(index));

    process(clk, reset)
    begin
        if reset = '1' then
            tags <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if write_en = '1' then
                tags(addr_int) <= '1' & tag_in;  
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            tag_out <= tags(addr_int)(13 downto 0);
            valid <= tags(addr_int)(14);
        end if;
    end process;
end behavioral;