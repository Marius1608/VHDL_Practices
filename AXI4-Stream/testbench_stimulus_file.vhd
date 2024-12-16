library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_stimulus_file is
end testbench_stimulus_file;

architecture Tb of testbench_stimulus_file is

component temperature_subtractor is
    Port ( aclk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           t1_tvalid : in STD_LOGIC;
           t1_tready : out STD_LOGIC;
           t1_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           t2_tvalid : in STD_LOGIC;
           t2_tready : out STD_LOGIC;
           t2_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           tout_tvalid : out STD_LOGIC;
           tout_tready : in STD_LOGIC;
           tout_tdata : out STD_LOGIC_VECTOR (31 downto 0));
end component;

constant T : time := 20 ns;

signal aclk, aresetn : STD_LOGIC := '0';
signal t1_tdata, t2_tdata, tout_tdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal t1_tready, t2_tready : STD_LOGIC := '0';
signal t1_tvalid, t2_tvalid, tout_tvalid : STD_LOGIC := '0';

signal rd_count, wr_count : integer := 0;
signal end_of_reading : std_logic := '0';

begin

    aclk <= not aclk after T / 2;
    aresetn <= '0', '1' after 5 * T; -- reset the FIFO buffers at first
    
    -- design under test
    dut : temperature_subtractor port map (
        aclk => aclk,
        aresetn => aresetn,
        t1_tvalid => t1_tvalid,
        t1_tready => t1_tready,
        t1_tdata => t1_tdata,
        t2_tvalid => t2_tvalid,
        t2_tready => t2_tready,
        t2_tdata => t2_tdata,
        tout_tvalid => tout_tvalid,
        tout_tready => '1',
        tout_tdata => tout_tdata
    );

    -- read values from the input file
    process (aclk)
        file sensors_data : text open read_mode is "temperature.csv";
        variable in_line : line;
        
        variable timestamp : string(1 to 16);
        variable temperature1 : std_logic_vector(31 downto 0);
        variable temperature2 : std_logic_vector(31 downto 0);
        variable space : character;
        variable comma : character;
    begin
        if rising_edge(aclk) then
            if aresetn = '1' and end_of_reading = '0' then
            
                if not endfile(sensors_data) then     
                    
                    if t1_tready = '1' and t2_tready = '1' then     -- read from the file only when the module is ready to accept data
                        readline(sensors_data, in_line);
                        read(in_line, timestamp);
                        
                        t1_tvalid <= '1';
                        t2_tvalid <= '1';
                        
                        read(in_line, comma);
                        read(in_line, temperature1);
                        t1_tdata <= temperature1;
                        
                        read(in_line, comma);
                        read(in_line, temperature2);
                        t2_tdata <= temperature2;
                        
                        rd_count <= rd_count + 1;
                        
                        report "Values measured at time t = " & timestamp & " successfully read";
                    else
                        t1_tvalid <= '0';
                        t2_tvalid <= '0';
                    end if;
                        
                else
                    file_close(sensors_data);
                    end_of_reading <= '1';
                end if;
            end if;
        end if;
    end process;
    
    -- write results in the output file
    process 
        file results : text open write_mode is "C:\Users\pante\Desktop\An3_sem1\SSC\Laborator\Lab_6\temperature_results.csv"; -- TO DO: provide the absolute path of the project directory followed by "temperature_results.csv"
        variable out_line : line;
    begin
        wait until rising_edge(aclk);
            
        if aresetn = '0' then
            wait until rising_edge(aresetn);
        end if;
    
        if wr_count <= rd_count then
            if tout_tvalid = '1' then   -- write the result only when it is valid
                write(out_line, wr_count);
                write(out_line, string'(", "));
                write(out_line, tout_tdata);
                writeline(results, out_line);
                
                wr_count <= wr_count + 1;
            end if;
        else
            file_close(results);
            report "execution finished...";
            wait;
        end if;
    end process;

end Tb;
