library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity saturator_window_adder_test is
end saturator_window_adder_test;

architecture Behavioral of saturator_window_adder_test is
   
    constant WINDOW_SIZE : integer := 5;
    
    component saturator_window_adder is
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
    end component;
    
    signal aclk : STD_LOGIC := '0';
    signal s_axis_a_tvalid : STD_LOGIC := '0';
    signal s_axis_a_tready : STD_LOGIC;
    signal s_axis_a_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal s_axis_min_tvalid : STD_LOGIC := '0';
    signal s_axis_min_tready : STD_LOGIC;
    signal s_axis_min_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal s_axis_max_tvalid : STD_LOGIC := '0';
    signal s_axis_max_tready : STD_LOGIC;
    signal s_axis_max_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal m_axis_sum_tvalid : STD_LOGIC;
    signal m_axis_sum_tready : STD_LOGIC := '0';
    signal m_axis_sum_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
 
    signal sim_done : boolean := false;
    
begin
    
    Init: saturator_window_adder
    generic map (
        WINDOW_SIZE => WINDOW_SIZE
    )
    port map (
        aclk => aclk,
        s_axis_a_tvalid => s_axis_a_tvalid,
        s_axis_a_tready => s_axis_a_tready,
        s_axis_a_tdata => s_axis_a_tdata,
        s_axis_min_tvalid => s_axis_min_tvalid,
        s_axis_min_tready => s_axis_min_tready,
        s_axis_min_tdata => s_axis_min_tdata,
        s_axis_max_tvalid => s_axis_max_tvalid,
        s_axis_max_tready => s_axis_max_tready,
        s_axis_max_tdata => s_axis_max_tdata,
        m_axis_sum_tvalid => m_axis_sum_tvalid,
        m_axis_sum_tready => m_axis_sum_tready,
        m_axis_sum_tdata => m_axis_sum_tdata
    );
    
    
    clock_sim: process
    begin
        while not sim_done loop
            aclk <= '0';
            wait for 20 ns;
            aclk <= '1';
            wait for 20 ns;
        end loop;
        wait;
    end process;
   
    sim: process
        
        procedure send_data(
            signal valid : out std_logic;
            signal ready : in std_logic;
            signal data : out std_logic_vector(31 downto 0);
            constant value : in integer) is
        begin
            valid <= '1';
            data <= std_logic_vector(to_signed(value, 32));
            wait until rising_edge(aclk) and ready = '1';
            wait for 20 ns;  
        end procedure;
        
    begin
      
        wait for 20 ns;
        send_data(s_axis_min_tvalid, s_axis_min_tready, s_axis_min_tdata, -100);
        send_data(s_axis_max_tvalid, s_axis_max_tready, s_axis_max_tdata, 100);
        m_axis_sum_tready <= '1';
        
        for i in 1 to 10 loop
            send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, i * 10);
            wait for 20 ns;
        end loop;
        
        
        for i in 1 to 5 loop
            send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, 150);
            wait for 20 ns;
        end loop;
        
        
        for i in 1 to 5 loop
            send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, -150);
            wait for 20 ns;
        end loop;
        
        
        send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, 50);
        send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, -50);
        send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, 75);
        send_data(s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, -75);
        wait for 100 ns;
        
      
        wait for 200 ns ;
        sim_done <= true;
        wait;
    end process;
    
 
    
end Behavioral;