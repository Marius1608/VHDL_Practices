library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cache_controller is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        read_req    : in std_logic;
        write_req   : in std_logic;
        tag_match   : in std_logic;
        valid       : in std_logic;
        mem_ready   : in std_logic;
        tag_write   : out std_logic;
        data_write  : out std_logic;
        mem_read    : out std_logic;
        mem_write   : out std_logic;
        hit         : out std_logic;
        ready       : out std_logic
    );
end cache_controller;


architecture behavioral of cache_controller is
    type state_type is (IDLE, CHECK_HIT, WRITE_BACK, FETCH, UPDATE);
    signal state, next_state : state_type;
    signal dirty : std_logic := '0';
begin
    
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            dirty <= '0';
        elsif rising_edge(clk) then
            state <= next_state;

            if state = CHECK_HIT and tag_match = '1' and valid = '1' and write_req = '1' then
                dirty <= '1';
            elsif state = UPDATE then
                dirty <= '0';
            end if;
        end if;
    end process;

    process(state, read_req, write_req, tag_match, valid, mem_ready, dirty)
    begin
        
        tag_write <= '0';
        data_write <= '0';
        mem_read <= '0';
        mem_write <= '0';
        hit <= '0';
        ready <= '0';
        next_state <= state;  
        
        case state is
            when IDLE =>
                ready <= '1';
                if read_req = '1' or write_req = '1' then
                    next_state <= CHECK_HIT;
                end if;

            when CHECK_HIT =>
                if tag_match = '1' and valid = '1' then
                    hit <= '1';
                    ready <= '1';
                    if write_req = '1' then
                        data_write <= '1';
                    end if;
                    next_state <= IDLE;
                else
                    if dirty = '1' then
                        next_state <= WRITE_BACK;
                    else
                        next_state <= FETCH;
                    end if;
                end if;

            when WRITE_BACK =>
                mem_write <= '1';
                if mem_ready = '1' then
                    next_state <= FETCH;
                end if;

            when FETCH =>
                mem_read <= '1';
                if mem_ready = '1' then
                    next_state <= UPDATE;
                end if;

            when UPDATE =>
                tag_write <= '1';
                data_write <= '1';
                next_state <= IDLE;
        end case;
    end process;
end behavioral;