library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity memory_matrix is
    port (
        clk     : in std_logic;
        address : in std_logic_vector(16 downto 0);
        data    : inout std_logic_vector(15 downto 0);
        bhe_n   : in std_logic;
        sel     : in std_logic_vector(7 downto 0);  
        wr_n    : in std_logic
    );
end memory_matrix;


architecture structural of memory_matrix is
    component memory_submodule is
        port (
            clk     : in std_logic;
            address : in std_logic_vector(15 downto 0);
            data    : inout std_logic_vector(15 downto 0);
            cs_n    : in std_logic;
            wr_n    : in std_logic;
            bhe_n   : in std_logic
        );
    end component;

begin
    gen_modules: for i in 0 to 7 generate
        mem_module: memory_submodule
            port map (
                clk     => clk,
                address => address(15 downto 0),
                data    => data,
                cs_n    => sel(i),  
                wr_n    => wr_n,
                bhe_n   => bhe_n
            );
    end generate;
end structural;