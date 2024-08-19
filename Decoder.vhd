library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
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
	end entity Decoder;
	
architecture a_Decoder of Decoder is
	
	-- signal declarations
	signal instrOpcode   : unsigned(3 downto 0);
	
	--constant declarations
	
	constant FETCH   : unsigned(1 downto 0):= "00";
	constant DECODE  : unsigned(1 downto 0):= "01";
	constant EXECUTE : unsigned(1 downto 0):= "10";
	
	begin
	
	-- extract opcode from instruction
	instrOpcode <= instruction(15 downto 12);
	
	-- Register Bank inputs
	BankWrEn <= '1' when ((instrOpcode = "0001" or instrOpcode = "0010") and state = EXECUTE) else '0';
	BankRegCode <= instruction(11 downto 9);
	muxBankIn <= '1' when instrOpcode = "0001" else '0';
	
	--Accumulator inputs
	rstAcc <= '1' when instrOpcode = "0011" and state = EXECUTE else '0';
	AccumulatorWrEn <= '1' when (instrOpcode(3 downto 1) = "010" or instrOpcode = "0110" or instrOpcode = "1011") and state = EXECUTE else '0';
	
	MuxAccIn <= '0' when instrOpcode = "1011" else '1';
	
	--ULA inputs
	ULAOpCode <= "000" when (instrOpcode = "0100") else
				 "001" when (instrOpcode = "0101" or instrOpcode = "0110" or instrOpcode = "1010") else
				 "011" when (instrOpcode = "1101") else "111";
				 
	ConstantToUla <= ("000" & instruction(8 downto 0)) when instrOpcode = "0001" else instruction(11 downto 0);
	
	muxUlaIn <= '1' when (instrOpcode = "0110") else '0';
	
	ULAFlagsWrEn <= '1' when (instrOpcode = "0100" or instrOpcode = "0101"or instrOpcode = "0110" or instrOpcode = "1010" or instrOpcode = "1101") else '0';
	
	--PC inputs
	jumpInst  <= "01" when (instrOpcode = "0111" and state = FETCH) else 
				 "10" when (((instrOpcode = "1000" and flagULAZero = '1') or (instrOpcode = "1001" and flagULANegative = '1')) and state = FETCH) else
				 "00";
	jumpAdrs <= instruction(6 downto 0);
	
	--RAM inputs
	
	RAMWrEn <= '1' when (instrOpcode = "1100") else '0';
	
	
end architecture;
