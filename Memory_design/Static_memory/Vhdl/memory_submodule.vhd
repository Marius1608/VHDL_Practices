library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity memory_submodule is
    port (
        clk     : in std_logic;
        address : in std_logic_vector(15 downto 0);
        data    : inout std_logic_vector(15 downto 0);
        cs_n    : in std_logic;    
        wr_n    : in std_logic;    
        bhe_n   : in std_logic   
    );
end memory_submodule;


architecture behavioral of memory_submodule is
    type memory_array is array (0 to 65535) of std_logic_vector(7 downto 0);
    signal mem_low  : memory_array := (others => (others => '0'));
    signal mem_high : memory_array := (others => (others => '0'));
    signal data_out : std_logic_vector(15 downto 0);
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if cs_n = '0' and wr_n = '0' then  
                if bhe_n = '0' then
                    mem_high(to_integer(unsigned(address(15 downto 1) & '0'))) <= data(15 downto 8);
                end if;
                if address(0) = '0' then
                    mem_low(to_integer(unsigned(address))) <= data(7 downto 0);
                end if;
            end if;
        end if;
    end process;

  
    process(cs_n, wr_n, bhe_n, address, mem_high, mem_low)
    begin
        if cs_n = '0' and wr_n = '1' then 
            if bhe_n = '0' then
                data_out(15 downto 8) <= mem_high(to_integer(unsigned(address(15 downto 1) & '0')));
            else
                data_out(15 downto 8) <= (others => 'Z');
            end if;
            
            if address(0) = '0' then
                data_out(7 downto 0) <= mem_low(to_integer(unsigned(address)));
            else
                data_out(7 downto 0) <= (others => 'Z');
            end if;
        else
            data_out <= (others => 'Z');
        end if;
    end process;

    data <= data_out when (cs_n = '0' and wr_n = '1') else (others => 'Z');
end behavioral;