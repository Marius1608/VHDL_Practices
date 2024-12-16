library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity decoder_tb is
end decoder_tb;


architecture behavioral of decoder_tb is
    component decoder is
        port (
            address      : in std_logic_vector(23 downto 17);
            rd_n         : in std_logic;
            wr_n         : in std_logic;
            sel_module_n : out std_logic_vector(7 downto 0)
        );
    end component;

    signal address      : std_logic_vector(23 downto 17) := (others => '0');
    signal rd_n         : std_logic := '1';
    signal wr_n         : std_logic := '1';
    signal sel_module_n : std_logic_vector(7 downto 0);

begin
   
    test: decoder port map (
        address => address,
        rd_n => rd_n,
        wr_n => wr_n,
        sel_module_n => sel_module_n
    );

    stim_proc: process
    begin
        wait for 100 ns;
  
        report "Test Case 1: Address below start address";
        address <= "0000000";
        rd_n <= '0';
        wait for 10 ns;
        assert sel_module_n = "11111111" report "Invalid selection for address below start" severity error;

        report "Test Case 2: Valid address with read";
        address <= "0100000"; 
        rd_n <= '0';
        wait for 10 ns;
        assert sel_module_n = "11111110" report "Invalid module selection" severity error;

        report "Test Case 3: Different module selection";
        address <= "0100001";
        wr_n <= '0';
        rd_n <= '1';
        wait for 10 ns;
        assert sel_module_n = "11111110" report "Invalid module selection" severity error;
        
        wait;
    end process;
end behavioral;