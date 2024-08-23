library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg1Bit is 
	port(
		clk     : in std_logic;
		wrEn    : in std_logic;
		rst     : in std_logic;
		dataIn  : in std_logic;
		dataOut : out std_logic
		);
	end entity;
	
architecture a_Reg1Bit of Reg1Bit is
	signal dataTemp : std_logic := '0';
	--valor padrão 0 de registrador
	begin
	
	process(clk, wrEn, rst)
	begin
		if rst = '1' then
			dataTemp <= '0';
		
		elsif wrEn = '1' then
			if rising_edge(clk) then --se enable ligado e clock de subida então:
				dataTemp <= dataIn;
			end if;
		end if;
		
	end process;
	dataOut <= dataTemp;
end architecture;
	
