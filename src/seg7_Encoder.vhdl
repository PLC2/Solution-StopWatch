library IEEE;
use     IEEE.std_logic_1164.all;

use     work.StopWatch_pkg.all;


entity seg7_Encoder is
	port (
		signal BCDValue  : in  T_BCD;
		signal Dot       : in  std_logic  := '0';
		
		signal Seg7Code  : out std_logic_vector(7 downto 0)
	);
end entity;


architecture rtl of seg7_Encoder is

begin
	process(all)
		variable temp : std_logic_vector(6 downto 0);
	begin
		case BCDValue is -- segments:  GFEDCBA     -- Segment Pos.   Index Pos.
			when x"0" =>        temp := "0111111";   --
			when x"1" =>        temp := "0000110";   --
			when x"2" =>        temp := "1011011";   -- 	 AAA           000
			when x"3" =>        temp := "1001111";   -- 	F   B         5   1
			when x"4" =>        temp := "1100110";   -- 	F   B         5   1
			when x"5" =>        temp := "1101101";   -- 	 GGG           666
			when x"6" =>        temp := "1111101";   -- 	E   C         4   2
			when x"7" =>        temp := "0000111";   -- 	E   C         4   2
			when x"8" =>        temp := "1111111";   -- 	 DDD  DOT      333  7
			when x"9" =>        temp := "1101111";   --
			when x"A" =>        temp := "1110111";   --
			when x"B" =>        temp := "1111100";   --
			when x"C" =>        temp := "0111001";   --
			when x"D" =>        temp := "0111110";   --
			when x"E" =>        temp := "1111001";   --
			when x"F" =>        temp := "1110001";   --
			when others =>      temp := "XXXXXXX";   --
		end case;
		
		Seg7Code <= Dot & temp;
	end process;
end architecture;
