-- SAD Track

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

library work;
use work.my_types.all;

entity sad_track is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		winSizeX: integer := 20;
		winSizeY: integer := 20;
		blockSizeX: integer := 7;
		blockSizeY: integer := 7;
		strideX: integer := 1;
		strideY: integer := 1		
	);	
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;
				
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
	constant MAX_INT 				: integer := 65536;
	
	constant NUM_SAD_BLOCKS_X : integer := ((winSizeX - blockSizeX)/strideX);
	constant NUM_SAD_BLOCKS_Y : integer := ((winSizeY - blockSizeY)/strideY);
	
	constant SCREEN_CENTERED_WINDOW_X : integer := (SCREEN_WIDTH / 2) - (winSizeX / 2);
	constant SCREEN_CENTERED_WINDOW_Y : integer := (SCREEN_HEIGHT / 2) - (winSizeY / 2);
	
	-- SAD Block
	component sad_block
	generic (
		sizeX : integer;
		sizeY : integer;
		winSizeX : integer;
		winSizeY : integer
	);
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		ready	: out std_logic;
		start	: in std_logic;
		done	: out std_logic;
		x0			: in integer;
		y0			: in integer;
		window : in BlockType(winSizeX-1 downto 0, winSizeY-1 downto 0);
		ref : in BlockType(blockSizeX-1 downto 0, blockSizeY-1 downto 0);
		sad : out unsigned(31 downto 0)
	);
	end component;
	
	-- States
	type state is (INIT, STANDBY, LOAD, CALCULATE, SAVE_REF, CENTER_WINDOW);
	signal current_state : state := INIT;
	signal current_state_std : std_logic_vector(31 downto 0);
	
	-- Data
	signal window : BlockType(winSizeX-1 downto 0, winSizeY-1 downto 0);
	signal refBlock : BlockType(blockSizeX-1 downto 0, blockSizeY-1 downto 0);
	signal intializedRefBlock : std_logic := '0';
	
	-- Current SAD block calculation location
	signal curX, curY : integer;
	
	-- SAD block controllers
	signal SADBlockReady 	: std_logic;
	signal SADBlockDone 	: std_logic;
	signal SADBlockStart	: std_logic;
	signal SADBlockResult : unsigned(31 downto 0);
	
	-- DEBUG
	signal winX, winY : integer;
	signal counter : unsigned(31 downto 0);
	----------------------------------------
	-- SLAVE read variables
	----------------------------------------
	-- Absolute co-ordinate: The best block this cycle
	signal x, y : integer;
	signal minSADValue : unsigned(31 downto 0);
	-- Ready for next cycle
	signal ready : std_logic;
	
begin
-- Generate a SAD block computer
SB : sad_block 
	generic map (
		sizeX => blockSizeX,
		sizeY => blockSizeY,
		winSizeX => winSizeX,
		winSizeY => winSizeY
	)
	port map (
		clock => clk,
		reset => not reset_n,
		
		ready => SADBlockReady,
		done => SADBlockDone,
		start => SADBlockStart,
		
		x0 => curX,
		y0 => curY,
		
		window => window,
		ref => refBlock,		
		
		sad => SADBlockResult
	);


process(clk, reset_n)	
	variable wait_data : std_logic := '0';
	
	-- Iterator
	variable nextX, nextY : integer;
	-- Window location
	-- Absolute co-ordinate: current window offset
	variable curWinX, curWinY : integer;
	-- Absolute SAD best block location
	variable x_local, y_local : integer;
	
begin
	if(reset_n = '0') then
		master_wr_en<= '0';
		master_rd_en<= '0';
		current_state <= INIT;
	elsif(rising_edge(clk)) then
		slave_waitrequest <= '0';
		ready <= '0';
		
		winX <= curWinX;
		winY <= curWinY;
		
		-- State machine
		case current_state is
			when INIT =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0000";
				
				wait_data := '0';
				
				-- Initialize window and block to the center
				curWinX := SCREEN_CENTERED_WINDOW_X;
				curWinY := SCREEN_CENTERED_WINDOW_Y;
				x_local := curWinX;
				y_local := curWinY;
				
				-- Flag we don't have a reference block
				intializedRefBlock <= '0';
				
				-- Next state
				current_state <= STANDBY;
				
			when STANDBY =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0001";
				ready <= '1';
				
				-- Make it public
				x <= x_local;
				y <= y_local;
				
				-- Ignition!
				if(slave_wr_en = '1') then
					slave_waitrequest <= '1';
					if (slave_addr = "0001") then
						if(slave_writedata(0) = '1') then
							-- Reset
							nextX := 0;
							nextY := 0;
							current_state <= LOAD;
						end if;
					end if;
				end if;
				
			when LOAD =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0010";
				
				-- Read pixels from pixel buffer into window
				if(wait_data = '0') then
					wait_data := '1';
					-- Request next color from pixel buffer
					master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curWinY + nextY, 8) & unsigned(to_unsigned(curWinX + nextX, 9)) & '0'));	
					master_be <= "11";  -- byte enable
					master_wr_en <= '0';
					master_rd_en <= '1';
				else
					if(master_waitrequest = '0') then
						-- Data available
						wait_data := '0';
						master_wr_en <= '0';
						master_rd_en <= '0';
						window(nextX, nextY) <= master_readdata;
						
						-- Need to initialize reference block
						if(intializedRefBlock = '0') then
							if(nextX < blockSizeX) and (nextY < blockSizeY) then
								refBlock(nextX, nextY) <= master_readdata;
							end if;
							
							if(nextX = blockSizeX-1) and (nextY = blockSizeY-1) then
								intializedRefBlock <= '1';
							end if;
						end if;
						
						-- Iterator
						nextX := nextX + 1;
						if(nextX = winSizeX) then
							nextX := 0;
							nextY := nextY + 1;
							
							if(nextY = winSizeY) then
								-- All loaded up
								minSADValue <= to_unsigned(MAX_INT, 32);
								nextX := 0;
								nextY := 0;
								current_state <= CALCULATE;
							end if;
						end if;
					end if;
				end if;
				
			when CALCULATE =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0011";
				
				-- Compute SAD for each block in the window
				if(SADBlockReady = '1') then
					-- Next block co-ordinates relative to window
					curX <= nextX*strideX;
					curY <= nextY*strideY;
					
					SADBlockStart <= '1';
				elsif(SADBlockDone = '1') then
					if(SADBlockResult <= minSADValue) then
						-- Absolute co-ords
						x_local := curWinX + curX;
						y_local := curWinY + curY;
						minSADValue <= SADBlockResult;
					end if;
					
					SADBlockStart <= '0';
					
					-- Iterator
					nextX := nextX + 1;
					if(nextX = NUM_SAD_BLOCKS_X+1) then
						nextX := 0;
						nextY := nextY + 1;
						
						if(nextY = NUM_SAD_BLOCKS_Y+1) then
							nextX := 0;
							nextY := 0;
							
							-- All done
							current_state <= SAVE_REF;
						end if;
					end if;
				end if;

			when SAVE_REF =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0100";
				refBlock(nextX, nextY) <= window(x_local - curWinX + nextX, y_local - curWinY + nextY);
				
				-- Iterator
				nextX := nextX + 1;
				if(nextX = blockSizeX) then
					nextX := 0;
					nextY := nextY + 1;
					
					if(nextY = blockSizeY) then						
						-- All done
						current_state <= CENTER_WINDOW;
					end if;
				end if;
				
			when CENTER_WINDOW =>
				current_state_std <= b"0000_0000_0000_0000_0000_0000_0000_0101";
				-- Center
				curWinX := x_local + (blockSizeX/2) - (winSizeX/2);
				curWinY := y_local + (blockSizeY/2) - (winSizeY/2);
				
				-- Bounds
				if(curWinX < 0) then
					curWinX := 0;
				elsif(curWinX + winSizeX > SCREEN_WIDTH) then
					curWinX := SCREEN_WIDTH - winSizeX;
				end if;
				
				if(curWinY < 0) then
					curWinY := 0;
				elsif(curWinY + winSizeY > SCREEN_HEIGHT) then
					curWinY := SCREEN_HEIGHT - winSizeY;
				end if;
						
				-- Finish
				current_state <= STANDBY;
				
			when others => null;
			
		end case;
	end if;
end process;

process (slave_rd_en, slave_addr)
begin	       
	slave_readdata <= (others => '-');
	if (slave_rd_en = '1') then
		case slave_addr is
			-- 0x0 address is wonky, we don't use it.
			when "0000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
			
			-- INTERFACE
			-- 4: x
			when "0001" => slave_readdata <= b"0000_0000_0000_0000_0000_000" & std_logic_vector(to_unsigned(x, 9));
			-- 8: y
			when "0010" => slave_readdata <= b"0000_0000_0000_0000_0000_0000" & std_logic_vector(to_unsigned(y, 8));
			-- 12: ready
			when "0011" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & ready;

			-- DEBUG
			-- 16: state
			when "0100" => slave_readdata <= current_state_std;
			-- 20: pixel data
			when "0101" => slave_readdata <= b"0000_0000_0000_0000" & window(0, 0);
			-- 24: SAD
			when "0110" => slave_readdata <= std_logic_vector(minSADValue);
			-- 28: winX,winY
			when "0111" => slave_readdata <= std_logic_vector(to_unsigned(winX, 16)) & std_logic_vector(to_unsigned(winY, 16));
			-- 32: intializedRefBlock
			when "1000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & intializedRefBlock;
			-- 36: counter
			when "1001" => slave_readdata <= std_logic_vector(counter);
			-- 40: refblock
			when "1010" => slave_readdata <= b"0000_0000_0000_0000" & refblock(0, 0);
			
			-- 44: window A, B
			when "1011" => slave_readdata <= window(0, 0) & window(1, 0);
			-- 48: window C, D
			when "1100" => slave_readdata <= window(2, 0) & window(0, 1);
			-- 52: window E, F
			when "1101" => slave_readdata <= window(1, 1) & window(2, 1);
			-- 56: window G, H
			when "1110" => slave_readdata <= window(0, 2) & window(1, 2);
			-- 60: window I
			when "1111" => slave_readdata <= b"0000_0000_0000_0000" & window(2, 2);

			
			-- INVALID
			when others => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
		end case;
	end if;
end process;	
end Behavioural;