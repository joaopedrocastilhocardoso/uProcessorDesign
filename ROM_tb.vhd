library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_tb is
end entity;

architecture teste of ROM_tb is
	component ROM is
		port(	clk     : in std_logic;
			address : in unsigned(6 downto 0);
			output  : out unsigned(15 downto 0)
		);
	end component;
	
	-- signal definitions
	
	signal clk_tb        : std_logic;
	signal finished      : std_logic := '0';
	signal addresss_tb   : unsigned(6 downto 0);
	signal output_tb     : unsigned(15 downto 0);
	
	-- constantes para testes
	
	constant period_time : time := 100 ns;
	
	-- constantes para dados
	
	constant adrs0 : unsigned(6 downto 0) := "0000000"; -- endereço 0
	constant adrs1 : unsigned(6 downto 0) := "0000001"; -- endereço 1
	constant adrs2 : unsigned(6 downto 0) := "0000010"; -- endereço 2
	constant adrs3 : unsigned(6 downto 0) := "0000011"; -- endereço 3
	constant adrs4 : unsigned(6 downto 0) := "0000100"; -- endereço 4
	constant adrs5 : unsigned(6 downto 0) := "0000101"; -- endereço 5
	constant adrs6 : unsigned(6 downto 0) := "0000110"; -- endereço 6
	
		begin
		
		Rom1 : ROM
		port map(
			clk     => clk_tb,
			address => addresss_tb,
			output  => output_tb
		);
	
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
		
		testing_process : process begin -- linha de comandos para testar a ROM
		wait for period_time/2;
		addresss_tb <= adrs0;
		wait for period_time*2;
		addresss_tb <= adrs1;
		wait for period_time*2;
		addresss_tb <= adrs2;
		wait for period_time*2;
		addresss_tb <= adrs3;
		wait for period_time*2;
		addresss_tb <= adrs4;
		wait for period_time*2;
		addresss_tb <= adrs5;
		wait for period_time*2;
		addresss_tb <= adrs6;
		wait for period_time*2;
		wait;
	end process testing_process;
end architecture teste;
		