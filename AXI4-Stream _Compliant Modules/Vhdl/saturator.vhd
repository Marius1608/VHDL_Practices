library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity saturator is
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
end saturator;

architecture Behavioral of saturator is
    
    type state_type is (S_read, S_write);
    signal state : state_type := S_read;
    signal result : STD_LOGIC_VECTOR(31 downto 0);
    signal res_valid : STD_LOGIC;
    
begin
    
    res_valid <= s_axis_val_tvalid and s_axis_max_tvalid and s_axis_min_tvalid;
    s_axis_val_tready <= '1' when state = S_read else '0';
    s_axis_max_tready <= '1' when state = S_read else '0';
    s_axis_min_tready <= '1' when state = S_read else '0';
    m_axis_result_tvalid <= '1' when state = S_write else '0';
    m_axis_result_tdata <= result;

    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when S_read =>
                    if res_valid = '1' then
                        if signed(s_axis_val_tdata) > signed(s_axis_max_tdata) then
                            result <= s_axis_max_tdata;
                        elsif signed(s_axis_val_tdata) < signed(s_axis_min_tdata) then
                            result <= s_axis_min_tdata;
                        else
                            result <= s_axis_val_tdata;
                        end if;
                        state <= S_write;
                    end if;
                    
                when S_write =>
                    if m_axis_result_tready = '1' then
                        state <= S_read;
                    end if;
            end case;
        end if;
    end process;
    
end Behavioral;