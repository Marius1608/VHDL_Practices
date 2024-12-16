library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity threshold_detector is
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
end threshold_detector;

architecture Behavioral of threshold_detector is
    type state_type is (S_READ, S_WRITE);
    signal state : state_type := S_READ;
    signal threshold_vec : STD_LOGIC_VECTOR(31 downto 0);
    signal result : STD_LOGIC_VECTOR(0 downto 0);
begin
    threshold_vec <= STD_LOGIC_VECTOR(TO_SIGNED(THRESHOLD, 32));
    
    s_axis_gplus_tready <= '1' when state = S_READ else '0';
    s_axis_gminus_tready <= '1' when state = S_READ else '0';
    m_axis_anomaly_tvalid <= '1' when state = S_WRITE else '0';
    m_axis_anomaly_tdata <= result;

    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when S_READ =>
                    if s_axis_gplus_tvalid = '1' and s_axis_gminus_tvalid = '1' then
                        if s_axis_gplus_tdata > threshold_vec or s_axis_gminus_tdata > threshold_vec then
                            result <= "1";
                        else
                            result <= "0";
                        end if;
                        state <= S_WRITE;
                    end if;
                when S_WRITE =>
                    if m_axis_anomaly_tready = '1' then
                        state <= S_READ;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;