-- SAD Track

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

library work;
use work.my_types.all;

entity sad_track is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		win_size_x: integer := 20;
		win_size_y: integer := 20;
		block_size_x: integer := 7;
		block_size_y: integer := 7;
		step_x: integer := 1;
		step_y: integer := 1		
	);	
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;
		
		-- start 	: in std_logic;
		-- ready 	: out std_logic;
		
		-- posX 	: out std_logic_vector(8 downto 0);
		-- posY 	: out std_logic_vector(7 downto 0);
		-- acc		: out std_logic_vector(15 downto 0);
				
		master_addr : out std_logic_vector(31 downto 0);
		master_rd_en : out std_logic;
		master_wr_en : out std_logic;
		master_be : out std_logic_vector(1 downto 0);
		master_readdata : in std_logic_vector(15 downto 0);
		master_writedata: out  std_logic_vector(15 downto 0);
		master_waitrequest : in std_logic;
		
		slave_addr: in std_logic_vector(3 downto 0);
		slave_rd_en: in std_logic;
		slave_wr_en: in std_logic;
		slave_readdata: out std_logic_vector(31 downto 0);
		slave_writedata: in std_logic_vector(31 downto 0);
		slave_waitrequest : out std_logic
	);
end sad_track;

architecture Behavioural of sad_track is
	constant SCREEN_WIDTH 	: integer := 320;
	constant SCREEN_HEIGHT 	: integer := 240;
	constant SAD_SIZE 		: integer := 65536;
	
	component sad_block
	generic (
		sizeX : integer;
		sizeY : integer
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
	end component;
	
	-- States
	type state is (INIT, STANDBY, LOAD, FINISH);
	signal current_state : state := INIT;
	signal current_state_std : std_logic_vector(31 downto 0);
	
	-- Offset (Top Left)
	signal winX, winY : integer;
	
	
	signal x, y : integer;
	
	-- Block
	-- signal blk_ready, blk_ready_block, blk_done, blk_start, blk_start_block, blk_block_read_en : std_logic;
	
	-- signal ref_block, can_block : in BlockType(block_size_x-1 downto 0, block_size_y-1 downto 0);
	-- signal window : in BlockType(win_size_x-1 downto 0, win_size_y-1 downto 0);
begin
	-- SB : sad_block 
		-- generic map (
			-- sizeX => block_size_x,
			-- sizeY => block_size_y
		-- )
		-- port map (
			-- reset => not reset_n,
			-- clock => clk,
			
			-- ready => ready,
			-- ready_block => ready_block,
			-- done => done,
			-- start => SW(0),
			-- start_block => SW(1),
			
			-- ref_block => ref_block,
			-- can_block => can_block,
			-- block_read_en => SW(17),
			
			-- sad => output
		-- );
	
	process(clk)
	begin
		if(reset_n = '0') then
			current_state <= INIT;
		elsif(rising_edge(clk)) then
			slave_waitrequest <= '0';
			
			case current_state is
				when INIT =>
					current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0000";
					winX <= (SCREEN_WIDTH / 2) - (win_size_x / 2);
					winY <= (SCREEN_HEIGHT / 2) - (win_size_y / 2);
					current_state <= STANDBY;
				when STANDBY =>
					current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0001";
					-- Start by writing '1' to address 0x0000
					if(slave_wr_en = '1') then
						slave_waitrequest <= '1';
						if (slave_addr = "0000") then
							if(slave_writedata(0) = '1') then
								current_state <= LOAD;
							end if;
						end if;
					end if;
				when LOAD =>
					current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0010";
				when FINISH =>
					current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0011";
				when others => null;
			end case;
			

		end if;
	end process;
	
	process (slave_rd_en, slave_addr)
	begin	       
		slave_readdata <= (others => '-');
		if (slave_rd_en = '1') then
			case slave_addr is
				when "0001" => slave_readdata <= current_state_std;
				when others => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
				
				-- when "0000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
				-- when "0001" => slave_readdata <= std_logic_vector(to_unsigned(posX,32));
				-- when "0010" => slave_readdata <= std_logic_vector(to_unsigned(posY,32));
				-- when "0011" => slave_readdata <= std_logic_vector(to_unsigned(acc,32));
				-- when "0100" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & ready;
				-- --debug stuff
				-- --20
				-- when "0101" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY-1); --std_logic_vector(to_unsigned(Window(posX-1, posY-1),32));
				-- --24
				-- when "0110" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY-1); --std_logic_vector(to_unsigned(debug_row,32));
				-- --28
				-- when "0111" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY-1); --std_logic_vector(to_unsigned(debug_col,32));
				-- --32
				-- when "1000" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY); --std_logic_vector(to_unsigned(debug_sads(0,2),32));
				-- --36
				-- when "1001" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY); --std_logic_vector(to_unsigned(debug_sads(1,0),32));
				-- --40
				-- when "1010" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY); --std_logic_vector(to_unsigned(debug_sads(1,1),32));
				-- --44
				-- when "1011" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY+1); --std_logic_vector(to_unsigned(debug_sads(1,2),32));
				-- --48
				-- when "1100" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY+1); --std_logic_vector(to_unsigned(debug_sads(2,0),32));
				-- --52
				-- when "1101" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY+1); --std_logic_vector(to_unsigned(debug_sads(2,1),32));
				-- --56
				-- when "1110" => slave_readdata <= std_logic_vector(to_unsigned(debug_sads(2,2),32));
				-- when others => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0001_0000"; --address x - 16
			end case;
		end if;
    end process;	
end Behavioural;