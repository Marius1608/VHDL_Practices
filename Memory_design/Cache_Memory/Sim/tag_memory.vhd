library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity tag_memory_tb is
end tag_memory_tb;


architecture behavioral of tag_memory_tb is
    component tag_memory is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            write_en : in std_logic;
            index    : in std_logic_vector(12 downto 0);
            tag_in   : in std_logic_vector(13 downto 0);
            tag_out  : out std_logic_vector(13 downto 0);
            valid    : out std_logic
        );
    end component;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal write_en : std_logic := '0';
    signal index    : std_logic_vector(12 downto 0) := (others => '0');
    signal tag_in   : std_logic_vector(13 downto 0) := (others => '0');
    signal tag_out  : std_logic_vector(13 downto 0);
    signal valid    : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    test: tag_memory
        port map (
            clk      => clk,
            reset    => reset,
            write_en => write_en,
            index    => index,
            tag_in   => tag_in,
            tag_out  => tag_out,
            valid    => valid
        );

    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
    
        wait for CLK_PERIOD * 2;
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD * 2;
        
        report "Test 1: Write and Read First Location";
        index <= (others => '0');
        tag_in <= "10101010101010";
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert valid = '1' report "Expected valid bit to be set" severity error;
        assert tag_out = "10101010101010" report "Incorrect tag read" severity error;

        report "Test 2: Write and Read Last Location";
        index <= (others => '1');
        tag_in <= "01010101010101";
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert valid = '1' report "Expected valid bit to be set" severity error;
        assert tag_out = "01010101010101" report "Incorrect tag read" severity error;
        
        report "Test 3: Read After Reset";
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        assert valid = '0' report "Expected valid bit to be cleared after reset" severity error;

        report "Test 4: Multiple Writes to Same Location";
        index <= "0000000000001";
        tag_in <= "11111111111111";
        write_en <= '1';
        wait for CLK_PERIOD;
        tag_in <= "00000000000000";
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert tag_out = "00000000000000" report "Incorrect tag after multiple writes" severity error;

        report "Test completed successfully";
        wait;
    end process;

end behavioral;