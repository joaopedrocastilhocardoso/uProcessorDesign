library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CtrlUn is
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
	end entity CtrlUn;
	
	architecture a_CtrlUn of CtrlUn is
	
		component PCcomplete is 
		port(
			clk, rst        : in std_logic;
			state, jumpInst : in unsigned(1 downto 0);
			dataIn          : in unsigned(6 downto 0);
			dataOut         : out unsigned(6 downto 0)
		);
		end component;
		
		component ROM is 
		port(	
			clk     : in std_logic;
			address : in unsigned(6 downto 0);
			output  : out unsigned(15 downto 0)
		);
		end component;
		
		component Decoder is 
		port(
			instruction                  : in unsigned(15 downto 0);
			flagULAZero, flagULANegative : in std_logic;
			state                        : in unsigned(1 downto 0);
			
			jumpInst                     : out unsigned(1 downto 0);
			jumpAdrs                     : out unsigned(6 downto 0);
			
			ULAOpCode                    : out unsigned(2 downto 0);
			ConstantToUla                : out unsigned(11 downto 0);
			BankWrEn, AccumulatorWrEn    : out std_logic;
			BankRegCode                  : out unsigned(2 downto 0);
			muxUlaIn, muxBankIn          : out std_logic;
			rstAcc                       : out std_logic;
			ULAFlagsWrEn                 : out std_logic;
			RAMWrEn                      : out std_logic;
			MuxAccIn                     : out std_logic
		);
		end component;
		
		component StateMachine2Bits is
		port(
			clk   : in std_logic;
			rst   : in std_logic;
			state : out unsigned(1 downto 0)
		);
		end component;
		
		-- signal declarations
		
		signal jumpInst_s               : unsigned(1 downto 0) := "00";
		signal state_s                  : unsigned(1 downto 0) := "00";
		signal PCin_s, PCout_s          : unsigned(6 downto 0) := "0000000";
		signal instruction_s            : unsigned(15 downto 0) := "0000000000000000";
		signal BankRegCode_s            : unsigned(2 downto 0) := "000";
		signal ConstantToUla_s          : unsigned (11 downto 0) := "000000000000";
		signal BankWrEn_s, AccWrEn_s    : std_logic := '0';
		signal muxUlaIn_s, muxBankIn_s  : std_logic := '0';
		signal rstAcc_s, ULAFlagsWrEn_s : std_logic := '0';
		signal ULAOpCode_s              : unsigned (2 downto 0) := "000";
		signal RAMWrEn_s, MuxAccIn_s     : std_logic := '0';
		begin
		
		--components declaration
		
		PC0  : PCcomplete port map(
			clk      => clk, 
			rst      => rst, 
			jumpInst => jumpInst_s, 
			state    => state_s, 
			dataIn   => PCin_s, 
			dataOut  => PCout_s
			);
		
		ROM0 : ROM port map(
			clk     => clk, 
			address => PCout_s, 
			output  => instruction_s
		);
		
		Dec0 : Decoder port map(
			instruction     => instruction_s, 
			flagULAZero     => ULAZero, 
			flagULANegative => ULANegative, 
			state           => state_s, 
			jumpInst        => jumpInst_s, 
			jumpAdrs        => PCin_s, 
			ULAOpCode       => ULAOpCode_s, 
			ConstantToUla   => ConstantToUla_s, 
			BankWrEn        => BankWrEn_s, 
			AccumulatorWrEn => AccWrEn_s, 
			BankRegCode     => BankRegCode_s, 
			muxUlaIn        => muxUlaIn_s, 
			muxBankIn       => muxBankIn_s, 
			rstAcc          => rstAcc_s,
			ULAFlagsWrEn    => ULAFlagsWrEn_s,
			RAMWrEn         => RAMWrEn_s,
			MuxAccIn        => MuxAccIn_s
		);
		
		StMach: StateMachine2Bits port map(
			clk   => clk, 
			rst   => rst, 
			state => state_s
		);
		
		-- CPU outputs
		
		MuxAcc        <= MuxAccIn_s;
		ConstantToUla <= ConstantToUla_s;
		ULAOpCode     <= ULAOpCode_s;
		BWrEn         <= BankWrEn_s;
		AccWrEn       <= AccWrEn_s;
		BRegCode      <= BankRegCode_s;
		MUXUla        <= muxUlaIn_s;
		MUXBank       <= muxBankIn_s;
		AccRst        <= rstAcc_s;
		ULAFlagsWrEn  <= ULAFlagsWrEn_s;
		RAMWrEnOut    <= RAMWrEn_s;
		
	end architecture a_CtrlUn;
