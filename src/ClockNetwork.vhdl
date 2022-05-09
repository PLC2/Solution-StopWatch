library IEEE;
use			IEEE.STD_LOGIC_1164.all;
use			IEEE.NUMERIC_STD.all;

library UNISIM;
use			UNISIM.VCOMPONENTS.all;

library PoC;
use			PoC.utils.all;
--use			PoC.physical.all;
use			PoC.components.all;
--use			PoC.io.all;


entity ClockNetwork is
	generic (
		CLOCK_IN_FREQ             : real                          := 100.0e6
	);
	port (
		ClockIn_100MHz            : in	STD_LOGIC;

		Control_Clock_100MHz      : out	STD_LOGIC;
		
		Clock_200MHz              : out	STD_LOGIC;
		Clock_100MHz              : out	STD_LOGIC;

		Clock_Stable_200MHz       : out	STD_LOGIC;
		Clock_Stable_100MHz       : out	STD_LOGIC
	);
end entity;


architecture rtl of ClockNetwork is
	attribute KEEP                      : BOOLEAN;

	signal MMCM_Locked_async             : STD_LOGIC;
	signal MMCM_Locked                   : STD_LOGIC;

	signal Locked                       : STD_LOGIC;
	
	signal Control_Clock                : STD_LOGIC;
	signal Control_Clock_BUFG           : STD_LOGIC;
	
	signal MMCM_Clock_100MHz             : STD_LOGIC;
	signal MMCM_Clock_200MHz             : STD_LOGIC;

	signal MMCM_Clock_100MHz_BUFG        : STD_LOGIC;
	signal MMCM_Clock_200MHz_BUFG        : STD_LOGIC;
begin
	-- ==================================================================
	-- ResetControl
	-- ==================================================================
	-- synchronize external (async) ClockNetwork_Reset and internal (but async) MMCM_Locked signals to "Control_Clock" domain
	syncControlClock: entity PoC.sync_Bits_Xilinx
		generic map (
			BITS          => 1                    -- number of BITS to synchronize
		)
		port map (
			Clock         => Control_Clock,       -- Clock to be synchronized to
			Input(0)      => MMCM_Locked_async,    -- 
			Output(0)     => MMCM_Locked           -- 
		);

	Locked <= MMCM_Locked;

	-- ==================================================================
	-- ClockBuffers
	-- ==================================================================
	-- Control_Clock
	BUFR_Control_Clock : BUFG
		port map (
			I    => ClockIn_100MHz,
			O    => Control_Clock_BUFG
		);
	
	Control_Clock <= Control_Clock_BUFG;

	-- 100 MHz BUFG
	BUFG_MMCM_Clock_100MHz : BUFG
		port map (
			I    => MMCM_Clock_100MHz,
			O    => MMCM_Clock_100MHz_BUFG
		);

	-- 200 MHz BUFG
	BUFG_MMCM_Clock_200MHz : BUFG
		port map (
			I    => MMCM_Clock_200MHz,
			O    => MMCM_Clock_200MHz_BUFG
		);
		
-- ==================================================================
	-- Mixed-Mode Clock Manager (MMCM)
	-- ==================================================================
	System_MMCM : MMCME2_ADV
		generic map (
			STARTUP_WAIT            => FALSE,
			BANDWIDTH                => "LOW",                                      -- LOW = Jitter Filter
			COMPENSATION            => "BUF_IN",  --"ZHOLD",

			CLKIN1_PERIOD            => 1.0e9 / CLOCK_IN_FREQ,
			CLKIN2_PERIOD            => 1.0e9 / CLOCK_IN_FREQ,        -- Not used
			REF_JITTER1              => 0.00048,
			REF_JITTER2              => 0.00048,                                    -- Not used

			CLKFBOUT_MULT_F          => 10.0,
			CLKFBOUT_PHASE          => 0.0,
			CLKFBOUT_USE_FINE_PS    => FALSE,
			
			DIVCLK_DIVIDE            => 1,
			
			CLKOUT0_DIVIDE_F        => 10.0,
			CLKOUT0_PHASE            => 0.0,
			CLKOUT0_DUTY_CYCLE      => 0.500,
			CLKOUT0_USE_FINE_PS      => FALSE,
			
			CLKOUT1_DIVIDE          => 5,
			CLKOUT1_PHASE            => 0.0,
			CLKOUT1_DUTY_CYCLE      => 0.500,
			CLKOUT1_USE_FINE_PS      => FALSE,
			
			CLKOUT2_DIVIDE          => 8,
			CLKOUT2_PHASE            => 0.0,
			CLKOUT2_DUTY_CYCLE      => 0.500,
			CLKOUT2_USE_FINE_PS      => FALSE,
			
			CLKOUT3_DIVIDE          => 4,
			CLKOUT3_PHASE            => 0.0,
			CLKOUT3_DUTY_CYCLE      => 0.500,
			CLKOUT3_USE_FINE_PS      => FALSE,
			
			CLKOUT4_CASCADE          => FALSE,
			CLKOUT4_DIVIDE          => 100,
			CLKOUT4_PHASE            => 0.0,
			CLKOUT4_DUTY_CYCLE      => 0.500,
			CLKOUT4_USE_FINE_PS      => FALSE
		)
		port map (
			RST                  => '0',

			CLKIN1              => ClockIn_100MHz,
			CLKIN2              => ClockIn_100MHz,
			CLKINSEL            => '1',
			CLKINSTOPPED        => open,
			
			CLKFBOUT            => open,
			CLKFBOUTB            => open,
			CLKFBIN              => MMCM_Clock_100MHz_BUFG,
			CLKFBSTOPPED        => open,
			
			CLKOUT0              => MMCM_Clock_100MHz,
			CLKOUT0B            => open,
			CLKOUT1              => MMCM_Clock_200MHz,
			CLKOUT1B            => open,
			CLKOUT2              => open,
			CLKOUT2B            => open,
			CLKOUT3              => open,
			CLKOUT3B            => open,
			CLKOUT4              => open,
			CLKOUT5              => open,
			CLKOUT6              => open,

			-- Dynamic Reconfiguration Port
			DO                  =>	open,
			DRDY                =>	open,
			DADDR                =>	"0000000",
			DCLK                =>	'0',
			DEN                  =>	'0',
			DI                  =>	x"0000",
			DWE                  =>	'0',

			PWRDWN              =>	'0',			
			LOCKED              =>	MMCM_Locked_async,
			
			PSCLK                =>	'0',
			PSEN                =>	'0',
			PSINCDEC            =>	'0', 
			PSDONE              =>	open				 
		);
		
	Control_Clock_100MHz  <= Control_Clock_BUFG;
	Clock_200MHz          <= MMCM_Clock_200MHz_BUFG;
	Clock_100MHz          <= MMCM_Clock_100MHz_BUFG;

	-- synchronize internal Locked signal to output clock domains
	syncLocked200MHz: entity PoC.sync_Bits_Xilinx
		port map (
			Clock         => MMCM_Clock_200MHz_BUFG,     -- Clock to be synchronized to
			Input(0)      => Locked,                    -- Data to be synchronized
			Output(0)     => Clock_Stable_200MHz        -- synchronized data
		);

	syncLocked100MHz: entity PoC.sync_Bits_Xilinx
		port map (
			Clock         => MMCM_Clock_100MHz_BUFG,     -- Clock to be synchronized to
			Input(0)      => Locked,                    -- Data to be synchronized
			Output(0)     => Clock_Stable_100MHz        -- synchronized data
		);
end architecture;