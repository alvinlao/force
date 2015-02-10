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
		
		slave_addr: in std_logic_vector(3 downto 0);
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
	
	type StatesType				is (Initialize,Standby,Loading,CalculatingSAD, AddingSAD,Picking, DrawingBox);
	type WindowType 				is array (0 to win_size_x, 0 to win_size_y) of std_logic_vector(15 downto 0);
	type BlockType 				is array (0 to block_size_x, 0 to block_size_y) of std_logic_vector(15 downto 0);
	type SadBlockType 			is array (0 to block_size_x-1, 0 to block_size_y-1) of integer range 0 to SAD_SIZE;
	type SadWindowType 			is array (0 to ((win_size_x - block_size_x)/step_x), 0 to (win_size_y - block_size_y)/step_y) of SadBlockType;
	type SADForEachBlocksType	is array (0 to ((win_size_x - block_size_x)/step_x), 0 to (win_size_y - block_size_y)/step_y) of integer range 0 to SAD_SIZE;
	
	signal ready 			: std_logic := '0';
	signal processing 	: std_logic;
	signal posX				: integer range 0 to SCREEN_WIDTH;
	signal posY				: integer range 0 to SCREEN_HEIGHT;
	signal acc				: integer range 0 to SAD_SIZE;
	
	signal current_state 	: StatesType := Initialize;
	--signal next_state 		: StatesType := Standby;
	
	signal Window 			: WindowType;
	
	signal windowStartX 	: integer range 0 to (SCREEN_WIDTH - win_size_x) := (SCREEN_WIDTH/2)-(win_size_x/2);
	signal windowStartY 	: integer range 0 to (SCREEN_HEIGHT - win_size_y) := (SCREEN_HEIGHT/2)-(win_size_y/2);
	signal ReferenceBlock 	: BlockType;
	
	signal SADForEachBlock 	: SADForEachBlocksType;	
	signal SADCollection 	: SadWindowType;
	
	
	--debug stuff
	
	--signal debug_state_in_vector : std_logic_vector(3 downto 0);
	type debug_SADs_Type	is array (0 to 2, 0 to 2) of integer range 0 to SAD_SIZE;
	signal debug_what : integer range 0 to SCREEN_WIDTH;
	signal debug_row : integer range 0 to ((win_size_x - block_size_x)/step_x);
	signal debug_col : integer range 0 to ((win_size_y - block_size_y)/step_y);
	signal debug_sads : debug_SADs_Type;
		
	begin
	
	--change state
	--current_state <= next_state;
	  
	process (clk, reset_n)

		variable nextX : integer range 0 to SCREEN_WIDTH;
		variable nextY : integer range 0 to SCREEN_HEIGHT;
		variable candidateRow : integer range 0 to ((win_size_x - block_size_x)/step_x);
		variable candidateCol : integer range 0 to ((win_size_y - block_size_y)/step_y);
		variable candidateSAD : integer range 0 to SAD_SIZE := SAD_SIZE;
		variable load_waiting : std_logic;
		variable var_posX : integer range 0 to SCREEN_WIDTH;
		variable var_posY : integer range 0 to SCREEN_HEIGHT;
		
		variable next_win_x_tmp : integer range -(SCREEN_WIDTH/2) to SCREEN_WIDTH := (SCREEN_WIDTH/2)-(win_size_x/2);
		variable next_win_y_tmp : integer range -(SCREEN_HEIGHT/2) to SCREEN_HEIGHT := (SCREEN_HEIGHT/2)-(win_size_y/2);
		
		--variable debug_count : integer range 0 to 100;
		
	begin
		if (reset_n = '0') then			

			next_win_x_tmp := (SCREEN_WIDTH/2)-(win_size_x/2);
			next_win_y_tmp := (SCREEN_HEIGHT/2)-(win_size_y/2);
			windowStartX <= next_win_x_tmp;
			windowStartY <= next_win_y_tmp;

			current_state <= Initialize;
			ready <= '0';
		elsif rising_edge(clk) then
--			next_state <= current_state;		
			master_wr_en <= '0';
			master_rd_en <= '0';
			processing <=  '1';
			slave_waitrequest <= '0';
			
			case (current_state) is
				when Initialize =>
					--debug_state_in_vector <= "1001";
					--TODO: Initialize
					-- next_win_x_tmp := (SCREEN_WIDTH/2)-(win_size_x/2);
					-- next_win_y_tmp := (SCREEN_HEIGHT/2)-(win_size_y/2);
					-- windowStartX <= next_win_x_tmp;
					-- windowStartY <= next_win_y_tmp;
					-- nextX := 0;
					-- nextY := 0;
					-- var_posX := 0;
					-- var_posY := 0;
					-- candidateSAD := SAD_SIZE;
					-- candidateRow := 0;
					-- candidateCol := 0;
					-- acc <= SAD_SIZE;
					-- load_waiting := '0';
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
						
							SADForEachBlock(WIN_ROW,WIN_COL) <= 0;
							
						end loop;						
					end loop;

					
					slave_waitrequest <= '1';
					current_state <= Standby;
			
				when Standby => 
					--debug_state_in_vector <= "1111";
					processing <= '0';
					if (slave_wr_en = '1') then
						slave_waitrequest <= '1';
						if (slave_addr="0000") then
							if (slave_writedata(0) = '1') then
								current_state <= Loading;
								nextX := 0;
								nextY := 0;
								load_waiting := '0';
								ready <= '0';
							else
								--??????
							end if;
						else
							--??????
						end if;
					end if;

				when Loading =>
					--debug_state_in_vector <= "0001";
					ready <= '0';
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting := '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							
							--Window(nextX,nextY) <= master_readdata;
							
							Window(nextX,nextY) <= b"11111_000000_00000";
							if(nextX = 160) then
							if(nextY = 120) then
							
								Window(nextX,nextY) <= b"00000_111111_00000";
							end if;
							end if;
							--debug_what <= master_readdata;
							
							nextX := nextX+1;
							if(nextX = win_size_x) then
								nextX := 0;
								nextY := nextY +1;
								
								if (nextY = win_size_y) then
									--debug_what <= Window(block_size_x/2,block_size_y/2);
									current_state <= CalculatingSAD;
									load_waiting := '1';
								end if;
							end if;
						else
							master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(windowStartY + nextY, 8) & unsigned(to_unsigned(windowStartX + nextX, 9)) & '0'));	
							master_be <= "11";  -- byte enable
							master_wr_en <= '0';
							master_rd_en <= '1';
						end if;
					else
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(windowStartY + nextY, 8) & unsigned(to_unsigned(windowStartX + nextX, 9)) & '0'));	
						master_be <= "11";  -- byte enable
						master_wr_en <= '0';
						master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
		
				when CalculatingSAD =>
					--debug_state_in_vector <= "0010";
					ready <= '0';
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
							for BLK_ROW in 0 to (block_size_x-1) loop
								for BLK_COL in 0 to (block_size_y-1) loop
--									debug_sads(WIN_ROW,WIN_COL)<=to_integer(unsigned(Window(WIN_ROW,WIN_COL)));
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
					
					--debug_count := 0;
					current_state <= AddingSAD;
					
				when AddingSAD =>
					--debug_state_in_vector <= "0011";
					ready <= '0';
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
						
							SADForEachBlock(WIN_ROW,WIN_COL) <= SADForEachBlock(WIN_ROW,WIN_COL) + SADCollection(WIN_ROW,WIN_COL)(nextX,nextY);
						end loop;						
					end loop;
					
					--debug_count	:= debug_count + 1;
					nextX := nextX+1;
					if(nextX = block_size_x) then
						nextX := 0;
						nextY := nextY +1;
						
						if (nextY = block_size_y) then
							candidateSAD := SAD_SIZE;
							candidateRow := 0;
							candidateCol := 0;
							current_state <= Picking;
						end if;
					end if;
					
				when Picking =>
					--debug_state_in_vector <= "0100";
					
					for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) loop
						for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) loop
							if (SADForEachBlock(WIN_ROW,WIN_COL) < candidateSAD) then
								candidateSAD := SADForEachBlock(WIN_ROW,WIN_COL);
								candidateRow := WIN_ROW;
								candidateCol := WIN_COL;
							end if;
							
						end loop;						
					end loop;
					
					var_posX := windowStartX + (candidateRow*step_x) + (block_size_x/2);
					var_posY := windowStartY + (candidateCol*step_y) + (block_size_y/2);
					
					acc <= candidateSAD;
					ready <= '1';
					
					next_win_x_tmp := var_posX - win_size_x/2;
					next_win_y_tmp := var_posY - win_size_y/2;
					
					debug_col <= candidateCol;
					debug_row <= candidateRow;
					-- debug_what <= debug_count;
					--debug_sads <= SADForEachBlock;
					
					--check bound x
						if (next_win_x_tmp < 0) then
							windowStartX <= 0;
						elsif (next_win_x_tmp > SCREEN_WIDTH - win_size_x) then
							windowStartX <= SCREEN_WIDTH - win_size_x;
						else
							windowStartX <= next_win_x_tmp;
							--debug_what <= 33;
						end if;
					
					--check bound y
						if (next_win_y_tmp < 0) then
							windowStartY <= 0;
						elsif (next_win_y_tmp > SCREEN_HEIGHT - win_size_y) then
							windowStartY <= SCREEN_HEIGHT - win_size_y;
						else
							windowStartY <= next_win_y_tmp;
						end if;
											
					posX <= var_posX;
					posY <= var_posY;
					
					-- Copy reference block
					for BLK_ROW in 0 to block_size_x-1 loop
						for BLK_COL in 0 to block_size_y-1 loop
							ReferenceBlock(BLK_ROW,BLK_COL) <= Window((candidateRow*step_x)+BLK_ROW,(candidateCol*step_y)+BLK_COL);
							debug_sads(BLK_ROW,BLK_COL) <= to_integer(unsigned(Window((candidateRow*step_x)+BLK_ROW,(candidateCol*step_y)+BLK_COL)));
						end loop;
					end loop;					
					
					load_waiting := '0';
					current_state <= Initialize;
			
				when others=>
					--debug_state_in_vector <= "0101";
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;	
	
   process (slave_rd_en, slave_addr,posX,posY,acc,debug_sads)
   begin	       
		slave_readdata <= (others => '-');
		if (slave_rd_en = '1') then
			case slave_addr is
				when "0000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
				when "0001" => slave_readdata <= std_logic_vector(to_unsigned(posX,32));
				when "0010" => slave_readdata <= std_logic_vector(to_unsigned(posY,32));
				when "0011" => slave_readdata <= std_logic_vector(to_unsigned(acc,32));
				when "0100" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & ready;
				--debug stuff
				--20
				when "0101" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY-1); --std_logic_vector(to_unsigned(Window(posX-1, posY-1),32));
				--24
				when "0110" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY-1); --std_logic_vector(to_unsigned(debug_row,32));
				--28
				when "0111" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY-1); --std_logic_vector(to_unsigned(debug_col,32));
				--32
				when "1000" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY); --std_logic_vector(to_unsigned(debug_sads(0,2),32));
				--36
				when "1001" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY); --std_logic_vector(to_unsigned(debug_sads(1,0),32));
				--40
				when "1010" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY); --std_logic_vector(to_unsigned(debug_sads(1,1),32));
				--44
				when "1011" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX-1, posY+1); --std_logic_vector(to_unsigned(debug_sads(1,2),32));
				--48
				when "1100" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX, posY+1); --std_logic_vector(to_unsigned(debug_sads(2,0),32));
				--52
				when "1101" => slave_readdata <= b"0000_0000_0000_0000" & Window(posX+1, posY+1); --std_logic_vector(to_unsigned(debug_sads(2,1),32));
				--56
				when "1110" => slave_readdata <= std_logic_vector(to_unsigned(debug_sads(2,2),32));
				when others => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0001_0000"; --address x - 16
			end case;
		end if;
    end process;			
			
end bhv;
