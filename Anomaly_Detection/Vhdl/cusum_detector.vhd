library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cusum_detector is
    Generic (
        DRIFT : INTEGER := 50;      
        THRESHOLD : INTEGER := 200   
    );
    Port ( 
        
        aclk : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        
        
        s_axis_sample_tvalid : IN STD_LOGIC;
        s_axis_sample_tready : OUT STD_LOGIC;
        s_axis_sample_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  
        m_axis_result_tvalid : BUFFER STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
end cusum_detector;

architecture Behavioral of cusum_detector is
    
    signal prev_sample : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal first_sample : STD_LOGIC := '1';
    
    
    signal ADD_OP : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    signal SUB_OP : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000001";
    

    signal drift_vec : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    
    signal diff_valid, diff_ready : STD_LOGIC;
    signal diff_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    signal gplus_input_valid, gminus_input_valid : STD_LOGIC;
    signal gplus_input_ready, gminus_input_ready : STD_LOGIC;
    signal gplus_input_data, gminus_input_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    signal gplus_max_valid, gminus_max_valid : STD_LOGIC;
    signal gplus_max_ready, gminus_max_ready : STD_LOGIC;
    signal gplus_max_data, gminus_max_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    
    type state_type is (S_IDLE, S_WAIT_DIFF, S_WAIT_GPLUS, S_WAIT_GMINUS, S_WAIT_RESULT);
    signal state : state_type := S_IDLE;

    
    component int_adder_subtractor is
        Port (
            aclk : IN STD_LOGIC;
            s_axis_a_tvalid : IN STD_LOGIC;
            s_axis_a_tready : OUT STD_LOGIC;
            s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_b_tvalid : IN STD_LOGIC;
            s_axis_b_tready : OUT STD_LOGIC;
            s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_operation_tvalid : IN STD_LOGIC;
            s_axis_operation_tready : OUT STD_LOGIC;
            s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            m_axis_result_tvalid : OUT STD_LOGIC;
            m_axis_result_tready : IN STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

    component max_calculator is
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_val_tvalid : IN STD_LOGIC;
            s_axis_val_tready : OUT STD_LOGIC;
            s_axis_val_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_result_tvalid : BUFFER STD_LOGIC;
            m_axis_result_tready : IN STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

    component threshold_detector is
        Generic (
            THRESHOLD : INTEGER := 200
        );
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_gplus_tvalid : IN STD_LOGIC;
            s_axis_gplus_tready : OUT STD_LOGIC;
            s_axis_gplus_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_gminus_tvalid : IN STD_LOGIC;
            s_axis_gminus_tready : OUT STD_LOGIC;
            s_axis_gminus_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_anomaly_tvalid : OUT STD_LOGIC;
            m_axis_anomaly_tready : IN STD_LOGIC;
            m_axis_anomaly_tdata : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

begin
    
    drift_vec <= STD_LOGIC_VECTOR(TO_SIGNED(DRIFT, 32));
    
    diff_calc: int_adder_subtractor
    port map (
        aclk => aclk,
        s_axis_a_tvalid => s_axis_sample_tvalid,
        s_axis_a_tready => open,  
        s_axis_a_tdata => s_axis_sample_tdata,
        s_axis_b_tvalid => '1',
        s_axis_b_tready => open,
        s_axis_b_tdata => prev_sample,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => open,
        s_axis_operation_tdata => SUB_OP,
        m_axis_result_tvalid => diff_valid,
        m_axis_result_tready => diff_ready,
        m_axis_result_tdata => diff_data
    );

    
    gplus_calc: max_calculator
    port map (
        aclk => aclk,
        s_axis_val_tvalid => gplus_input_valid,
        s_axis_val_tready => gplus_input_ready,
        s_axis_val_tdata => gplus_input_data,
        m_axis_result_tvalid => gplus_max_valid,
        m_axis_result_tready => gplus_max_ready,
        m_axis_result_tdata => gplus_max_data
    );


    gminus_calc: max_calculator
    port map (
        aclk => aclk,
        s_axis_val_tvalid => gminus_input_valid,
        s_axis_val_tready => gminus_input_ready,
        s_axis_val_tdata => gminus_input_data,
        m_axis_result_tvalid => gminus_max_valid,
        m_axis_result_tready => gminus_max_ready,
        m_axis_result_tdata => gminus_max_data
    );

    
    thresh_detect: threshold_detector
    generic map (
        THRESHOLD => THRESHOLD
    )
    port map (
        aclk => aclk,
        s_axis_gplus_tvalid => gplus_max_valid,
        s_axis_gplus_tready => gplus_max_ready,
        s_axis_gplus_tdata => gplus_max_data,
        s_axis_gminus_tvalid => gminus_max_valid,
        s_axis_gminus_tready => gminus_max_ready,
        s_axis_gminus_tdata => gminus_max_data,
        m_axis_anomaly_tvalid => m_axis_result_tvalid,
        m_axis_anomaly_tready => m_axis_result_tready,
        m_axis_anomaly_tdata => m_axis_result_tdata
    );

    
    process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                state <= S_IDLE;
                first_sample <= '1';
                prev_sample <= (others => '0');
            else
                case state is
                    when S_IDLE =>
                        if s_axis_sample_tvalid = '1' then
                            if first_sample = '1' then
                                prev_sample <= s_axis_sample_tdata;
                                first_sample <= '0';
                            else
                                state <= S_WAIT_DIFF;
                            end if;
                        end if;
                        
                    when S_WAIT_DIFF =>
                        if diff_valid = '1' then
                            
                            prev_sample <= s_axis_sample_tdata;
                            
                            gplus_input_data <= diff_data - drift_vec;
                            gplus_input_valid <= '1';
                            
                            gminus_input_data <= (not diff_data) + 1 - drift_vec; 
                            gminus_input_valid <= '1';
                            
                            state <= S_WAIT_GPLUS;
                        end if;

                    when S_WAIT_GPLUS =>
                        if gplus_max_valid = '1' then
                            state <= S_WAIT_GMINUS;
                        end if;

                    when S_WAIT_GMINUS =>
                        if gminus_max_valid = '1' then
                            state <= S_WAIT_RESULT;
                        end if;

                    when S_WAIT_RESULT =>
                        if m_axis_result_tvalid = '1' and m_axis_result_tready = '1' then
                            state <= S_IDLE;
                        end if;
                end case;
            end if;
        end if;
    end process;

    
    s_axis_sample_tready <= '1' when (state = S_IDLE and first_sample = '0') else '0';
    
    
    diff_ready <= '1' when state = S_WAIT_DIFF else '0';

end Behavioral;