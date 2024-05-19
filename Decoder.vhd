library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	port(
		instruction : in unsigned(15 downto 0);
		jumpInst    : out std_logic;
		jumpAdrs    : out unsigned(6 downto 0)
	);
	end entity Decoder;
	
architecture a_Decoder of Decoder is
	
	-- signal declarations
	signal opcode : unsigned(3 downto 0);
	
	--constant declarations
	
	constant JUMP_OPC : unsigned(3 downto 0) := "1111";
	
	begin
	
	-- extrai o opcode
	opcode <= instruction(15 downto 12);

	jumpInst <= '1' when opcode = JUMP_OPC else '0';
	jumpAdrs <= instruction(6 downto 0);
	
end architecture;