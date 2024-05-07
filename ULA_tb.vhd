library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end ULA_tb;

architecture teste of ULA_tb is
    component ULA
        port(
            inA : in unsigned (15 downto 0);
            inB : in unsigned (15 downto 0);
            outp: out unsigned (15 downto 0);
            opCode : in unsigned (2 downto 0);
            fZero : out std_logic
        );
    end component;

    signal tb_inA, tb_inB, tb_outp : unsigned (15 downto 0);
    signal tb_opCode : unsigned (2 downto 0) := "000";
    signal tb_fZero : std_logic;
    constant X : unsigned (15 downto 0) := "0110011011000111";
    constant Y : unsigned (15 downto 0) := "0011110100111101";
    constant Z : unsigned (15 downto 0) := "0000000000000010";
	constant ZERO: unsigned (15 downto 0) := "0000000000000000";
    
begin
    ULA_1 : ULA
        port map (
            inA => tb_inA,
            inB => tb_inB,
            outp => tb_outp,
            opCode => tb_opCode,
            fZero => tb_fZero
        );

    process begin
        tb_opCode <= "000";
        tb_inA <= X;
        tb_inB <= Y;
        wait for 50 ns;

        tb_opCode <= "001";
        tb_inA <= X;
        tb_inB <= X;
        wait for 50 ns;

        tb_opCode <= "010";
        tb_inA <= X;
        wait for 50 ns;

        tb_opCode <= "011";
        tb_inA <= X;
        wait for 50 ns;

        tb_opCode <= "100";
        tb_inA <= X;
        tb_inB <= Z;
        wait for 50 ns;
		
		tb_opCode <= "100";
        tb_inA <= X;
        tb_inB <= ZERO;
        wait for 50 ns;

        tb_opCode <= "101";
        tb_inA <= X;
        wait for 50 ns;

        tb_opCode <= "110";
        tb_inA <= X;
        tb_inB <= Y;
        wait for 50 ns;

        tb_opCode <= "111";
        wait for 50 ns;

        wait;
    end process;
end teste;