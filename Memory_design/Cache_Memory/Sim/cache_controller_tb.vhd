library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity cache_controller_tb is
end cache_controller_tb;


architecture behavioral of cache_controller_tb is
   
    component cache_controller is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            read_req    : in std_logic;
            write_req   : in std_logic;
            tag_match   : in std_logic;
            valid       : in std_logic;
            mem_ready   : in std_logic;
            tag_write   : out std_logic;
            data_write  : out std_logic;
            mem_read    : out std_logic;
            mem_write   : out std_logic;
            hit         : out std_logic;
            ready       : out std_logic
        );
    end component;

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal read_req    : std_logic := '0';
    signal write_req   : std_logic := '0';
    signal tag_match   : std_logic := '0';
    signal valid       : std_logic := '0';
    signal mem_ready   : std_logic := '0';
    signal tag_write   : std_logic;
    signal data_write  : std_logic;
    signal mem_read    : std_logic;
    signal mem_write   : std_logic;
    signal hit         : std_logic;
    signal ready       : std_logic;
    
    constant CLK_PERIOD : time := 10 ns;

begin
   
    test: cache_controller
        port map (
            clk         => clk,
            reset       => reset,
            read_req    => read_req,
            write_req   => write_req,
            tag_match   => tag_match,
            valid       => valid,
            mem_ready   => mem_ready,
            tag_write   => tag_write,
            data_write  => data_write,
            mem_read    => mem_read,
            mem_write   => mem_write,
            hit         => hit,
            ready      => ready
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

        report "Test 1: Cache Hit on Read";
        read_req <= '1';
        tag_match <= '1';
        valid <= '1';
        wait for CLK_PERIOD;
        assert hit = '1' report "Expected cache hit" severity error;
        read_req <= '0';
        tag_match <= '0';
        valid <= '0';
        wait for CLK_PERIOD * 2;

        report "Test 2: Cache Miss on Read";
        read_req <= '1';
        wait until mem_read = '1';
        wait for CLK_PERIOD * 2;
        mem_ready <= '1';
        wait for CLK_PERIOD;
        mem_ready <= '0';
        read_req <= '0';
        wait for CLK_PERIOD * 2;

        report "Test 3: Cache Hit on Write";
        write_req <= '1';
        tag_match <= '1';
        valid <= '1';
        wait for CLK_PERIOD;
        assert data_write = '1' report "Expected data write" severity error;
        write_req <= '0';
        tag_match <= '0';
        valid <= '0';
        wait for CLK_PERIOD * 2;

        report "Test 4: Cache Miss on Write with Write-Back";
        write_req <= '1';
        wait until mem_write = '1';
        wait for CLK_PERIOD * 2;
        mem_ready <= '1';
        wait for CLK_PERIOD;
        mem_ready <= '0';
        wait until mem_read = '1';
        wait for CLK_PERIOD * 2;
        mem_ready <= '1';
        wait for CLK_PERIOD;
        mem_ready <= '0';
        write_req <= '0';
        wait for CLK_PERIOD * 2;

        report "Test completed successfully";
        wait;
    end process;

end behavioral;