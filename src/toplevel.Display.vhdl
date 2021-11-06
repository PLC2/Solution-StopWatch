library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

use     work.Utilities_pkg.all;
use     work.StopWatch_pkg.all;


entity toplevel is
	generic (
		constant CLOCK_FREQ         : freq := 100 MHz
	);
	port (
		NexysA7_SystemClock         : in  std_logic;
		
		NexysA7_GPIO_Switch         : in  std_logic_vector(15 downto 0);
		
		NexysA7_GPIO_Seg7_Cathode_n : out std_logic_vector(7 downto 0);
		NexysA7_GPIO_Seg7_Anode_n   : out std_logic_vector(7 downto 0)
	);
end entity;


architecture rtl of toplevel is
	signal Digits   : T_BCD_Vector(5 downto 0);

	signal Cathode  : std_logic_vector(7 downto 0);
	signal Anode    : std_logic_vector(Digits'range);

begin
	-- connect switches to first 4 digits
	genDigits: for i in 0 to 3 generate
		Digits(i) <= unsigned(NexysA7_GPIO_Switch(i * 4 + 3 downto i * 4));
	end generate;

	-- do arithmetic calculations on next 2 digits
	Digits(4) <= Digits(1) + Digits(0);
	Digits(5) <= Digits(3) - Digits(2);
	

	-- 7-segment display
	display: entity work.seg7_Display
		generic map (
			CLOCK_FREQ    => CLOCK_FREQ,
			DIGITS        => Digits'length
		)
		port map (
			Clock         => NexysA7_SystemClock,

			DigitValues   => Digits,
			DotValues     => 6d"16",
			
			Seg7_Segments => Cathode,
			Seg7_Selects  => Anode
		);

	-- convert low-active outputs
	NexysA7_GPIO_Seg7_Cathode_n <= not Cathode when rising_edge(NexysA7_SystemClock);
	NexysA7_GPIO_Seg7_Anode_n   <= not ((NexysA7_GPIO_Seg7_Anode_n'high downto Anode'length => '0') & Anode) when rising_edge(NexysA7_SystemClock);
end architecture;
