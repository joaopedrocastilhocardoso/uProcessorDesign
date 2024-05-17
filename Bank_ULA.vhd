library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bank_ULA is
	port(
		clk, rst, BWrEn, AWrEn : in std_logic;
		regCode : in unsigned (2 downto 0);
		UlaOpCode : in unsigned (2 downto 0);
		UlaOutp : out unsigned (15 downto 0);
		flagZero : out std_logic;
		MuxUlaIn, MuxBankIn : in std_logic;
		LoadImmediate : in unsigned (15 downto 0)
	);
	end entity Bank_ULA;
	
	architecture a_Bank_ULA of Bank_ULA is
	
		component RegBank is 
			port(
				clk, rst, wrEn : in std_logic;
				regCode        : in unsigned(2 downto 0);
				dataIn         : in unsigned(15 downto 0); 
				dataOut        : out unsigned(15 downto 0)
			);
		end component;
		
		component ULA is
			port(
				inA    : in unsigned (15 downto 0);
				inB    : in unsigned (15 downto 0);
				outp   : out unsigned (15 downto 0);
				opCode : in unsigned (2 downto 0);
				fZero  : out std_logic
				);
		end component;
		
		component Reg16Bit is
			port(
				clk     : in std_logic;
				wrEn    : in std_logic;
				rst     : in std_logic;
				dataIn  : in unsigned (15 downto 0);
				dataOut : out unsigned (15 downto 0)
			);
		end component;
		
		signal ULAin, ULAout : unsigned (15 downto 0);
		signal AccumOut : unsigned (15 downto 0);
		signal DataInBank, DataOutBank : unsigned (15 downto 0);
		signal ULAzero : std_logic;
		
		begin
		-- components declaration
		
		ULA0 : ULA port map (ULAin, AccumOut, ULAout, UlaOpCode, ULAzero);
		BANK0 : RegBank port map (clk, rst, BWrEn, regCode, dataInBank, DataOutBank);
		ACC0 : Reg16Bit port map (clk, AWrEn, rst, ULAout, AccumOut);
		
		-- Mux da ULA
		UlaIn <= LoadImmediate when MuxUlaIn = '1' else DataOutBank;
		
		-- Mux do banco
		DataInBank <=  LoadImmediate when MuxBankIn = '1' else AccumOut;
		
		--por padrão quando os mux estiverem ligados o valor carregado será de uma constante LoadImmediate
		
		flagZero <= ULAzero;
		ULAoutp <= ULAout;
	end a_Bank_ULA;
		