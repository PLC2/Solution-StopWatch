library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

library PoC;

use     work.Utilities_pkg.all;
use     work.StopWatch_pkg.all;


entity toplevel is
	generic (
		constant CLOCK_FREQ                : frequency := 100 MHz
	);
	port (
		signal NexysA7_SystemClock         : in  std_logic;
		signal NexysA7_GPIO_Button_Reset_n : in  std_logic;
		
		signal NexysA7_GPIO_Button         : in  std_logic_vector(0 downto 0);
		signal NexysA7_GPIO_Seg7_Cathode_n : out std_logic_vector(7 downto 0);
		signal NexysA7_GPIO_Seg7_Anode_n   : out std_logic_vector(7 downto 0)
	);
end entity;


architecture rtl of toplevel is
	constant STOPWATCH_CONFIGURATION : T_STOPWATCH_CONFIGURATION := (
--		0 => (Modulo => 10, Dot => '0'),
--		1 => (Modulo => 10, Dot => '0'),
		0 => (Modulo => 10, Dot => '0'),
		1 => (Modulo =>  6, Dot => '0'),
		2 => (Modulo => 10, Dot => '0'),
		3 => (Modulo =>  6, Dot => '0')
	);
	
	signal SystemClock      : std_logic;
	
	signal Board_Reset      : std_logic;
	signal Board_Reset_sync : std_logic;
	
	signal GPIO_Button_sync : NexysA7_GPIO_Button'subtype;
	
	signal Deb_Reset    : std_logic;
	signal Deb_Start    : std_logic;
	signal Deb_Start_d  : std_logic := '0';
	signal Deb_Start_re : std_logic;
	
	signal Reset        : std_logic;
	signal Start        : std_logic;
	
	signal Digits  : T_BCD_Vector(STOPWATCH_CONFIGURATION'length - 1 downto 0);
	
	signal Cathode : std_logic_vector(7 downto 0);
	signal Anode   : std_logic_vector(Digits'range);

begin
	-- convert from low-active inputs
	Board_Reset <= not NexysA7_GPIO_Button_Reset_n;

	clkNet: entity PoC.ClockNetwork
		generic map (
			CLOCK_IN_FREQ             => 100.0e6
		)
		port map (
			ClockIn_100MHz            => NexysA7_SystemClock,
	
			Control_Clock_100MHz      => open,
			
			Clock_200MHz              => open,
			Clock_100MHz              => SystemClock,
	
			Clock_Stable_200MHz       => open,
			Clock_Stable_100MHz       => open
		);

	inputSync: entity PoC.sync_Bits_Xilinx
			generic map (
				BITS          => NexysA7_GPIO_Button'length + 1              -- number of BITS to synchronize
			)
			port map (
				Clock                               => SystemClock,          -- Clock to be synchronized to
				Input(NexysA7_GPIO_Button'range)    => NexysA7_GPIO_Button,  -- 
				Input(NexysA7_GPIO_Button'length)   => Board_Reset,          -- 
				Output(NexysA7_GPIO_Button'range)   => GPIO_Button_sync,     -- 
				Output(NexysA7_GPIO_Button'length)  => Board_Reset_sync      -- 
			);

	-- Debounce input signals
	deb: entity work.Debouncer
		generic map (
			CLOCK_FREQ  => CLOCK_FREQ,
			BITS        => 2
		)
		port map (
			Clock       => SystemClock,
			
			Input(0)    => Board_Reset_sync,
			Input(1)    => GPIO_Button_sync(0),
			Output(0)   => Deb_Reset,
			Output(1)   => Deb_Start
		);

	Reset <= Deb_Reset;
		
	-- Rising edge detection
	Deb_Start_d  <= Deb_Start when rising_edge(SystemClock);
	Deb_Start_re <= not Deb_Start_d and Deb_Start;
	
	-- renaming
	Start <= Deb_Start_re;
	
	-- Stopwatch
	sw: entity work.Stopwatch
		generic map (
			CLOCK_FREQ  => CLOCK_FREQ,
			
			TIMEBASE    => 10 ms,
			CONFIG      => STOPWATCH_CONFIGURATION
		)
		port map (
			Clock  => SystemClock,
			Reset  => Reset,

			Start  => Start,

			Digits => Digits
		);
	
	-- 7-segment display
	display: entity work.seg7_Display
		generic map (
			CLOCK_FREQ    => CLOCK_FREQ,
			DIGITS        => Digits'length
		)
		port map (
			Clock         => SystemClock,

			DigitValues   => Digits,
			
			Seg7_Segments => Cathode,
			Seg7_Selects  => Anode
		);

	-- convert to low-active outputs
	NexysA7_GPIO_Seg7_Cathode_n <= not Cathode                                                               when rising_edge(SystemClock);
	NexysA7_GPIO_Seg7_Anode_n   <= not ((NexysA7_GPIO_Seg7_Anode_n'high downto Anode'length => '0') & Anode) when rising_edge(SystemClock);
end architecture;
