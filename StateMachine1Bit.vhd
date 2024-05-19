library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine1Bit is
	port(
		clk   : in std_logic;
		rst   : in std_logic;
		state : out std_logic
		);
	end entity;
	
architecture a_StateMachine1Bit of StateMachine1Bit is
	signal stateTemp : std_logic := '0';
	--valor padrão de estado 0
	
	begin 
	
	process(clk, rst)
	begin	
		if rst = '1' then
			stateTemp <= '0';
		elsif rising_edge(clk) then
			stateTemp <= not stateTemp;
		end if;
	end process;
	state <= stateTemp;
end architecture;
	