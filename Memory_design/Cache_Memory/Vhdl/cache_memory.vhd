library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cache_memory is
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
end cache_memory;


architecture structural of cache_memory is
   
    constant TAG_SIZE    : integer := 14;
    constant INDEX_SIZE  : integer := 13;
    constant OFFSET_SIZE : integer := 5;

    component tag_memory is
        port (
            clk     : in std_logic;
            reset   : in std_logic;
            write_en: in std_logic;
            index   : in std_logic_vector(12 downto 0);
            tag_in  : in std_logic_vector(13 downto 0);
            tag_out : out std_logic_vector(13 downto 0);
            valid   : out std_logic
        );
    end component;

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

    signal tag_in      : std_logic_vector(TAG_SIZE-1 downto 0);
    signal tag_out     : std_logic_vector(TAG_SIZE-1 downto 0);
    signal index       : std_logic_vector(INDEX_SIZE-1 downto 0);
    signal offset      : std_logic_vector(OFFSET_SIZE-1 downto 0);
    signal tag_write   : std_logic;
    signal data_write  : std_logic;
    signal tag_match   : std_logic;
    signal valid       : std_logic;
    signal cache_data_in : std_logic_vector(63 downto 0);

begin
    
    tag_in <= address(31 downto 18);
    index <= address(17 downto 5);
    offset <= address(4 downto 0);

    tag_match <= '1' when tag_in = tag_out and valid = '1' else '0';
    cache_data_in <= mem_data_in when tag_write = '1' else data_in;
    mem_addr <= address;
    mem_data_out <= data_in;


    tag_mem: tag_memory
        port map (
            clk      => clk,
            reset    => reset,
            write_en => tag_write,
            index    => index,
            tag_in   => tag_in,
            tag_out  => tag_out,
            valid    => valid
        );

    data_mem: data_memory
        port map (
            clk         => clk,
            write_en    => data_write,
            index       => index,
            offset      => offset,
            data_in     => cache_data_in,
            data_out    => data_out,
            byte_enable => (others => '1')
        );

    ctrl: cache_controller
        port map (
            clk        => clk,
            reset      => reset,
            read_req   => read_req,
            write_req  => write_req,
            tag_match  => tag_match,
            valid      => valid,
            mem_ready  => mem_ready,
            tag_write  => tag_write,
            data_write => data_write,
            mem_read   => mem_read,
            mem_write  => mem_write,
            hit        => hit,
            ready      => ready
        );

end structural;