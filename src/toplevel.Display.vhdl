library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

use     work.Utilities.all;
use     work.StopWatch_pkg.all;


entity toplevel is
	generic (
		constant CLOCK_PERIOD : time := 10 ns
	);
	port (
		Clock          : in  std_logic;
		
		Switch         : in  std_logic_vector(15 downto 0);
		
		Seg7_Cathode_n : out std_logic_vector(7 downto 0);
		Seg7_Anode_n   : out std_logic_vector(7 downto 0)
	);
end entity;


architecture trl of toplevel is
	signal Digits   : T_BCD_Vector(5 downto 0);

	signal Cathode  : std_logic_vector(7 downto 0);
	signal Anode    : std_logic_vector(Digits'range);

begin
	-- connect switches to first 4 digits
	genDigits: for i in 0 to 3 generate
		Digits(i) <= unsigned(Switch(i * 4 + 3 downto i * 4));
	end generate;

	-- do arithmetic calculations on next 2 digits
	Digits(4) <= Digits(1) + Digits(0);
	Digits(5) <= Digits(3) - Digits(2);
	

	-- 7-segment display
	display: entity work.seg7_Display
		generic map (
			CLOCK_PERIOD  => CLOCK_PERIOD,
			DIGITS        => Digits'length
		)
		port map (
			Clock         => Clock,

			DigitValues   => Digits,
			DotValues     => 6d"16",
			
			Seg7_Segments => Cathode,
			Seg7_Selects  => Anode
		);

	-- convert low-active outputs
	Seg7_Cathode_n <= not Cathode;
	Seg7_Anode_n   <= not ((Seg7_Anode_n'high downto Anode'length => '0') & Anode);
end architecture;
