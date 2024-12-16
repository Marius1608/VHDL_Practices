library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity saturator_window_adder is
    Generic (
        WINDOW_SIZE : integer := 5
    );
    Port ( 
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tready : OUT STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_min_tvalid : IN STD_LOGIC;
        s_axis_min_tready : OUT STD_LOGIC;
        s_axis_min_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_max_tvalid : IN STD_LOGIC;
        s_axis_max_tready : OUT STD_LOGIC;
        s_axis_max_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_sum_tvalid : OUT STD_LOGIC;
        m_axis_sum_tready : IN STD_LOGIC;
        m_axis_sum_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end saturator_window_adder;

architecture Behavioral of saturator_window_adder is
   
    signal sat_to_win_tvalid : STD_LOGIC;
    signal sat_to_win_tready : STD_LOGIC;
    signal sat_to_win_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    
    component saturator is
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_val_tvalid : IN STD_LOGIC;
            s_axis_val_tready : OUT STD_LOGIC;
            s_axis_val_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_max_tvalid : IN STD_LOGIC;
            s_axis_max_tready : OUT STD_LOGIC;
            s_axis_max_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_min_tvalid : IN STD_LOGIC;
            s_axis_min_tready : OUT STD_LOGIC;
            s_axis_min_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_result_tvalid : OUT STD_LOGIC;
            m_axis_result_tready : IN STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;
    
    component sliding_window_adder is
        Generic (
            WINDOW_SIZE : integer := 5
        );
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_val_tvalid : IN STD_LOGIC;
            s_axis_val_tready : OUT STD_LOGIC;
            s_axis_val_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_sum_tvalid : OUT STD_LOGIC;
            m_axis_sum_tready : IN STD_LOGIC;
            m_axis_sum_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;
    
begin
   
    saturator_port: saturator
    port map (
        aclk => aclk,
        s_axis_val_tvalid => s_axis_a_tvalid,
        s_axis_val_tready => s_axis_a_tready,
        s_axis_val_tdata => s_axis_a_tdata,
        s_axis_min_tvalid => s_axis_min_tvalid,
        s_axis_min_tready => s_axis_min_tready,
        s_axis_min_tdata => s_axis_min_tdata,
        s_axis_max_tvalid => s_axis_max_tvalid,
        s_axis_max_tready => s_axis_max_tready,
        s_axis_max_tdata => s_axis_max_tdata,
        m_axis_result_tvalid => sat_to_win_tvalid,
        m_axis_result_tready => sat_to_win_tready,
        m_axis_result_tdata => sat_to_win_tdata
    );
    
    
    window_port: sliding_window_adder
    generic map (
        WINDOW_SIZE => WINDOW_SIZE
    )
    port map (
        aclk => aclk,
        s_axis_val_tvalid => sat_to_win_tvalid,
        s_axis_val_tready => sat_to_win_tready,
        s_axis_val_tdata => sat_to_win_tdata,
        m_axis_sum_tvalid => m_axis_sum_tvalid,
        m_axis_sum_tready => m_axis_sum_tready,
        m_axis_sum_tdata => m_axis_sum_tdata
    );
    
end Behavioral;