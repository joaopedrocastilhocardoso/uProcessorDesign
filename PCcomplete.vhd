library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCcomplete is
	port(
		clk, rst        : in std_logic;
		state, jumpInst : in unsigned(1 downto 0);
		dataIn          : in unsigned(6 downto 0);
		dataOut         : out unsigned(6 downto 0)
	);
end entity PCcomplete;

architecture a_PCcomplete of PCcomplete is
	
	component PC is
		port(
		clk  	 : in std_logic;
		wrEn 	 : in std_logic;
		rst      : in std_logic;
		dataIn   : in  unsigned(6 downto 0);
		dataOut  : out unsigned(6 downto 0)
	);
	end component;
	
	-- Declaração de sinais
	signal PCOut, PCIn : unsigned(6 downto 0) := "0000000";	-- Endereços por padrão começam em 0
	signal PCWrEn : std_logic := '0';
	
	begin
	
	PCwrEn <= '1' when state = "00" else '0'; --Write enable on only during fetch phase, stage 00
	
	PC0 : PC port map (clk, PCwrEn, rst, PCin, PCOut);
	
	--MUX de entrada, para o próximo endereço caso tenha instrução de jump
	PCIn <= dataIn when jumpInst = "01" else PCOut + dataIn when jumpInst = "10" else PCOut + "0000001";
	dataOut <= PCOut;
	
end a_PCcomplete;
