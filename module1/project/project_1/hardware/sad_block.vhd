-- SAD for a block

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
	
library work;
use work.my_types.all;


entity sad_block is
	generic (
		sizeX : integer := 3;
		sizeY : integer := 3
	);
	
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		
		ready	: out std_logic;
		ready_block : out std_logic;
		done	: out std_logic;
		start	: in std_logic;
		start_block : in std_logic;
		block_read_en : in std_logic;

		ref_block : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		can_block : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		
		sad : out unsigned(31 downto 0)
	);
end entity sad_block;

architecture Behavioural of sad_block is	
	component sad_pixel
	port (
		ref_rgb	: in std_logic_vector(15 downto 0);
		can_rgb	: in std_logic_vector(15 downto 0);
		sad		: out unsigned(7 downto 0)
	);
	end component;
	
	type state is (IDLE, LOADREF, IDLEBLOCK, LOADBLOCK, SADPIXEL, SUMSAD, FINISH);
	signal current_state : state := IDLE;

	signal can : BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	signal ref : BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	signal sads : SADBlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	
begin
	-- One SAD_pixel for each pixel
	GX: for i in 0 to sizeX-1 generate
		GY: for j in 0 to sizeY-1 generate
			SP: sad_pixel port map(
				ref_rgb => can(i, j),
				can_rgb => ref(i, j),
				sad 	=> sads(i, j)
			);
		end generate GY;
	end generate GX;
	

	process(clock, reset)
		-- Final sad
		variable sad_var : unsigned(31 downto 0);	
	begin

		if(reset = '1') then
			current_state <= IDLE;
		elsif(rising_edge(clock)) then
			done <= '0';
			ready <= '0';
			ready_block <= '0';
			
			case current_state is
				when IDLE =>
					ready <= '1';
					sad_var := b"0000_0000_0000_0000_0000_0000_0000_0000";
					sad <= sad_var;
					
					if(start = '1') then
						current_state <= LOADREF;
					end if;
				when LOADREF =>
					if(block_read_en = '1') then
						ref <= ref_block;
						current_state <= IDLEBLOCK;
					end if;
				when IDLEBLOCK =>
					ready_block <= '1';
					sad_var := b"0000_0000_0000_0000_0000_0000_0000_0000";
					sad <= sad_var;
					
					if(start_block = '1') then
						current_state <= LOADBLOCK;
					end if;
				when LOADBLOCK =>
					if(block_read_en = '1') then
						can <= can_block;
						current_state <= SADPIXEL;
					end if;
				when SADPIXEL =>
					-- Done instantly
					current_state <= SUMSAD;
				when SUMSAD =>
					for i in 0 to sizeX-1 loop
						for j in 0 to sizeY-1 loop
							sad_var := sad_var + sads(i, j);
						end loop;
					end loop;
					
					sad <= sad_var;
					current_state <= FINISH;
				when FINISH =>
					done <= '1';
					
					if(start_block = '0') then
						current_state <= IDLEBLOCK;
					elsif (start = '0') then 
						current_state <= IDLE;
					end if;
			end case;
		end if;
	end process;
	
end architecture Behavioural;