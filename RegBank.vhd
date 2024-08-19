library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegBank is
	port(
		clk, rst, wrEn : in std_logic;
		regCode        : in unsigned(2 downto 0);
		dataIn         : in unsigned(15 downto 0); 
		dataOut        : out unsigned(15 downto 0);
		reg7Out        : out unsigned(15 downto 0)
	);
	end entity RegBank;
	
	architecture a_RegBank of RegBank is
	
		component Reg16Bit is
			port(
				clk, rst, wrEn : in std_logic;
				dataIn         : in unsigned (15 downto 0);
				dataOut        : out unsigned (15 downto 0)
			);
		end component;
		-- signal declaration for all registers 0 to 7
		signal dataOut0, dataOut1, dataOut2, dataOut3, dataOut4, dataOut5, dataOut6, dataOut7 : unsigned (15 downto 0);
		signal wrEn0, wrEn1, wrEn2, wrEn3, wrEn4, wrEn5, wrEn6, wrEn7                         : std_logic;
		
		begin
		-- MUX for register wrEn selection
		
		wrEn0 <= '0'; -- register 0 has value 0 and can't be changed, this makes other operations and comparisons easier.
		wrEn1 <= '1' when regCode = "001" and wrEn = '1' else '0';
		wrEn2 <= '1' when regCode = "010" and wrEn = '1' else '0';
		wrEn3 <= '1' when regCode = "011" and wrEn = '1' else '0';
		wrEn4 <= '1' when regCode = "100" and wrEn = '1' else '0';
		wrEn5 <= '1' when regCode = "101" and wrEn = '1' else '0';
		wrEn6 <= '1' when regCode = "110" and wrEn = '1' else '0';
		wrEn7 <= '1' when regCode = "111" and wrEn = '1' else '0';
		
		-- Register declaration
		
		reg0 : Reg16Bit port map(clk, rst, wrEn0, dataIn, dataOut0);
		reg1 : Reg16Bit port map(clk, rst, wrEn1, dataIn, dataOut1);
		reg2 : Reg16Bit port map(clk, rst, wrEn2, dataIn, dataOut2);
		reg3 : Reg16Bit port map(clk, rst, wrEn3, dataIn, dataOut3);
		reg4 : Reg16Bit port map(clk, rst, wrEn4, dataIn, dataOut4);
		reg5 : Reg16Bit port map(clk, rst, wrEn5, dataIn, dataOut5);
		reg6 : Reg16Bit port map(clk, rst, wrEn6, dataIn, dataOut6);
		reg7 : Reg16Bit port map(clk, rst, wrEn7, dataIn, dataOut7);
		
		-- MUX for register dataOut selection
		
		dataOut <= dataOut0 when regCode = "000" else
		dataOut1 when regCode = "001" else
		dataOut2 when regCode = "010" else
		dataOut3 when regCode = "011" else
		dataOut4 when regCode = "100" else
		dataOut5 when regCode = "101" else
		dataOut6 when regCode = "110" else
		dataOut7 when regCode = "111" else 
		"0000000000000000";
		
		reg7Out <= dataOut7;
		
	end architecture a_RegBank;
