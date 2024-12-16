library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity threshold_detector_tb is
end threshold_detector_tb;

architecture Behavioral of threshold_detector_tb is
    signal aclk : std_logic := '0';
    signal s_axis_gplus_tvalid : std_logic := '0';
    signal s_axis_gplus_tready : std_logic;
    signal s_axis_gplus_tdata : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_gminus_tvalid : std_logic := '0';
    signal s_axis_gminus_tready : std_logic;
    signal s_axis_gminus_tdata : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_anomaly_tvalid : std_logic;
    signal m_axis_anomaly_tready : std_logic := '0';
    signal m_axis_anomaly_tdata : std_logic_vector(0 downto 0);
    
    constant THRESHOLD : integer := 200;
begin
    
    comp: entity work.threshold_detector
        generic map (
            THRESHOLD => THRESHOLD
        )
        port map (
            aclk => aclk,
            s_axis_gplus_tvalid => s_axis_gplus_tvalid,
            s_axis_gplus_tready => s_axis_gplus_tready,
            s_axis_gplus_tdata => s_axis_gplus_tdata,
            s_axis_gminus_tvalid => s_axis_gminus_tvalid,
            s_axis_gminus_tready => s_axis_gminus_tready,
            s_axis_gminus_tdata => s_axis_gminus_tdata,
            m_axis_anomaly_tvalid => m_axis_anomaly_tvalid,
            m_axis_anomaly_tready => m_axis_anomaly_tready,
            m_axis_anomaly_tdata => m_axis_anomaly_tdata
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
        
        s_axis_gplus_tdata <= std_logic_vector(to_signed(150, 32));
        s_axis_gminus_tdata <= std_logic_vector(to_signed(150, 32));
        s_axis_gplus_tvalid <= '1';
        s_axis_gminus_tvalid <= '1';
        m_axis_anomaly_tready <= '1';
        wait for 20 ns;
        s_axis_gplus_tvalid <= '0';
        s_axis_gminus_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_gplus_tdata <= std_logic_vector(to_signed(250, 32));
        s_axis_gminus_tdata <= std_logic_vector(to_signed(150, 32));
        s_axis_gplus_tvalid <= '1';
        s_axis_gminus_tvalid <= '1';
        wait for 20 ns;
        s_axis_gplus_tvalid <= '0';
        s_axis_gminus_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_gplus_tdata <= std_logic_vector(to_signed(150, 32));
        s_axis_gminus_tdata <= std_logic_vector(to_signed(250, 32));
        s_axis_gplus_tvalid <= '1';
        s_axis_gminus_tvalid <= '1';
        wait for 20 ns;
        s_axis_gplus_tvalid <= '0';
        s_axis_gminus_tvalid <= '0';
        wait for 20 ns;
        
        wait for 100 ns;
        s_axis_gplus_tdata <= std_logic_vector(to_signed(250, 32));
        s_axis_gminus_tdata <= std_logic_vector(to_signed(250, 32));
        s_axis_gplus_tvalid <= '1';
        s_axis_gminus_tvalid <= '1';
        wait for 20 ns;
        s_axis_gplus_tvalid <= '0';
        s_axis_gminus_tvalid <= '0';
        wait for 20 ns;
        
        wait;
    end process;
end Behavioral;