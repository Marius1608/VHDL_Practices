library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity amplification_circuit_tb is
end amplification_circuit_tb;


architecture behavioral of amplification_circuit_tb is
    component amplification_circuit is
        port (
            sa          : in std_logic_vector(16 downto 0);
            sbhe_n      : in std_logic;
            ma          : out std_logic_vector(16 downto 0);
            mbhe_n      : out std_logic;
            sd          : inout std_logic_vector(15 downto 0);
            md          : inout std_logic_vector(15 downto 0);
            rd_n        : in std_logic;
            wr_n        : in std_logic;
            sel_module_n: in std_logic
        );
    end component;

    signal sa          : std_logic_vector(16 downto 0) := (others => '0');
    signal sbhe_n      : std_logic := '1';
    signal ma          : std_logic_vector(16 downto 0);
    signal mbhe_n      : std_logic;
    signal sd          : std_logic_vector(15 downto 0) := (others => 'Z');
    signal md          : std_logic_vector(15 downto 0) := (others => 'Z');
    signal rd_n        : std_logic := '1';
    signal wr_n        : std_logic := '1';
    signal sel_module_n: std_logic := '1';

begin
    
    test: amplification_circuit port map (
        sa => sa,
        sbhe_n => sbhe_n,
        ma => ma,
        mbhe_n => mbhe_n,
        sd => sd,
        md => md,
        rd_n => rd_n,
        wr_n => wr_n,
        sel_module_n => sel_module_n
    );

    stim_proc: process
    begin
        wait for 100 ns;
   
        report "Test Case 1: Testing address buffering";
        sa <= "11111000000000000";
        sbhe_n <= '0';
        wait for 10 ns;
        assert ma = sa report "Address buffering failed" severity error;
        assert mbhe_n = '0' report "BHE buffering failed" severity error;

        report "Test Case 2: Testing write operation";
        wr_n <= '0';
        sel_module_n <= '0';
        sd <= x"ABCD";
        wait for 10 ns;
        assert md = x"ABCD" report "Write data buffering failed" severity error;
   
        report "Test Case 3: Testing read operation";
        wr_n <= '1';
        rd_n <= '0';
        md <= x"1234";
        wait for 10 ns;
        assert sd = x"1234" report "Read data buffering failed" severity error;
        
        wait;
    end process;
end behavioral;