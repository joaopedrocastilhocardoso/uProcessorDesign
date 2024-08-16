library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bank_ULA is
	port(
		clk, rst, BWrEn, AWrEn, AccRst : in std_logic;
		regCode                        : in unsigned (2 downto 0);
		UlaOpCode                      : in unsigned (2 downto 0);
		UlaOutp                        : out unsigned (15 downto 0);
		flagZero                       : out std_logic;
		flagNegative                   : out std_logic;
		flagOverflow                   : out std_logic;
		MuxUlaIn, MuxBankIn, MuxAccIn  : in std_logic;
		LoadImmediate                  : in unsigned (11 downto 0);
		BankOut                        : out unsigned (15 downto 0);
		AccOut                         : out unsigned (15 downto 0);
		RAMOut                         : in unsigned (15 downto 0);
		reg7Out                        : out unsigned (15 downto 0)
	);
	end entity Bank_ULA;
	
	architecture a_Bank_ULA of Bank_ULA is
	
		component RegBank is 
			port(
				clk, rst, wrEn : in std_logic;
				regCode        : in unsigned(2 downto 0);
				dataIn         : in unsigned(15 downto 0); 
				dataOut        : out unsigned(15 downto 0);
				reg7Out        : out unsigned(15 downto 0)
			);
		end component;
		
		component ULA is
			port(
				clk              : in std_logic;
				inA              : in unsigned (15 downto 0);
				inB              : in unsigned (15 downto 0);
				outp             : out unsigned (15 downto 0);
				opCode           : in unsigned (2 downto 0);
				fZero, fNegative : out std_logic;
				fOverflow        : out std_logic
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
		
		signal ULAin, ULAout, AccumIn         : unsigned (15 downto 0);
		signal AccumOut                       : unsigned (15 downto 0);
		signal DataInBank, DataOutBank        : unsigned (15 downto 0);
		signal ULAzero, ULAnegative, AccumRst : std_logic;
		signal ULAoverflow                    : std_logic;
		signal RAMOut_s, reg7Out_s            : unsigned (15 downto 0);
		
		
		begin
		-- components declaration
		
		ULA0 : ULA port map (clk, ULAin, AccumOut, ULAout, UlaOpCode, ULAzero, ULAnegative, ULAoverflow);
		BANK0 : RegBank port map (clk, rst, BWrEn, regCode, dataInBank, DataOutBank, reg7Out_s);
		ACC0 : Reg16Bit port map (clk, AWrEn, AccumRst, AccumIn, AccumOut);
		
		-- Mux da ULA
		UlaIn <= resize(LoadImmediate, 16) when MuxUlaIn = '1' else DataOutBank;
		
		-- Mux do banco
		DataInBank <= resize(LoadImmediate, 16) when MuxBankIn = '1' else AccumOut;
		
		-- Mux do Acumulador
		AccumIn <= ULAout when MuxAccIn = '1' else RAMOut;
		
		-- Accumulator reset
		AccumRst <= rst or AccRst;
		
		--por padrão quando os mux estiverem ligados o valor carregado será de uma constante LoadImmediate
		
		-- outputs
		
		BankOut      <= DataOutBank;
		AccOut       <= AccumOut;
		flagOverflow <= ULAoverflow;
		flagZero     <= ULAzero;
		flagNegative <= ULAnegative;
		ULAoutp      <= ULAout;
		reg7Out      <= reg7Out_s;
		
	end a_Bank_ULA;
		
