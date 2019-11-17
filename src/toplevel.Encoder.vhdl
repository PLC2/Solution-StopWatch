library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

use     work.Utilities.all;
use     work.StopWatch_pkg.all;


entity toplevel is
	generic (
		constant CLOCK_PERIOD_NS : positive := 10
	);
	port (
		Switch         : in  std_logic_vector(3 downto 0);

		Seg7_Cathode_n : out std_logic_vector(7 downto 0);
		Seg7_Anode_n   : out std_logic_vector(7 downto 0)
	);
end entity;


architecture trl of toplevel is
	signal Cathode : std_logic_vector(7 downto 0);
	signal Anode   : std_logic_vector(7 downto 0);

begin
	
	-- 7-segment encoder
	encoder: entity work.seg7_Encoder
		port map (
			BCDValue  => unsigned(Switch),
			Dot       => '1',
			
			Seg7Code  => Cathode
		);

	-- convert low-active outputs
	Seg7_Cathode_n <= not Cathode;
	Seg7_Anode_n   <= not x"01";
end architecture;
