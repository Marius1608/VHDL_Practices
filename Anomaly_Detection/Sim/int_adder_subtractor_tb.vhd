library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity int_adder_subtractor_tb is
end int_adder_subtractor_tb;

architecture Behavioral of int_adder_subtractor_tb is
    signal aclk : std_logic := '0';
    signal s_axis_a_tvalid : std_logic := '0';
    signal s_axis_a_tready : std_logic;
    signal s_axis_a_tdata : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_b_tvalid : std_logic := '0';
    signal s_axis_b_tready : std_logic;
    signal s_axis_b_tdata : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_operation_tvalid : std_logic := '0';
    signal s_axis_operation_tready : std_logic;
    signal s_axis_operation_tdata : std_logic_vector(7 downto 0) := (others => '0');
    signal m_axis_result_tvalid : std_logic;
    signal m_axis_result_tready : std_logic := '0';
    signal m_axis_result_tdata : std_logic_vector(31 downto 0);
    
    
begin
    
    comp: entity work.int_adder_subtractor
        port map (
            aclk => aclk,
            s_axis_a_tvalid => s_axis_a_tvalid,
            s_axis_a_tready => s_axis_a_tready,
            s_axis_a_tdata => s_axis_a_tdata,
            s_axis_b_tvalid => s_axis_b_tvalid,
            s_axis_b_tready => s_axis_b_tready,
            s_axis_b_tdata => s_axis_b_tdata,
            s_axis_operation_tvalid => s_axis_operation_tvalid,
            s_axis_operation_tready => s_axis_operation_tready,
            s_axis_operation_tdata => s_axis_operation_tdata,
            m_axis_result_tvalid => m_axis_result_tvalid,
            m_axis_result_tready => m_axis_result_tready,
            m_axis_result_tdata => m_axis_result_tdata
        );

    clock_process: process
    begin
        aclk <= '0';
        wait for 20 ns;
        aclk <= '1';
        wait for 20 ns;
    end process;

    stim_proc: process
    begin
    
        wait for 100 ns;
        
        s_axis_a_tdata <= std_logic_vector(to_signed(100, 32));
        s_axis_b_tdata <= std_logic_vector(to_signed(50, 32));
        s_axis_operation_tdata <= "00000000";
        s_axis_a_tvalid <= '1';
        s_axis_b_tvalid <= '1';
        s_axis_operation_tvalid <= '1';
        m_axis_result_tready <= '1';
        wait for 20 ns;
        s_axis_a_tvalid <= '0';
        s_axis_b_tvalid <= '0';
        s_axis_operation_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_a_tdata <= std_logic_vector(to_signed(100, 32));
        s_axis_b_tdata <= std_logic_vector(to_signed(50, 32));
        s_axis_operation_tdata <= "00000001"; 
        s_axis_a_tvalid <= '1';
        s_axis_b_tvalid <= '1';
        s_axis_operation_tvalid <= '1';
        wait for 20 ns;
        s_axis_a_tvalid <= '0';
        s_axis_b_tvalid <= '0';
        s_axis_operation_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_a_tdata <= std_logic_vector(to_signed(-100, 32));
        s_axis_b_tdata <= std_logic_vector(to_signed(-50, 32));
        s_axis_operation_tdata <= "00000000";  
        s_axis_a_tvalid <= '1';
        s_axis_b_tvalid <= '1';
        s_axis_operation_tvalid <= '1';
        wait for 20 ns;
        s_axis_a_tvalid <= '0';
        s_axis_b_tvalid <= '0';
        s_axis_operation_tvalid <= '0';
        wait for 20 ns;
      
        wait;
    end process;
end Behavioral;