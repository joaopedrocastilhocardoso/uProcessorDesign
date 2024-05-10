library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is -- Arithmetic Logic Unit, Unidade Lógico Aritmética in portuguese
	port(
		inA : in unsigned (15 downto 0);
		inB : in unsigned (15 downto 0);
		outp: out unsigned (15 downto 0);
		opCode : in unsigned (2 downto 0);
		fZero : out std_logic
		);
	end ULA;
	
	-- Opcode Table:
	--000 - addition
	--001 - subtraction
	--010 - Increment
	--011 - Decrement
	--100 - Multiplication
	--101 - Bitwise inversion
	--110 - Bitwise and
	--111 - Bitwise or
	
	
	architecture a_ULA of ULA is
		signal temp_out: unsigned (15 downto 0) := "0000000000000000";
		signal temp_m: unsigned (31 downto 0);
		constant VCC : unsigned (15 downto 0) := "1111111111111111";
		constant ZERO : unsigned (15 downto 0) := "0000000000000000";

	begin
		process(opCode, inA, inB)
			begin
			case opCode is
		
				when "000" =>
					temp_out <= (inA + inB);
				when "001" =>
					temp_out <= (inA - inB);
				when "010" =>
					temp_out <= (inA + 1);
				when "011" =>
					temp_out <= (inA - 1);
				when "100" =>
					temp_m <= (inA*inB);
				when "101" =>
					temp_out <= inA xor VCC;
				when "110" =>
					temp_out <= inA and inB;
				when "111" =>
					temp_out <= inA or inB;
				when others =>
					temp_out <= (others => '0');
			end case;
        
		end process;	
			
			fZero <= '1' when ((temp_out = ZERO and opCode /= "100") or (temp_m(15 downto 0) = ZERO and opCode = "100")) else'0';
			outp <= temp_m(15 downto 0) when opCode = "100" else temp_out;
	end architecture;
		
		
		
