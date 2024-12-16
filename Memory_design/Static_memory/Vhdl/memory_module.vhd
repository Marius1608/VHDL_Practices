library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity memory_module is
    port (
        address     : in std_logic_vector(23 downto 0);
        data        : inout std_logic_vector(15 downto 0);
        rd_n        : in std_logic;
        wr_n        : in std_logic;
        bhe_n       : in std_logic;
        clk         : in std_logic
    );
end memory_module;


architecture structural of memory_module is
    
    component decoder is
        port (
            address      : in std_logic_vector(23 downto 17);
            rd_n         : in std_logic;
            wr_n         : in std_logic;
            sel_module_n : out std_logic_vector(7 downto 0)
        );
    end component;

    component amplification_circuit is
        port (
            sa          : in std_logic_vector(16 downto 0);
            sbhe_n      : in std_logic;
            ma          : out std_logic_vector(16 downto 0);
            mbhe_n      : out std_logic;
            sd          : inout std_logic_vector(15 downto 0);
            md          : inout std_logic_vector(15 downto 0);
            rd_n        : in std_logic;
            wr_n        : in std_logic;
            sel_module_n: in std_logic
        );
    end component;

    component memory_matrix is
        port (
            clk     : in std_logic;
            address : in std_logic_vector(16 downto 0);
            data    : inout std_logic_vector(15 downto 0);
            bhe_n   : in std_logic;
            sel     : in std_logic_vector(7 downto 0);
            wr_n    : in std_logic
        );
    end component;

    
    signal sel_module_n : std_logic_vector(7 downto 0);
    signal sel_module  : std_logic_vector(7 downto 0);
    signal internal_address : std_logic_vector(16 downto 0);
    signal internal_bhe_n  : std_logic;
    signal internal_data   : std_logic_vector(15 downto 0);
    signal decoder_enabled : std_logic;

begin
  
    decoder_enabled <= '0' when (rd_n = '0' or wr_n = '0') else '1';
    sel_module <= not sel_module_n;

    decoder_comp: decoder 
        port map (
            address => address(23 downto 17),
            rd_n => rd_n,
            wr_n => wr_n,
            sel_module_n => sel_module_n
        );

    amp_comp: amplification_circuit
        port map (
            sa => address(16 downto 0),
            sbhe_n => bhe_n,
            ma => internal_address,
            mbhe_n => internal_bhe_n,
            sd => data,
            md => internal_data,
            rd_n => rd_n,
            wr_n => wr_n,
            sel_module_n => decoder_enabled 
        );

    mem_matrix: memory_matrix
        port map (
            clk => clk,
            address => internal_address,
            data => internal_data,
            bhe_n => internal_bhe_n,
            sel => sel_module,
            wr_n => wr_n
        );

end structural;