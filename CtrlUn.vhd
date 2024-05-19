library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CtrlUn is
	port(
		clk, rst : in std_logic
	);
	end entity CtrlUn;
	
	architecture a_CtrlUn of CtrlUn is
	
		component PCcomplete is 
		port(
			clk, wrEn, rst, jumpInst : in std_logic;
			dataIn                   : in unsigned(6 downto 0);
			dataOut                  : out unsigned(6 downto 0)
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
			instruction : in unsigned(15 downto 0);
			jumpInst    : out std_logic;
			jumpAdrs    : out unsigned(6 downto 0)
		);
		end component;
		
		component StateMachine1Bit is
		port(
			clk   : in std_logic;
			rst   : in std_logic;
			state : out std_logic
		);
		end component;
		
		signal WrEn, jumpInst, state : std_logic;
		signal PCin, PCout           : unsigned(6 downto 0);
		signal ROMOut                : unsigned(15 downto 0);
		
		begin
		
		--components declaration
		
		PC0   : PCcomplete port map(clk, state, rst, jumpInst, PCin, PCout);
		ROM0  : ROM port map(clk, PCout, ROMOut);
		Dec0  : Decoder port map (ROMOut, jumpInst, PCin);
		StMach: StateMachine1Bit port map(clk, rst, state);
		
	end architecture a_CtrlUn;