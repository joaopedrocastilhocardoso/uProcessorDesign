library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine2Bits_tb is
end entity;

architecture teste of StateMachine2Bits_tb is
	component StateMachine2Bits
		port(
		clk, rst : in std_logic;
		state    : out unsigned(1 downto 0)
	);
	end component;
	
	signal clk_tb, rst_tb : std_logic;
	signal state_tb       : unsigned(1 downto 0);
	signal finished       : std_logic := '0';
	
	constant period_time  : time := 100 ns;
	
	begin
		
	sttMach1 : StateMachine2Bits
	port map(
		clk   => clk_tb,
		rst   => rst_tb,
		state => state_tb
		);
	
	reset_global : process begin -- reset signal
		
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
		
	sim_time_proc : process begin -- simulation time
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
	
	testing_process : process begin -- command line
	
		wait for period_time;
		rst_tb <= '1';
		wait for period_time*8;
		rst_tb <= '0';
		wait;
	end process testing_process;
end architecture teste;