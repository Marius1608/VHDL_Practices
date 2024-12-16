library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sliding_window_adder is
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
end sliding_window_adder;

architecture Behavioral of sliding_window_adder is
    
    type state_type is (S_read, S_write);
    signal state : state_type := S_read;
    
    type window_array is array (0 to WINDOW_SIZE-1) of STD_LOGIC_VECTOR(31 downto 0);
    signal window : window_array := (others => (others => '0'));  
    signal ptr : integer range 0 to WINDOW_SIZE-1 := 0;         
    
    signal temp_sum : SIGNED(31 downto 0) := (others => '0'); 
    signal result : STD_LOGIC_VECTOR(31 downto 0);            
    
begin
   
    s_axis_val_tready <= '1' when state = S_read else '0';
    m_axis_sum_tvalid <= '1' when state = S_write else '0';
    m_axis_sum_tdata <= STD_LOGIC_VECTOR(temp_sum);
    
   
    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when S_read =>
                    if s_axis_val_tvalid = '1' then
                        temp_sum <= temp_sum - SIGNED(window(ptr)) + SIGNED(s_axis_val_tdata);
                        window(ptr) <= s_axis_val_tdata;
                        
                        if ptr < WINDOW_SIZE-1 then
                            ptr <= ptr + 1;
                        else
                            ptr <= 0;
                        end if;
                       
                        state <= S_write;
                    end if;
                    
                when S_write =>
                    if m_axis_sum_tready = '1' then
                        state <= S_read;
                    end if;
            end case;
        end if;
    end process;
    
end Behavioral;