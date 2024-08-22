library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgrammableCalc is
	port(
		clk, rst : in std_logic
	);
	end entity ProgrammableCalc;
	
architecture a_ProgrammableCalc of ProgrammableCalc is
	
	component CtrlUn is
	port(
		clk, rst, ULAZero, ULANegative : in std_logic;
		ULAOpCode, BRegCode            : out unsigned(2 downto 0);
		ConstantToUla                  : out unsigned(11 downto 0);
		BWrEn, AccWrEn                 : out std_logic;
		MUXBank, MUXUla, MuxAcc        : out std_logic;
		AccRst                         : out std_logic;
		ULAFlagsWrEn                   : out std_logic;
		RAMWrEnOut                     : out std_logic
	);
	end component;
	
	component Bank_ULA is
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
	end component;
	
	component RAM is
	port(
		clk     : in std_logic;
		address : in unsigned(15 downto 0);
		wrEn    : in std_logic;
		dataIn  : in unsigned(15 downto 0);
		dataOut : out unsigned(15 downto 0)
	);
	end component;
	
	component Reg1Bit is
	port(
		clk     : in std_logic;
		wrEn    : in std_logic;
		rst     : in std_logic;
		dataIn  : in std_logic;
		dataOut : out std_logic
	);
	end component;
	-- Signal declarations
	
	signal ULAZero_s, ULANegative_s, ULAOverflow_s       : std_logic;
	signal ULAOpCode_s, BRegCode_s                       : unsigned(2 downto 0);
	signal ConstantToUla_s                               : unsigned(11 downto 0);
	signal BWrEn_s, AccWrEn_s, AccRst_s                  : std_logic;
	signal MuxBankIn_s, MuxULAIn_s, MuxAccIn_s           : std_logic;
	signal ULAOut_s                                      : unsigned(15 downto 0);
	signal ULAFlagsWrEn_s                                : std_logic;
	signal BankOut_s, AccOut_s, RAMOut_s, reg7Out_s      : unsigned(15 downto 0);
	signal RAMWrEn_s                                     : std_logic;
	signal ULAZeroFF_s, ULANegativeFF_s, ULAOverflowFF_s : std_logic;
	
	begin
	-- Component declarations
	
	CtrlUn0 : CtrlUn port map(
		clk           => clk, 
		rst           => rst, 
		ULAZero       => ULAZeroFF_s, 
		ULANegative   => ULANegativeFF_s, 
		ULAOpCode     => ULAOpCode_s, 
		BRegCode      => BRegCode_s, 
		ConstantToUla => ConstantToUla_s, 
		BWrEn         => BWrEn_s, 
		AccWrEn       => AccWrEn_s, 
		MuxBank       => MuxBankIn_s,
		MuxUla        => MuxULAIn_s, 
		MuxAcc        => MuxAccIn_s,
		AccRst        => AccRst_s,
		ULAFlagsWrEn  => ULAFlagsWrEn_s,
		RAMWrEnOut    => RAMWrEn_s
	);
	
	ULABANK0 : Bank_ULA port map(
		clk           => clk, 
		rst           => rst, 
		BWrEn         => BWrEn_s, 
		AWrEn         => AccWrEn_s,
		AccRst        => AccRst_s,
		regCode       => BRegCode_s, 
		ULAOpCode     => ULAOpCode_s, 
		UlaOutp       => ULAOut_s, 
		flagZero      => ULAZero_s, 
		flagNegative  => ULANegative_s,
		flagOverflow  => ULAOverflow_s,
		MuxUlaIn      => MuxULAIn_s, 
		MuxBankIn     => MuxBankIn_s, 
		MuxAccIn      => MuxAccIn_s,
		LoadImmediate => ConstantToUla_s,
		BankOut       => BankOut_s,
		AccOut        => AccOut_s,
		RAMOut        => RAMOut_s,
		reg7Out       => reg7Out_s
	);
	
	RAM0 : RAM port map(
		clk      => clk,
		address  => BankOut_s,
		wrEn     => RAMWrEn_s,
		dataIn   => AccOut_s,
		dataOut  => RAMOut_s
	);
	
	ffFlagZero : Reg1Bit port map(
		clk     => clk,
		wrEn    => ULAFlagsWrEn_s,
		rst     => rst,
		dataIn  => ULAZero_s,
		dataOut => ULAZeroFF_s
	);
	
	ffFlagNegative : Reg1Bit port map(
		clk     => clk,
		wrEn    => ULAFlagsWrEn_s,
		rst     => rst,
		dataIn  => ULANegative_s,
		dataOut => ULANegativeFF_s
	);
	
	ffFlagOverload : Reg1Bit port map(
		clk     => clk,
		wrEn    => ULAFlagsWrEn_s,
		rst     => rst,
		dataIn  => ULAOverflow_s,
		dataOut => ULAOverflowFF_s
	);
	
end architecture a_ProgrammableCalc;
