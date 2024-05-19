library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine1Bit_tb is
end entity;

architecture teste of StateMachine1Bit_tb is
	component StateMachine1Bit
		port(
		clk   : in std_logic;
		rst   : in std_logic;
		state : out std_logic
		);
	end component;
	
	signal clk_tb, rst_tb, state_tb : std_logic;
	signal finished                 : std_logic := '0';
	
	constant period_time            : time := 100 ns;
	
	begin
		
	sttMach1 : StateMachine1Bit
	port map(
		clk   => clk_tb,
		rst   => rst_tb,
		state => state_tb
		);
	
	reset_global : process begin -- sinal de reset
		
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
		
	sim_time_proc : process begin -- tempo de simulação
		wait for 10 us;
		finished <= '1';
		wait;
	end process sim_time_proc;
	
	clk_proc : process begin -- sinal de clock
	
		while finished /= '1' loop
			clk_tb <= '0';
			wait for period_time/2;
			clk_tb <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
	
	testing_process : process begin -- linha de comandos para testar a máquina de estados
	
		wait for period_time;
		rst_tb <= '1';
		wait for period_time*4;
		rst_tb <= '0';
		wait;
	end process testing_process;
end architecture teste;