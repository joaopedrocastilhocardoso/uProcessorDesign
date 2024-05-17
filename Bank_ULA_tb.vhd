library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bank_ULA_tb is
end entity;

architecture teste of Bank_ULA_tb is
	component Bank_ULA is
		port(
		clk, rst, BWrEn, AWrEn : in std_logic;
		regCode                : in unsigned (2 downto 0);
		UlaOpCode              : in unsigned (2 downto 0);
		UlaOutp                : out unsigned (15 downto 0);
		flagZero               : out std_logic;
		MuxUlaIn, MuxBankIn    : in std_logic;
		LoadImmediate          : in unsigned (15 downto 0)
		);
	end component;
	
	-- signal definitions
	signal clk_tb, BWrEn_tb, AWrEn_tb, flagZero_tb : std_logic;
	signal MuxBankIn_tb, MuxUlaIn_tb               : std_logic := '0';
	signal rst_tb, finished                        : std_logic := '0';
	signal regCode_tb, UlaOpCode_tb                : unsigned (2 downto 0);
	signal UlaOutp_tb, LoadImmediate_tb            : unsigned (15 downto 0);
	
	-- constants
	
	constant period_time : time := 100 ns;
	constant ZERO        : unsigned(15 downto 0) := "0000000000000000";
	constant UM          : unsigned(15 downto 0) := "0000000000000001";
	constant A           : unsigned(15 downto 0) := "1010101010101010";
	constant B           : unsigned(15 downto 0) := "1011101110111011";
	constant C           : unsigned(15 downto 0) := "1100110011001100";
	constant D           : unsigned(15 downto 0) := "1101110111011101";

	begin
	
	Circuit1 : Bank_ULA
	port map(
		clk           => clk_tb,
		rst           => rst_tb,
		BWrEn         => BWrEn_tb,
		AWrEn         => AWrEn_tb,
		regCode       => regCode_tb,
		UlaOpCode     => UlaOpCode_tb,
		UlaOutp       => UlaOutp_tb,
		flagZero      => flagZero_tb,
		MuxUlaIn      => MuxUlaIn_tb,
		MuxBankIn     => MuxBankIn_tb,
		LoadImmediate => LoadImmediate_tb
	);
	
	sim_time_proc :  process begin -- tempo de simulação
				
		wait for 10 us;
		finished <= '1';
		wait;
	end process sim_time_proc; 
			
	clk_proc : process begin -- sinal de clock					
			while finished /= '1' loop
			clk_tb <= '0';
			wait for period_time/2;
			clk_tb <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
			
	reset_global : process begin -- sinal de reset_global
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
				
	testing_process : process begin -- linha de comandos para o circuito
	
		wait for period_time*2;
		-- instrução : colocar valor A no registrador 5 e setar ula para add
		MuxBankIn_tb <= '1';
		MuxUlaIn_tb <= '0';
		BWrEn_tb <= '1';
		AWrEn_tb <= '0';
		UlaOpCode_tb <= "000";
		regCode_tb <= "101";
		LoadImmediate_tb <= A;
		
		
		wait for period_time*2;
		-- instrução : colocar valor B no registrador 1
		LoadImmediate_tb <= B;
		regCode_tb <= "001";
		
		wait for period_time*2;
		-- instrução : colocar valor UM no registrador 2 e ativar ULA
		LoadImmediate_tb <= UM;
		regCode_tb <= "010";
		MuxUlaIn_tb <= '1'; --ula soma LoadImmediate com 0 do acc
		wait for period_time;
		
		--instrução : colocar valor 1 no acumulador
		AWrEn_tb <= '1';
		BWrEn_tb <= '0';
		
		wait for period_time;
		
		--instrução: soma o A no reg5 do banco com 1 do acumulador
		
		AWrEn_tb <= '0';
		regCode_tb <= "101";
		MuxUlaIn_tb <= '0';
		
		wait for period_time;
		
		--instrução :guarda o valor da operação anterior no acc
		AWrEn_tb <= '1';
		
		wait for period_time;
		
		-- instrução : guarda o valor do acumulador no reg7
		AWrEn_tb <= '0';
		BWrEn_tb <= '1';
		MuxBankIn_tb <= '0';
		regCode_tb <= "111";
		
		wait;
	end process testing_process;
end architecture teste;