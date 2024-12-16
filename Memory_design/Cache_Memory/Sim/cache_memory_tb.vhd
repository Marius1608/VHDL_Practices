library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity cache_memory_tb is
end cache_memory_tb;


architecture behavioral of cache_memory_tb is
    
    component cache_memory is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            address     : in std_logic_vector(31 downto 0);
            data_in     : in std_logic_vector(63 downto 0);
            data_out    : out std_logic_vector(63 downto 0);
            read_req    : in std_logic;
            write_req   : in std_logic;
            hit         : out std_logic;
            ready       : out std_logic;
            mem_addr    : out std_logic_vector(31 downto 0);
            mem_data_in : in std_logic_vector(63 downto 0);
            mem_data_out: out std_logic_vector(63 downto 0);
            mem_read    : out std_logic;
            mem_write   : out std_logic;
            mem_ready   : in std_logic
        );
    end component;
    

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal address     : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in     : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out    : std_logic_vector(63 downto 0);
    signal read_req    : std_logic := '0';
    signal write_req   : std_logic := '0';
    signal hit         : std_logic;
    signal ready       : std_logic;
    signal mem_addr    : std_logic_vector(31 downto 0);
    signal mem_data_in : std_logic_vector(63 downto 0) := (others => '0');
    signal mem_data_out: std_logic_vector(63 downto 0);
    signal mem_read    : std_logic;
    signal mem_write   : std_logic;
    signal mem_ready   : std_logic := '0';

    constant CLK_PERIOD : time := 10 ns;
    signal test_phase : integer := 0;
    
begin
    
    test: cache_memory 
        port map (
            clk          => clk,
            reset        => reset,
            address      => address,
            data_in      => data_in,
            data_out     => data_out,
            read_req     => read_req,
            write_req    => write_req,
            hit          => hit,
            ready        => ready,
            mem_addr     => mem_addr,
            mem_data_in  => mem_data_in,
            mem_data_out => mem_data_out,
            mem_read     => mem_read,
            mem_write    => mem_write,
            mem_ready    => mem_ready
        );

    process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    process
        procedure wait_and_check(cycles : integer) is
        begin
            for i in 1 to cycles loop
                wait until rising_edge(clk);
            end loop;
        end procedure;
    begin
        
        wait for CLK_PERIOD * 2;
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD * 2;
        
       
        test_phase <= 1;
        report "Test Phase 1: Cache Miss (Read)";
        address <= x"00000100";
        read_req <= '1';
        
        wait until mem_read = '1';
        wait_and_check(2);
        mem_ready <= '1';
        mem_data_in <= x"1111111111111111";
        wait_and_check(2);
        mem_ready <= '0';
        wait until ready = '1';
        read_req <= '0';
        
        wait_and_check(4);
        
        test_phase <= 2;
        report "Test Phase 2: Cache Hit (Read)";
        read_req <= '1';
        wait_and_check(2);
        if hit = '1' then
            report "Cache hit successful";
        else
            report "Expected cache hit" severity error;
        end if;
        if data_out = x"1111111111111111" then
            report "Data read correct";
        else
            report "Incorrect data read" severity error;
        end if;
        read_req <= '0';
        
        wait_and_check(4);
        
        test_phase <= 3;
        report "Test Phase 3: Cache Hit (Write)";
        data_in <= x"2222222222222222";
        write_req <= '1';
        wait_and_check(2);
        write_req <= '0';
        
        wait_and_check(4);
        
        test_phase <= 4;
        report "Test Phase 4: Verify Written Data";
        read_req <= '1';
        wait_and_check(2);
        if data_out = x"2222222222222222" then
            report "Write verification successful";
        else
            report "Incorrect data after write" severity error;
        end if;
        read_req <= '0';
        
        wait_and_check(4);
        
        test_phase <= 5;
        report "Test Phase 5: Cache Miss with Write-Back";
        address <= x"00001100";
        read_req <= '1';
        
        wait until mem_write = '1';
        wait_and_check(2);
        mem_ready <= '1';
        wait_and_check(2);
        mem_ready <= '0';
        
        wait until mem_read = '1';
        wait_and_check(2);
        mem_data_in <= x"3333333333333333";
        mem_ready <= '1';
        wait_and_check(2);
        mem_ready <= '0';
        wait until ready = '1';
        read_req <= '0';

        report "Test completed successfully";
        wait;
    end process;

end behavioral;