library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg16Bit is 
	port(
		clk     : in std_logic;
		wrEn    : in std_logic;
		rst     : in std_logic;
		dataIn  : in unsigned (15 downto 0);
		dataOut : out unsigned (15 downto 0)
		);
	end entity;
	
architecture a_Reg16Bit of Reg16Bit is
	signal dataTemp : unsigned (15 downto 0) := "0000000000000000";
	--valor padrão 0 de registrador
	begin
	
	process(clk, wrEn, rst)
	begin
		if rst = '1' then
			dataTemp <= "0000000000000000";
		
		elsif wrEn = '1' then
			if rising_edge(clk) then --se enable ligado e clock de subida então:
				dataTemp <= dataIn;
			end if;
		end if;
		
	end process;
	dataOut <= dataTemp;
end architecture;
	