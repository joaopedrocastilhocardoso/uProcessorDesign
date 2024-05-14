library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegBank_tb is
end entity; 

architecture test of RegBank_tb is
	component RegBank is
		port(
			clk, rst, wrEn : in std_logic;
			regCode        : in unsigned(2 downto 0);
			dataIn         : in unsigned(15 downto 0); 
			dataOut        : out unsigned(15 downto 0)
		);
	end component;
	signal clk_tb, rst_tb          : std_logic;
	signal wrEn_tb                 : std_logic := '0';
	signal finished                : std_logic := '0';
	signal regCode_tb              : unsigned (2 downto 0) := "000";
	signal dataIn_tb, dataOut_tb   : unsigned (15 downto 0);
		
	-- Constants
		
	constant period_time : time := 100 ns;
	constant X           : unsigned(15 downto 0) := "1010101010101010";
	constant Y           : unsigned(15 downto 0) := "1100110011001100";
	constant Z           : unsigned(15 downto 0) := "1111000011110000";
 		
	begin
		
	bank1 : RegBank 
	port map(
		clk     => clk_tb,
		rst     => rst_tb,
		wrEn    => wrEn_tb,
		regCode => regCode_tb,
		dataIn  => dataIn_tb,
		dataOut => dataOut_tb
	);
				
	sim_time_proc :  process begin -- total time for simulation
				
		wait for 10 us;
		finished <= '1';
		wait;
	end process sim_time_proc; 
			
	clk_proc : process begin -- clock signal					
			while finished /= '1' loop
			clk_tb <= '0';
			wait for period_time/2;
			clk_tb <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
			
	reset_global : process begin -- global reset signal
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
				
	testing_process : process begin -- command line for register bank testing
		wait for period_time*2;
		regCode_tb <= "101";
		dataIn_tb <= X;
		wait for period_time*2;
		wrEn_tb <= '1';
		wait for period_time*2;
		dataIn_tb <= Y;
		wait for period_time*2;
		regCode_tb <= "000";
		wait for period_time*2;
		dataIn_tb <= Z;
		wrEn_tb <= '0';
		regCode_tb <= "111";
		wait for period_time*2;
		wrEn_tb <= '1';
		wait for period_time*2;
		regCode_tb <= "001";
		wait;
	end process testing_process;
end architecture test;			
					
					
			
