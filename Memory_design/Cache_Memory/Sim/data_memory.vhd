library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity data_memory_tb is
end data_memory_tb;


architecture behavioral of data_memory_tb is
    component data_memory is
        port (
            clk         : in std_logic;
            write_en    : in std_logic;
            index       : in std_logic_vector(12 downto 0);
            offset      : in std_logic_vector(4 downto 0);
            data_in     : in std_logic_vector(63 downto 0);
            data_out    : out std_logic_vector(63 downto 0);
            byte_enable : in std_logic_vector(7 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal write_en    : std_logic := '0';
    signal index       : std_logic_vector(12 downto 0) := (others => '0');
    signal offset      : std_logic_vector(4 downto 0) := (others => '0');
    signal data_in     : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out    : std_logic_vector(63 downto 0);
    signal byte_enable : std_logic_vector(7 downto 0) := (others => '1');

    constant CLK_PERIOD : time := 10 ns;

begin

    test: data_memory
        port map (
            clk         => clk,
            write_en    => write_en,
            index       => index,
            offset      => offset,
            data_in     => data_in,
            data_out    => data_out,
            byte_enable => byte_enable
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

        report "Test 1: Write and Read Full Word";
        index <= (others => '0');
        offset <= (others => '0');
        data_in <= x"1111111111111111";
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert data_out = x"1111111111111111" report "Incorrect data read" severity error;

        report "Test 2: Byte Enable Testing";
        index <= "0000000000001";
        data_in <= x"2222222222222222";
        byte_enable <= "10101010";  
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;

        report "Test 3: Different Offsets";
        index <= "0000000000010";
        offset <= "00100"; 
        data_in <= x"3333333333333333";
        byte_enable <= (others => '1');
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert data_out = x"3333333333333333" report "Incorrect data read at offset" severity error;

        report "Test 4: Write to Last Location";
        index <= (others => '1');
        offset <= (others => '1');
        data_in <= x"FFFFFFFFFFFFFFFF";
        write_en <= '1';
        wait for CLK_PERIOD;
        write_en <= '0';
        wait for CLK_PERIOD;
        assert data_out = x"FFFFFFFFFFFFFFFF" report "Incorrect data read at last location" severity error;

        report "Test completed successfully";
        wait;
    end process;

end behavioral;