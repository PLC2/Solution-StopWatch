library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

library lib_StopWatch;
use     lib_StopWatch.Utilities_pkg.all;
use     lib_StopWatch.StopWatch_pkg.all;


entity stopwatch_tb is
end entity;


architecture tb of stopwatch_tb is
	constant STOPWATCH_CONFIGURATION : T_STOPWATCH_CONFIGURATION := (
	--		0 => (Modulo => 10, Dot => '0'),
	--		1 => (Modulo => 10, Dot => '0'),
		0 => (Modulo => 10, Dot => '0'),
		1 => (Modulo =>  6, Dot => '0'),
		2 => (Modulo => 10, Dot => '0'),
		3 => (Modulo =>  6, Dot => '0')
	);

	constant CLOCK_PERIOD : time      := 10 ns;  -- 100 MHz

	signal Clock          : std_logic := '1';
	signal Reset          : std_logic := '1';
	
	signal StartButton    : std_logic := '0';
	
	signal Digits         : T_BCD_Vector(3 downto 0);
begin
	Clock <= not Clock after CLOCK_PERIOD / 2;
	Reset <= '0' after 2 us,
	         '1' after 3 us,
	         '0' after 20 ms,
	         '1' after 20 ms + 2 us;
	StartButton <= '1' after 10 us,
	               '0' after 15 us,
	               '1' after 10 ms,
	               '0' after 10 ms + 1 us,
	               '1' after 12 ms,
	               '0' after 12 ms + 2 us,
	               '1' after 22 ms,
	               '0' after 22 ms + 2 us;

	DUT: entity lib_StopWatch.Stopwatch
		generic map (
			CLOCK_FREQ  => 100 MHz,
			
			TIMEBASE    => 1 sec,
			CONFIG      => STOPWATCH_CONFIGURATION
		)
		port map (
			Clock  => Clock,
			Reset  => Reset,

			Start  => StartButton,

			Digits => Digits
		);
end architecture;
