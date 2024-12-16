library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity memory_module_tb is
end memory_module_tb;


architecture behavioral of memory_module_tb is
    component memory_module
        port (
            address     : in std_logic_vector(23 downto 0);
            data        : inout std_logic_vector(15 downto 0);
            rd_n        : in std_logic;
            wr_n        : in std_logic;
            bhe_n       : in std_logic;
            clk         : in std_logic
        );
    end component;
    
   
    signal address   : std_logic_vector(23 downto 0) := (others => '0');
    signal data      : std_logic_vector(15 downto 0) := (others => 'Z');
    signal rd_n      : std_logic := '1';
    signal wr_n      : std_logic := '1';
    signal bhe_n     : std_logic := '1';
    signal clk       : std_logic := '0';
    
    signal test_pass : boolean := true;
    signal expected_data : std_logic_vector(15 downto 0);
    signal read_data_val : std_logic_vector(15 downto 0);
    
    constant clk_period : time := 10 ns;
    
    procedure write_data(
        signal addr : out std_logic_vector(23 downto 0);
        signal data_bus : inout std_logic_vector(15 downto 0);
        signal write_n : out std_logic;
        signal byte_enable_n : out std_logic;
        constant write_addr : in std_logic_vector(23 downto 0);
        constant write_data : in std_logic_vector(15 downto 0);
        constant use_byte_enable : in boolean := true;
        signal test_status : out boolean) is
        
        variable msg_line : line;
    begin
        
        wait until rising_edge(clk);
        addr <= write_addr;
        if use_byte_enable then
            byte_enable_n <= '0';
        else
            byte_enable_n <= '1';
        end if;
        
        wait until rising_edge(clk);
        write_n <= '0';
        data_bus <= write_data;
        
        wait for clk_period * 2;
        
        write_n <= '1';
        data_bus <= (others => 'Z');
        
        write(msg_line, string'("Write operation at address: 0x"));
        hwrite(msg_line, write_addr);
        write(msg_line, string'(" with data: 0x"));
        hwrite(msg_line, write_data);
        writeline(output, msg_line);
        
        wait for clk_period;
    end procedure;
    
   
    procedure read_data(
        signal addr : out std_logic_vector(23 downto 0);
        signal read_n : out std_logic;
        signal byte_enable_n : out std_logic;
        signal data_bus : in std_logic_vector(15 downto 0);
        constant read_addr : in std_logic_vector(23 downto 0);
        constant expected : in std_logic_vector(15 downto 0);
        constant use_byte_enable : in boolean := true;
        signal test_status : out boolean;
        signal read_value : out std_logic_vector(15 downto 0)) is
        
        variable msg_line : line;
    begin
        
        wait until rising_edge(clk);
        addr <= read_addr;
        if use_byte_enable then
            byte_enable_n <= '0';
        else
            byte_enable_n <= '1';
        end if;
        
        wait until rising_edge(clk);
        read_n <= '0';
        
        wait for clk_period * 2;
        read_value <= data_bus;  
        
        if data_bus /= expected then
            test_status <= false;
            write(msg_line, string'("ERROR at address 0x"));
            hwrite(msg_line, read_addr);
            write(msg_line, string'(" - Expected: 0x"));
            hwrite(msg_line, expected);
            write(msg_line, string'(" Got: 0x"));
            hwrite(msg_line, data_bus);
            writeline(output, msg_line);
        else
            write(msg_line, string'("SUCCESS - Read correct data 0x"));
            hwrite(msg_line, data_bus);
            write(msg_line, string'(" from address 0x"));
            hwrite(msg_line, read_addr);
            writeline(output, msg_line);
        end if;
        
        read_n <= '1';
        wait for clk_period;
    end procedure;
    
begin
    
    test: memory_module port map (
        address => address,
        data    => data,
        rd_n    => rd_n,
        wr_n    => wr_n,
        bhe_n   => bhe_n,
        clk     => clk
    );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
        stim_proc: process
        variable msg_line : line;
    begin
        
        wait for 100 ns;

        report "Test case 1: Writing and verifying 0xABCD to address 0x000000";
        write_data(address, data, wr_n, bhe_n, x"000000", x"ABCD", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"000000", x"ABCD", true, test_pass, read_data_val);
        
        report "Test case 2: Writing and verifying 0x1234 to address 0x200000";
        write_data(address, data, wr_n, bhe_n, x"200000", x"1234", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"200000", x"1234", true, test_pass, read_data_val);
        
        report "Test case 3: Writing and verifying 0xFF00 with byte enable to address 0x000100";
        write_data(address, data, wr_n, bhe_n, x"000100", x"FF00", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"000100", x"FF00", true, test_pass, read_data_val);
       
        report "Test case 4: Sequential writes and verifies";
        write_data(address, data, wr_n, bhe_n, x"000200", x"5555", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"000200", x"5555", true, test_pass, read_data_val);
        
        write_data(address, data, wr_n, bhe_n, x"000202", x"AAAA", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"000202", x"AAAA", true, test_pass, read_data_val);
        
        write_data(address, data, wr_n, bhe_n, x"000204", x"3333", true, test_pass);
        wait for clk_period * 2;
        read_data(address, rd_n, bhe_n, data, x"000204", x"3333", true, test_pass, read_data_val);
        

        if test_pass then
            report "TEST PASSED";
        else
            report "TEST FAILED";
        end if;
        
        wait;
    end process;

end behavioral;