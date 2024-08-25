library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	port(	clk     : in std_logic;
			address : in unsigned(6 downto 0);
			output  : out unsigned(15 downto 0)
		);
end entity;

architecture a_ROM of ROM is
	type mem is array (0 to 127) of unsigned (15 downto 0);
	constant conteudo_rom : mem :=( -- ROM content
		
		0   => "0001001000000011", -- loads value 3 into register 1
		1   => "0001010000000001", -- loads value 1 into reg 2
		2   => "0100001000000000", -- add r1 into acc
		3   => "0110000000000001", -- subi 1
		4   => "0101010000000000", -- sub a r2
		
		
		127 => "0111000000111110", -- check if instruction 127 is executed
		
		others => (others => '0')
	);
	--Operations table:

	-- name | opcode | format |                   description                  |
	-- nop  |  0000  |   O    | does nothing                                   |
	-- ld   |  0001  |   R    | load constant into register                    |
	-- mv   |  0010  |   R    | store accumulator into register                |
	-- rsta |  0011  |   O    | reset accumulator value                        |
	-- add  |  0100  |   R    | add register into accumulator                  |
	-- sub  |  0101  |   R    | subtract register from accumulator             |
	-- subi |  0110  |   I    | subtract constant from accumulator             |
	-- bet  |  0111  |   B    | branch every time                              |
	-- beq  |  1000  |   B    | branch if zero ULA flag set                    |
	-- blt  |  1001  |   B    | branch if ULA flag negative set                |
	-- cmp  |  1010  |   R    | Compares Accumulator to register set ula flags |
	-- lw   |  1011  |   M    | loads word in RAM into Accumulator             |
	-- sw   |  1100  |   M    | store word from accumulator into RAM           |
	-- sll  |  1101  |   R    | shifts 11 bits for end loop detection          |

	-- Format table:

	-- format |        bit disposition         |             description            |
	-- 	  R   | opcode(4) - rs (3) - cte (9)   | operation with register            |
	--    I   | opcode(4) - cte(12)            | operation with constant            |
	--    B   | opcode(4) - n/a (5) - adrs (7) | branch operation                   |
	--    O   | opcode(4) - n/a (12)           | operation only dependant on opcode |
	--    M   | opcode(4) - rs (3) - n/a (5)   | memory operation                   |
	
	begin
		
	process(clk) begin
			
		if(rising_edge(clk)) then
			output <= conteudo_rom(to_integer(address));
		end if;
	end process;
end architecture;	