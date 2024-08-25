library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
	port(
		clk              : in std_logic;
		inA              : in unsigned (15 downto 0);
		inB              : in unsigned (15 downto 0); --inB is always provided by the accumulator value
		outp             : out unsigned (15 downto 0);
		opCode           : in unsigned (2 downto 0);
		fZero, fNegative : out std_logic;
		fOverflow        : out std_logic
		);
	end ULA;
	
	-- tabela para opcode:
	--000 - adition
	--001 - subtraction
	--010 - increment inA
	--011 - shift left inA
	--100 - multiplication
	--101 - bitwise inversion
	--110 - bitwise and 
	--111 - NOP
	
	
	architecture a_ULA of ULA is
		signal temp_out  : unsigned (15 downto 0) := "0000000000000000";
		signal temp_m    : unsigned (31 downto 0);
		constant VCC     : unsigned (15 downto 0) := "1111111111111111";
		constant ZERO    : unsigned (15 downto 0) := "0000000000000000";
		
		-- signal where extended words will be stored
		signal inA17, inB17, sum17, sub17 : unsigned(16 downto 0);

	begin
			-- Operations for overflow flag usage
			inA17 <= '0' & inA;
			inB17 <= '0' & inB;
			sum17 <= inA17 + inB17;
			sub17 <= inB17 - inA17;
			
			temp_out <= (inA + inB) when opCode = "000" else
						(inB - inA) when opCode = "001" else
						(inA + 1) when opCode = "010" else
						(inA xor VCC) when opCode = "101" else
						(inA and inB) when opCode = "110" else
						ZERO;
						
			temp_m   <= (inA * inB) when opCode = "100" else
						("00000" & inA & "00000000000") when opCode = "011" else
						ZERO & ZERO;
			
			fZero <= '1' when ((temp_out = ZERO and (opCode /= "100" and opCode /= "011")) or (temp_m(15 downto 0) = ZERO and (opCode = "100")) or (temp_m(15 downto 0) /= ZERO and opCode = "011")) else '0';
			
			fOverflow <= '1' when ((opCode = "000" and inA17(15) = '0' and inB17(15) = '0' and sum17(15) = '1') -- sum A and B positive
			or (opCode = "000" and inA17(15) = '1' and inB17(15) = '1' and sum17(16) = '1')                 -- sum A and B negative
			or (opCode = "001" and inB = "00000000000000000" and inA = "1000000000000000")                  -- sub B positive and A negative
			or (opCode = "001" and inA17(15) = '0' and inB17(15) = '1' and sub17(16) = '1'))                -- sub B negative and A positive
			-- for sum A and B when one is negative and the other positive, the total does not provoke overflow, same for sub with same signs
			else '0';
			
			fNegative <= '1' when ((temp_out(15) = '1') or temp_m(31) = '1') else '0';
			
			
			
			
			outp <= temp_m(15 downto 0) when (opCode = "100" or opCode = "011") else temp_out;
	end architecture;
		
		
		
