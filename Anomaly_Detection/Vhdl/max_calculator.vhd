library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity max_calculator is
    Port ( 
        aclk : IN STD_LOGIC;
        s_axis_val_tvalid : IN STD_LOGIC;
        s_axis_val_tready : OUT STD_LOGIC;
        s_axis_val_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end max_calculator;

architecture Behavioral of max_calculator is
    type state_type is (S_READ, S_WRITE);
    signal state : state_type := S_READ;
    signal result : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    s_axis_val_tready <= '1' when state = S_READ else '0';
    m_axis_result_tvalid <= '1' when state = S_WRITE else '0';
    m_axis_result_tdata <= result;

    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when S_READ =>
                    if s_axis_val_tvalid = '1' then
                        
                        if s_axis_val_tdata > zero then
                            result <= s_axis_val_tdata;
                        else
                            result <= zero;
                        end if;
                        state <= S_WRITE;
                    end if;
                when S_WRITE =>
                    if m_axis_result_tready = '1' then
                        state <= S_READ;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;