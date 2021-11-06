library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

use     work.Utilities_pkg.all;


entity Counter is
	generic (
		constant MODULO : positive;
		constant BITS   : natural := log2(MODULO)
	);
	port (
		signal Clock      : in  std_logic;
		signal Reset      : in  std_logic;
		signal Enable     : in  std_logic;
		
		signal Value      : out unsigned(BITS - 1 downto 0);
		signal WrapAround : out std_logic
	);
end entity;


architecture rtl of Counter is
	signal CounterValue : unsigned(log2(MODULO) - 1 downto 0) := (others => '0');

begin
	process (Clock)
	begin
		if rising_edge(Clock) then
			if ((Reset or WrapAround) = '1') then
				CounterValue <= (others => '0');
			elsif (Enable = '1') then
				CounterValue <= CounterValue + 1;
			end if;
		end if;
	end process;
	
	Value      <= resize(CounterValue, BITS);
	WrapAround <= Enable when (CounterValue = MODULO - 1) else '0';
end architecture;
