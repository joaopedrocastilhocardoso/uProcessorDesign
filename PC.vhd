library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 
	port(
		clk  	 : in std_logic;
		wrEn 	 : in std_logic;
		rst      : in std_logic;
		dataIn   : in  unsigned(6 downto 0);
		dataOut  : out unsigned(6 downto 0)
	);
	end entity PC;
	
architecture a_PC of PC is 
	
	constant GND  : unsigned(6 downto 0) := "0000000";
	signal outTemp : unsigned(6 downto 0) := GND;
	
	begin
	
	process(clk, rst, wrEn)
	begin
		if rst = '1' then
			outTemp <= GND;
		elsif rising_edge(clk) then
			if wrEn = '1' then
				outTemp <= dataIn;
			end if;
		end if;
	end process;
	
	dataOut <= outTemp;
	
end a_PC;
	