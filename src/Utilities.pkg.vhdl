library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;
use     IEEE.math_real.all;

package Utilities_pkg is
	type frequency is range integer'low to integer'high units
		Hz;
		kHz = 1000 Hz;
		MHz = 1000 kHz;
		GHz = 1000 MHz;
		THz = 1000 GHz;
	end units;

	-- deferred constant
	constant IS_SIMULATION : boolean;
	
	function ite(condition : boolean; ThenValue : time; ElseValue : time) return time;
	
	function log2(Value : positive) return natural;
	
	function bin2onehot(binary : std_logic_vector; bits : natural := 0) return std_logic_vector;
	function bin2onehot(binary : unsigned;         bits : natural := 0) return std_logic_vector;
	
	function to_index(value : unsigned; max : positive) return natural;
	function to_index(value : natural;  max : positive) return natural;
	
	function to_time(f : frequency) return time;
	function to_frequency(t : time) return frequency;
	
	function TimingToCycles(Timing : time;      Clock_Frequency: frequency) return natural;
	function TimingToCycles(Timing : frequency; Clock_Frequency: frequency) return natural;
end package;


package body Utilities_pkg is
	function simulation return boolean is
		variable result : boolean := FALSE;
	begin
		-- synthesis translate_off
		result := TRUE;
		-- synthesis translate_on
		return result;
	end function;

	-- deferred constant initialization
	constant IS_SIMULATION : boolean := simulation;
	
	function ite(condition : boolean; ThenValue : time; ElseValue : time) return time is
	begin
		if condition then
			return ThenValue;
		else
			return ElseValue;
		end if;
	end function;
	
	function log2(Value : positive) return natural is
	begin
		for i in 0 to 31 loop
			if 2**i >= Value then
				return i;
			end if;
		end loop;
		
		return 0;
	end function;
	
	function bin2onehot(binary : std_logic_vector; bits : natural := 0) return std_logic_vector is
	begin
		return bin2onehot(unsigned(binary), bits);
	end function;
	
	function bin2onehot(binary : unsigned; bits : natural := 0) return std_logic_vector is
		variable result : std_logic_vector(2**binary'length - 1 downto 0) := (others => '0');
	begin
		result(to_integer(binary)) := '1';
		
		if (bits = 0) then
			return result;
		else
			return result(bits - 1 downto 0);
		end if;
	end function;
	
	function to_index(value : unsigned; max : positive) return natural is
	begin
		return to_index(to_integer(value), max);
	end function;
	
	function to_index(value : natural; max : positive) return natural is
	begin
		if (value <= max) then
			return value;
		else
			return max;
		end if;
		-- return minimum(value, max);
	end function;
	
	function to_time(f : frequency) return time is
	begin
		return (1.0 / real(f / Hz)) * sec;
	end function;
	
	function to_frequency(t : time) return frequency is
	begin
		return (1.0 / real(t / sec)) * Hz;
	end function;
	
	function TimingToCycles(timing : frequency; Clock_Frequency : frequency) return natural is
		constant delay : time := to_time(timing);
	begin
		report "TimingToCycles(freq, freq): delay=" & time'image(delay) severity note;
		
		return TimingToCycles(delay, Clock_Frequency);
	end function;

	function TimingToCycles(timing : time; Clock_Frequency : frequency) return natural is
		constant period : time := to_time(Clock_Frequency);
	begin
		report "TimingToCycles(time, freq): period=" & time'image(period) severity note;
	
		return natural(ceil(real(timing / fs) / real(period / fs)));
	end function;
end package body;
