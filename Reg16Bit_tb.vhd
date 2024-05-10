library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg16Bit_tb is
end entity;

architecture test of Reg16Bit_tb is
	component Reg16Bit
		port(
		clk     : in std_logic;  --Clock signal
		wrEn    : in std_logic;  --Write enable pin
		rst     : in std_logic;  --Reset pin
		dataIn  : in unsigned (15 downto 0);
		dataOut : out unsigned (15 downto 0)
		);
	end component;

	--Testbench signal declarations
	
	signal tb_clk, tb_wrEn, tb_rst : std_logic;
	signal tb_dataIn, tb_dataOut   : unsigned (15 downto 0);
	signal finished                : std_logic := '0';

	--Constants for testbench declarations

	constant period_time           : time      := 100 ns;
	constant VCC                   : unsigned (15 downto 0) := "1111111111111111";
	constant GND                   : unsigned (15 downto 0) := "0000000000000000";
	constant X                     : unsigned (15 downto 0) := "0110110010100101";
	constant Y                     : unsigned (15 downto 0) := "1010101010101010";
	
	begin
	
		Reg1 : Reg16Bit
		port map(
			clk     => tb_clk,
			wrEn    => tb_wrEn,
			rst     => tb_rst,
			dataIn  => tb_dataIn,
			dataOut => tb_dataOut
		);
			
		reset_global : process begin -- Reset signal
		
			tb_rst <= '1';
			wait for period_time*2;
			tb_rst <= '0';
			wait;
		end process reset_global;
		
		sim_time_proc : process begin -- Total simulation time
			wait for 10 us;
			finished <= '1';
			wait;
		end process sim_time_proc;
		
		clk_proc : process begin -- Clock signal
		
			while finished /= '1' loop
				tb_clk <= '0';
				wait for period_time/2;
				tb_clk <= '1';
				wait for period_time/2;
			end loop;
			wait;
		end process clk_proc;
		
		testing_process : process begin -- Command line for testing
			wait for period_time*2;
			tb_wrEn <= '0';
			tb_dataIn <= VCC;
			wait for period_time;
			tb_dataIn <= X;
			wait for period_time;
			tb_dataIn <= Y;
			tb_wrEn <= '1';
			wait for period_time*2;
			tb_wrEn <= '0';
			tb_dataIn <= X;
			wait for period_time*2;
			tb_wrEn <= '1';
			wait for period_time*2;
			tb_wrEn <= '0';
			tb_rst <= '1';
			wait for period_time*2;
			tb_rst <= '0';
			wait;
		end process testing_process;
	end architecture test;
