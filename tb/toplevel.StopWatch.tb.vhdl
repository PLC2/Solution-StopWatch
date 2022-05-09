library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

library lib_StopWatch;
use     lib_StopWatch.Utilities_pkg.all;
use     lib_StopWatch.StopWatch_pkg.all;


entity toplevel_tb is
end entity;


architecture tb of toplevel_tb is
	constant CLOCK_FREQ   : frequency := 100 MHz;
	constant CLOCK_PERIOD : time      := to_time(CLOCK_FREQ);

	signal StopSimulation : std_logic := '0';
	signal Clock          : std_logic := '1';
	signal Reset          : std_logic := '1';
	
	signal StartButton    : std_logic := '0';
	
begin
	StopSimulation <= '1' after 30 ms;

	Clock <= (Clock xnor StopSimulation) after CLOCK_PERIOD / 2;
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

	DUT: entity lib_StopWatch.toplevel
		generic map (
			CLOCK_FREQ                  => CLOCK_FREQ
		)
		port map (
			NexysA7_SystemClock         => Clock,
			NexysA7_GPIO_Button_Reset_n => Reset,
			
			NexysA7_GPIO_Button(0)      => StartButton,
			NexysA7_GPIO_Seg7_Cathode_n => open,
			NexysA7_GPIO_Seg7_Anode_n   => open
		);
	
end architecture;
