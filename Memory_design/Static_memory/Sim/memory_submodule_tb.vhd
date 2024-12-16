library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity memory_submodule_tb is
end memory_submodule_tb;


architecture behavioral of memory_submodule_tb is
    component memory_submodule is
        port (
            clk     : in std_logic;
            address : in std_logic_vector(15 downto 0);
            data    : inout std_logic_vector(15 downto 0);
            cs_n    : in std_logic;
            wr_n    : in std_logic;
            bhe_n   : in std_logic
        );
    end component;

    signal clk     : std_logic := '0';
    signal address : std_logic_vector(15 downto 0) := (others => '0');
    signal data    : std_logic_vector(15 downto 0) := (others => 'Z');
    signal cs_n    : std_logic := '1';
    signal wr_n    : std_logic := '1';
    signal bhe_n   : std_logic := '1';
    
    constant clk_period : time := 10 ns;
begin
   
    test: memory_submodule port map (
        clk => clk,
        address => address,
        data => data,
        cs_n => cs_n,
        wr_n => wr_n,
        bhe_n => bhe_n
    );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;
 
        report "Test Case 1: Writing full word";
        cs_n <= '0';
        bhe_n <= '0';
        address <= x"0000";
        data <= x"ABCD";
        wr_n <= '0';
        wait for clk_period * 2;
        
        wr_n <= '1';
        data <= (others => 'Z');
        wait for clk_period * 2;
        assert data = x"ABCD" report "Full word read mismatch" severity error;
        
        report "Test Case 2: Writing high byte";
        address <= x"0002";
        bhe_n <= '0';
        data <= x"FF00";
        wr_n <= '0';
        wait for clk_period * 2;

        wr_n <= '1';
        data <= (others => 'Z');
        wait for clk_period * 2;
        assert data(15 downto 8) = x"FF" report "High byte read mismatch" severity error;
        
        wait;
    end process;
end behavioral;