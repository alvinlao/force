-- SAD for a block

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
	
library work;
use work.my_types.all;


entity sad_block is
	generic (
		sizeX : integer := 3;
		sizeY : integer := 3;
		winSizeX : integer := 8;
		winSizeY : integer := 8
	);
	
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		
		ready	: out std_logic;
		start	: in std_logic;
		done	: out std_logic;

		-- Absolute x, y offsets
		x0			: in integer;
		y0			: in integer;
		
		-- Blocks
		window : in BlockType(winSizeX-1 downto 0, winSizeY-1 downto 0);
		ref : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		
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
	
	type state is (IDLE, ADD_SAD, FINISH);
	signal current_state : state := IDLE;
	
	signal sads : SADBlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	
begin
	-- One SAD_pixel for each pixel
	GX: for i in 0 to sizeX-1 generate
		GY: for j in 0 to sizeY-1 generate
			SP: sad_pixel port map (
				ref_rgb => window(x0 + i, y0 + j),
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
			ready <= '0';
			done <= '0';
				
			case current_state is
				when IDLE =>
					ready <= '1';
					sad_var := b"0000_0000_0000_0000_0000_0000_0000_0000";
					
					if(start = '1') then
						current_state <= ADD_SAD;
					end if;
				when ADD_SAD =>
					-- sads contain the sad for the pixel at that location
					for i in 0 to sizeX-1 loop
						for j in 0 to sizeY-1 loop
							sad_var := sad_var + sads(i, j);
						end loop;
					end loop;
					
					current_state <= FINISH;
				when FINISH =>
					done <= '1';
					
					if (start = '0') then 
						current_state <= IDLE;
					end if;
			end case;
			
			sad <= sad_var;
		end if;
	end process;
	
end architecture Behavioural;