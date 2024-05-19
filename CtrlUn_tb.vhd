library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CtrlUn_tb is
end entity CtrlUn_tb;

architecture teste of CtrlUn_tb is
	component CtrlUn is
		port(
			clk, rst : in std_logic
	);
	end component;
	
	-- signal definitions
	
	signal clk_tb, rst_tb : std_logic;
	signal finished       : std_logic := '0';
	
	-- constants
	constant period_time : time := 100 ns;
	
	begin 
	
	Circuit1 : CtrlUn
	port map(
		clk => clk_tb,
		rst => rst_tb
	);
	
	sim_time_proc : process begin --tempo de simulação
		
		wait for 10 us;
		finished <= '1';
		wait;
	end process sim_time_proc;
	
	clk_proc : process begin -- sinal periódico de clock
		
		while finished /= '1' loop -- enquanto não acabar loop
			clk_tb <= '0';
			wait for period_time/2;
			clk_tb <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
	
	reset_global : process begin -- sinal de reset inicial
	
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
end architecture teste;