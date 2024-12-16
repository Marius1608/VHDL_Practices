library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity data_memory is
    port (
        clk         : in std_logic;
        write_en    : in std_logic;
        index       : in std_logic_vector(12 downto 0);
        offset      : in std_logic_vector(4 downto 0);
        data_in     : in std_logic_vector(63 downto 0);
        data_out    : out std_logic_vector(63 downto 0);
        byte_enable : in std_logic_vector(7 downto 0):= (others => '1')  
    );
end data_memory;


architecture behavioral of data_memory is
    constant SETS           : integer := 8192;
    constant WORDS_PER_SET : integer := 4;
    constant WORD_SIZE     : integer := 64;
    
    type data_array is array (0 to SETS*WORDS_PER_SET-1) of std_logic_vector(WORD_SIZE-1 downto 0);
    signal memory : data_array := (others => (others => '0'));
    
    signal word_addr : integer;
    signal set_base_addr : integer;
    signal valid_addr : boolean;

begin
    
    valid_addr <= to_integer(unsigned(index)) < SETS and
                 to_integer(unsigned(offset(4 downto 3))) < WORDS_PER_SET;

    set_base_addr <= to_integer(unsigned(index)) * WORDS_PER_SET when valid_addr else 0;
    word_addr <= set_base_addr + to_integer(unsigned(offset(4 downto 3))) when valid_addr else 0;

    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' and valid_addr then
                for i in 0 to 7 loop
                    if byte_enable(i) = '1' then
                        memory(word_addr)(((i+1)*8-1) downto (i*8)) <= 
                            data_in(((i+1)*8-1) downto (i*8));
                    end if;
                end loop;
            end if;
        end if;
    end process;

    data_out <= memory(word_addr) when valid_addr else (others => '0');

end behavioral;