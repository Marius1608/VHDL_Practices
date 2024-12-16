library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity max_calculator_tb is
end max_calculator_tb;

architecture Behavioral of max_calculator_tb is
    signal aclk : std_logic := '0';
    signal s_axis_val_tvalid : std_logic := '0';
    signal s_axis_val_tready : std_logic;
    signal s_axis_val_tdata : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_result_tvalid : std_logic;
    signal m_axis_result_tready : std_logic := '0';
    signal m_axis_result_tdata : std_logic_vector(31 downto 0);
    
   
begin
    
    comp: entity work.max_calculator
        port map (
            aclk => aclk,
            s_axis_val_tvalid => s_axis_val_tvalid,
            s_axis_val_tready => s_axis_val_tready,
            s_axis_val_tdata => s_axis_val_tdata,
            m_axis_result_tvalid => m_axis_result_tvalid,
            m_axis_result_tready => m_axis_result_tready,
            m_axis_result_tdata => m_axis_result_tdata
        );

    clk_sim: process
    begin
        aclk <= '0';
        wait for 20 ns;
        aclk <= '1';
        wait for 20 ns;
    end process;

    sim: process
    begin
    
        wait for 100 ns;
        
        s_axis_val_tdata <= std_logic_vector(to_signed(100, 32));
        s_axis_val_tvalid <= '1';
        m_axis_result_tready <= '1';
        wait for 20 ns;
        s_axis_val_tvalid <= '0';
        wait for 20 ns;
       
        wait for 100 ns;
        s_axis_val_tdata <= std_logic_vector(to_signed(-50, 32));
        s_axis_val_tvalid <= '1';
        wait for 20 ns;
        s_axis_val_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_val_tdata <= (others => '0');
        s_axis_val_tvalid <= '1';
        wait for 20 ns;
        s_axis_val_tvalid <= '0';
        wait for 20 ns;
        
        wait;
    end process;
end Behavioral;