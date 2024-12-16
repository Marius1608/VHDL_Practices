library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity memory_matrix_tb is
end memory_matrix_tb;


architecture behavioral of memory_matrix_tb is
    component memory_matrix is
        port (
            clk     : in std_logic;
            address : in std_logic_vector(16 downto 0);
            data    : inout std_logic_vector(15 downto 0);
            bhe_n   : in std_logic;
            sel     : in std_logic_vector(7 downto 0);
            wr_n    : in std_logic
        );
    end component;

    -- Test signals
    signal clk     : std_logic := '0';
    signal address : std_logic_vector(16 downto 0) := (others => '0');
    signal data    : std_logic_vector(15 downto 0) := (others => 'Z');
    signal bhe_n   : std_logic := '1';
    signal sel     : std_logic_vector(7 downto 0) := (others => '1');
    signal wr_n    : std_logic := '1';
    
    constant clk_period : time := 10 ns;
begin
  
    test: memory_matrix port map (
        clk => clk,
        address => address,
        data => data,
        bhe_n => bhe_n,
        sel => sel,
        wr_n => wr_n
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

        report "Test Case 1: Writing to first memory module";
        sel <= "00000001";
        address <= "00000000000000000";
        wr_n <= '0';
        bhe_n <= '0';
        data <= x"ABCD";
        wait for clk_period * 2;

        wr_n <= '1';
        wait for clk_period * 2;
        assert data = x"ABCD" report "Read data mismatch on first module" severity error;

        report "Test Case 2: Writing to second memory module";
        sel <= "00000010";
        address <= "00000000000000100";
        data <= x"1234";
        wr_n <= '0';
        wait for clk_period * 2;

        wr_n <= '1';
        wait for clk_period * 2;
        assert data = x"1234" report "Read data mismatch on second module" severity error;
        
        wait;
    end process;
end behavioral;