-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18
-- Date		:	Feb 5 2015
--
-- File		:	Sum of Absolute Differences Hardware Accelorator
-- 				to be used with Quartus II Qsys System and Avalon Memory Mapping interface
--
-- Usage	:	pixel_buffer_base 	= pixel buffer base as defined in Pixel Buffer core
--				win_size			= search window size in pixels
--				block_size_x		= reference block size in pixels
--				steps				= how many pixels to be searched for
--				screen_width		= constant value of 320
--				screen_height		= constant value of 240
--
-- Timing	:	(2w)+(1)+(2(w-b)/s) clocks
--				w = win_size_x * win_size_y
--				b = block_size_x * block_size_y-1
--				s = steps
--
-- Memory	:	a lot

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sad is
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
		
		slave_addr: in std_logic_vector(2 downto 0);
		slave_rd_en: in std_logic;
		slave_wr_en: in std_logic;
		slave_readdata: out std_logic_vector(31 downto 0);
		slave_writedata: in std_logic_vector(31 downto 0);
		slave_waitrequest : out std_logic
	);
end sad;

architecture bhv of sad is
	constant SCREEN_WIDTH 	: integer := 320;
	constant SCREEN_HEIGHT 	: integer := 240;
	constant SAD_SIZE 		: integer := 65536;
	
	type StatesType				is (Standby,Loading,CalculatingSAD, AddingSAD,Picking);
	type WindowType 			is array (0 to win_size_x, 0 to win_size_y) of std_logic_vector(15 downto 0);
	type BlockType 				is array (0 to block_size_x, 0 to block_size_y) of std_logic_vector(15 downto 0);
	type SadBlockType 			is array (0 to block_size_x-1, 0 to block_size_y-1) of integer range 0 to SAD_SIZE;
	type SadWindowType 			is array (0 to ((win_size_x - block_size_x)/step_x), 0 to (win_size_y - block_size_y)/step_y) of SadBlockType;
	type SADForEachBlocksType	is array (0 to ((win_size_x - block_size_x)/step_x), 0 to (win_size_y - block_size_y)/step_y) of integer range 0 to SAD_SIZE;
	
	signal ready 			: std_logic := '0';
	signal processing 		: std_logic;
	signal posX				: std_logic_vector(8 downto 0);
	signal posY				: std_logic_vector(7 downto 0);
	signal acc				: std_logic_vector(15 downto 0);
	
	signal current_state 	: StatesType := Standby;
	signal next_state 		: StatesType := Standby;
	
	signal Window 			: WindowType;
	
	signal windowStartX 	: integer range 0 to (SCREEN_WIDTH - win_size_x);
	signal windowStartY 	: integer range 0 to (SCREEN_HEIGHT - win_size_y);
	signal ReferenceBlock 	: BlockType;
	
	signal SADForEachBlock 	: SADForEachBlocksType;	
	signal SADCollection 	: SadWindowType;
		
	begin
	  
	process (clk, reset_n)

	variable nextX : integer range 0 to SCREEN_WIDTH;
		variable nextY : integer range 0 to SCREEN_HEIGHT;
		variable candidateRow : integer range 0 to ((win_size_x - block_size_x)/step_x);
		variable candidateCol : integer range 0 to ((win_size_y - block_size_y)/step_y);
		variable candidateSAD : integer range 0 to SAD_SIZE := SAD_SIZE;
		variable load_waiting : std_logic;

	begin
		if (reset_n = '0') then
			current_state <= Standby;
			next_state <= Standby;
			ready <= '0';
		elsif rising_edge(clk) then
			next_state <= current_state;
			master_wr_en <= '0';
			master_rd_en <= '0';
			processing <=  '1';
			
			case (current_state) is
				when Standby => 
						processing <= '0';
						if (slave_wr_en = '1') then
							if (slave_addr="000") then
								if (slave_writedata(0) = '1') then
									next_state <= Loading;
									nextX := 0;
									nextY := 0;
									load_waiting := '0';
									ready <= '0';
								end if;
							end if;
						end if;

				when Loading =>
					ready <= '0';
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting := '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							Window(nextX,nextY) <= master_readdata;
							
							nextX := nextX+1;
							if(nextX = block_size_x) then
								nextX := 0;
								nextY := nextY +1;
								
								if (nextY = block_size_y) then
									next_state <= CalculatingSAD;
									load_waiting := '1';
								end if;
							end if;
						else
							master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(windowStartX + nextX, 9)) & unsigned(to_unsigned(windowStartY + nextY, 8)) & '0');	
							master_be <= "11";  -- byte enable
							master_wr_en <= '0';
							master_rd_en <= '1';
						end if;
					else
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(windowStartX + nextX, 9)) & unsigned(to_unsigned(windowStartY + nextY, 8)) & '0');	
						master_be <= "11";  -- byte enable
						master_wr_en <= '0';
						master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
		
				when CalculatingSAD =>
					ready <= '0';
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
							for BLK_ROW in 0 to (block_size_x-1) loop
								for BLK_COL in 0 to (block_size_y-1) loop
									SADCollection(WIN_ROW,WIN_COL)(BLK_ROW,BLK_COL) <= to_integer(
										(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(15 downto 11)) - signed('0'&ReferenceBlock(BLK_ROW,BLK_COL)(15 downto 11)))) and B"01_1111") + 
										(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(10 downto 5)) - signed('0'&ReferenceBlock(BLK_ROW,BLK_COL)(10 downto 5)))) and B"011_1111" ) + 
										(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(4 downto 0)) - signed('0'&ReferenceBlock(BLK_ROW,BLK_COL)(4 downto 0)))) and B"01_1111")
										);
								end loop;																
							end loop;													
						end loop;						
					end loop;
					
					nextX := 0;
					nextY := 0;
					next_state <= AddingSAD;
					
				when AddingSAD =>
					ready <= '0';
				
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
						
							SADForEachBlock(WIN_ROW,WIN_COL) <= SADForEachBlock(WIN_ROW,WIN_COL) + SADCollection(WIN_ROW,WIN_COL)(nextX,nextY);
							
						end loop;						
					end loop;
					
					nextX := nextX+1;
					if(nextX = block_size_x) then
						nextX := 0;
						nextY := nextY +1;
						
						if (nextY = block_size_y) then
							candidateSAD := SAD_SIZE;
							next_state <= Picking;
						end if;
					end if;
					
				when Picking =>
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
						
							if (SADForEachBlock(WIN_ROW,WIN_COL) < candidateSAD) then
								candidateSAD := SADForEachBlock(WIN_ROW,WIN_COL);
								candidateRow := WIN_ROW;
								candidateCol := WIN_COL;
							end if;
							
						end loop;						
					end loop;
					
					posX <= std_logic_vector(to_unsigned(windowStartX + (candidateRow*step_x) + (block_size_x/2),9));
					posY <= std_logic_vector(to_unsigned(windowStartY + (candidateCol*step_y) + (block_size_y/2),8));					
					acc <= std_logic_vector(to_unsigned(candidateSAD,16));
					ready <= '1';
					
					windowStartX <= windowStartX + (candidateRow*step_x);
					windowStartY <= windowStartY + (candidateCol*step_y);
					
					for BLK_ROW in 0 to block_size_x-1 loop
						for BLK_COL in 0 to block_size_y-1 loop
							ReferenceBlock(BLK_ROW,BLK_COL) <= Window((candidateRow*step_x)+BLK_ROW,(candidateCol*step_y)+BLK_COL);
						end loop;
					end loop;					
					
					
					next_state <= Standby;
					
				when others=>
					-- why are we here?
					next_state <= Standby;
			end case;
			
		end if;	
	end process;	
	

   process (slave_rd_en, slave_addr)
   begin	       
		slave_readdata <= (others => '-');
		if (slave_rd_en = '1') then
			case slave_addr is
				when "000" => slave_readdata <= "000";
				when "001" => slave_readdata <= posX;
				when "010" => slave_readdata <= posY;
				when "011" => slave_readdata <= acc;
				when "111" => slave_readdata <= "000"&ready;
				when others => null;
			end case;
		end if;
    end process;
				
end bhv;
