library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity amplification_circuit is
    port (
        sa      : in std_logic_vector(16 downto 0);  
        sbhe_n  : in std_logic;        
        ma      : out std_logic_vector(16 downto 0); 
        mbhe_n  : out std_logic;    
        sd      : inout std_logic_vector(15 downto 0);
        md      : inout std_logic_vector(15 downto 0);
        rd_n    : in std_logic;
        wr_n    : in std_logic;
        sel_module_n : in std_logic
    );
end amplification_circuit;


architecture structural of amplification_circuit is
    
    component buffer_244 is
        port (
            input   : in std_logic_vector(7 downto 0);
            output  : out std_logic_vector(7 downto 0);
            g0_n    : in std_logic;
            g1_n    : in std_logic
        );
    end component;

    component buffer_245 is
        port (
            a       : inout std_logic_vector(7 downto 0);
            b       : inout std_logic_vector(7 downto 0);
            dir     : in std_logic;
            cs_n    : in std_logic
        );
    end component;

    signal unused_outputs : std_logic_vector(7 downto 2);

begin
   
    abuffer_low: buffer_244
        port map (
            input => sa(7 downto 0),
            output => ma(7 downto 0),
            g0_n => '0',  
            g1_n => '0'
        );

    abuffer_high: buffer_244
        port map (
            input => sa(15 downto 8),
            output => ma(15 downto 8),
            g0_n => '0',  
            g1_n => '0'
        );

    ctrl_buffer: buffer_244
        port map (
            input(0) => sa(16),
            input(1) => sbhe_n,
            input(2) => rd_n,
            input(3) => wr_n,
            input(7 downto 4) => "0000",
            output(0) => ma(16),
            output(1) => mbhe_n,
            output(7 downto 2) => unused_outputs,  
            g0_n => '0',
            g1_n => '0'
        );

    dbuffer_low: buffer_245
        port map (
            a => sd(7 downto 0),
            b => md(7 downto 0),
            dir => rd_n,
            cs_n => sel_module_n
        );

    dbuffer_high: buffer_245
        port map (
            a => sd(15 downto 8),
            b => md(15 downto 8),
            dir => rd_n,
            cs_n => sel_module_n
        );

end structural;