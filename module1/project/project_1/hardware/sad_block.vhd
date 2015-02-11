-- SAD for a block

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sad_block is
	generic (
		sizeX : integer := 3;
		sizeY : integer := 3
	);
	
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		en		: in std_logic;
		x, y	: in std_logic;
		
		master_rd_en	: out std_logic;
		master_readdata	: in std_logic_vector(15 downto 0);
		
		ready	: out std_logic;
		done	: out std_logic;
		sad_val	: out std_logic_vector;
	);
end entity sad_block;

architecture Behavioural of sad_block is
	component sync_ram 
	port (
		clock	: in std_logic;
		we		: in std_logic;
		address	: in std_logic_vector;
		datain	: in std_logic_vector;
		dataout	: out std_logic_vector
	);
	
	type state is (READY, LOAD, SUM, DONE);
	
	signal we	: std_logic;
	signal address, datain, dataout	: std_logic;
	
	-- State machine
	signal current_state : state <= state;

	-- SAD control
	signal sum : unsigned
	signal x, y	: integer;
	
begin
	R: sync_ram port map (clock, we, address, datain, dataout);
	
	process(clock, reset)
	begin
		if(reset = '0') then
			current_state <= READY;
		elsif(rising_edge(clock)) then
			case current_state is
				when READY => 
					if(en = '1') then
						current_state <= LOAD;
					end if;
				when LOAD => 
					
				when SUM =>
					if(x = sizeX) and (y = sizeY) then
						current_state <= DONE;
					end if;
				when DONE =>
					if(en = '0') then
						current_state <= READY;
					end if;
				when others => null;
			end case;
		end if;
	end process;
	
	process(current_state)
	begin
		case current_state is
			ready <= '0';
			done <= '0';
			
			when READY =>
				ready <= '1';
			when LOAD =>
			when SUM =>
			when DONE =>
				done <= '1';
			when others => null;
		end case;
	end process;
	
	
end architecture Behavioural;