library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

use     work.Utilities.all;
use     work.StopWatch_pkg.all;

entity Stopwatch is
	generic (
		CLOCK_PERIOD_NS : positive := 10;
		
		TIMEBASE_MS     : positive;
		CONFIG          : T_STOPWATCH_CONFIGURATION
	);
	port (
		Clock  : in  std_logic;
		Reset  : in  std_logic;
		
		Start  : in  std_logic;
		
		Digits : out T_BCD_Vector(CONFIG'length - 1 downto 0);
		Dots   : out std_logic_vector(CONFIG'length - 1 downto 0)
	);
end entity;


architecture trl of Stopwatch is
	type T_STATE is (ST_RESET, ST_IDLE, ST_COUNTING, ST_PAUSE);

	signal State      : T_STATE := ST_IDLE;
	signal NextState  : T_STATE;
	
	signal FSM_Reset  : std_logic;
	signal FSM_Enable : std_logic;
	
	signal Tick       : std_logic;
	signal Overflows  : std_logic_vector(CONFIG'length downto 0);
	
	
begin
	process(Clock)
	begin
		if rising_edge(Clock) then
			if (Reset = '1') then
				State <= ST_RESET;
			else
				State <= NextState;
			end if;
		end if;
	end process;
	
	process(State, Start)
	begin
		NextState  <= State;
	
		FSM_Reset  <= '0';
		FSM_Enable <= '0';
		
		case State is
			when ST_RESET =>
				FSM_Reset <= '1';
				NextState <= ST_IDLE;
				
			when ST_IDLE =>
				if (Start = '1') then
					NextState <= ST_COUNTING;
				end if;
			
			when ST_COUNTING =>
				FSM_Enable <= '1';
				
				if (Start = '1') then
					NextState <= ST_PAUSE;
				end if;
			
			when ST_PAUSE =>
				if (Start = '1') then
					NextState <= ST_COUNTING;
				end if;
			
			when others =>
				NextState <= ST_RESET;
				
		end case;
	end process;

	TimeBase: entity work.Counter
		generic map (
			MODULO     => (TIMEBASE_MS * ite(IS_SIMULATION, 100, 1000000)) / CLOCK_PERIOD_NS,
			BITS       => 0
		)
		port map (
			Clock      => Clock,
			Reset      => FSM_Reset,
			Enable     => FSM_Enable,
			
			Value      => open,
			WrapAround => Tick
		);
	
	Overflows(0) <= Tick;
	
	genDigits: for i in CONFIG'range generate
		cnt: entity work.Counter
			generic map (
				MODULO     => CONFIG(i).Modulo,
				BITS       => Digits(i)'length
			)
			port map (
				Clock      => Clock,
				Reset      => FSM_Reset,
				Enable     => Overflows(i),
				
				Value      => Digits(i),
				WrapAround => Overflows(i + 1)
			);
		
		Dots(i) <= CONFIG(i).Dot;
	end generate;
	
end architecture;
