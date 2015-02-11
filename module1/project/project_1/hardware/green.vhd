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
--				screen_width		= CONSTANT value of 320
--				screen_height		= CONSTANT value of 240
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
		find_color : integer := 0;
		block_size : integer := 5
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
end sad;

architecture bhv of sad is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	
	TYPE StatesTYPE			is (Initialize,Standby,Computing);
	
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
	SIGNAL ready			: std_logic := '0';
	
	SIGNAL posX				: integer range 0 to SCREEN_WIDTH;
	SIGNAL posY				: integer range 0 to SCREEN_HEIGHT;
	SIGNAL acc				: integer range 0 to 64;
	
	BEGIN
	
	--change state
	--current_state <= next_state;
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
	
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		VARIABLE nextBlockX			:	integer range 0  to block_size := 0;
		VARIABLE nextBlockY			:	integer range 0  to block_size := 0;
		
		VARIABLE candidateX 		:	integer range 0 to SCREEN_WIDTH;
		VARIABLE candidateY 		:	integer range 0 to SCREEN_WIDTH;
		VARIABLE candidateDifference			:	integer range -64 to 64;
		
		VARIABLE tempRed			:	integer range 0 to 64;
		VARIABLE tempGreen			:	integer range 0 to 64;
		VARIABLE tempBlue			:	integer range 0 to 64;
		VARIABLE tempDifference		: 	integer range -64 to 64;
		VARIABLE tempDifferenceTotal : 	integer range -64*block_size to 64*block_size;
		
	BEGIN
		--following variables are not required to be saved across clock cycles
		tempRed := 0;
		tempGreen := 0;
		tempBlue := 0;
	
		if (reset_n = '0') then			
			current_state <= Initialize;
			ready <= '0';
			nextX := 0;
			nextY := 0;
			candidateX := 0;
			candidateY := 0;
		elsif rising_edge(clk) then
			master_wr_en <= '0';
			master_rd_en <= '0';
			
			case (current_state) is
				when Initialize =>
					nextX := 0;
					nextY := 0;
					nextBlockX := 0;
					nextBlockY := 0;
					candidateX := 0;
					candidateY := 0;
					candidateDifference := -64;
					
					current_state <= Standby;
					
				when Standby => 
					if (slave_wr_en = '1') then
						if (slave_addr="0000") then
							if (slave_writedata(0) = '1') then
								-- PROCESS HAS BEEN TRIGGERED, START COMPUTATION
								current_state <= Computing;
								ready <= '0';
								load_waiting := '0';
							end if;
						end if;
					end if;

				when Computing =>
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting := '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
								-- resize red and blue to match green for comparison
								tempRed := to_integer(unsigned(master_readdata(15 downto 11))&'0');
								tempGreen := to_integer(unsigned(master_readdata(10 downto 5)));
								tempBlue := to_integer(unsigned(master_readdata(4 downto 0))&'0');
								
								--We are looking for pixel that has greatest positive difference between find_color and larger of other two
								
								--if looking for red
								if (find_color = 0) then
									if (tempGreen > tempBlue) then
										tempDifference := tempRed - tempGreen;
									else
										tempDifference := tempRed - tempBlue;
									end if;
									
								--if looking for green
								elsif (find_color = 1) then
									if (tempRed > tempBlue) then
										tempDifference := tempGreen - tempRed;
									else
										tempDifference := tempGreen - tempBlue;
									end if;
									
								--if looking for blue
								elsif (find_color = 2) then 
									if (tempRed > tempGreen) then
										tempDifference := tempBlue - tempRed;
									else
										tempDifference := tempBlue - tempGreen;
									end if;
								end if;
							
								tempDifferenceTotal := tempDifferenceTotal + tempDifference;
							--
							
							nextBlockX := nextBlockX + 1;
							if (nextBlockX = block_size) then
								nextBlockX := 0;
								nextBlockY := nextBlockY + 1;
								if (nextBlockY = block_size) then
									nextBlockY := 0;
									--done computing for the block;
									
									if (candidateDifference < tempDifferenceTotal) then
										candidateX := nextX;
										candidateY := nextY;
										candidateDifference := tempDifferenceTotal;
									end if;
									
									tempDifferenceTotal := 0;
								
								
									nextX := nextX+1;
									if(nextX = (SCREEN_WIDTH-block_size)) then
										nextX := 0;
										nextY := nextY +1;
										
										if (nextY = (SCREEN_HEIGHT-block_size)) then
											-- DONE COMPUDATION
											ready <= '1';
											posX <= candidateX+(block_size/2);
											posY <= candidateY+(block_size/2);
											acc <= candidateDifference;
											
											current_state <= Initialize;
											load_waiting := '1';
										end if;
									end if;
								end if;
							end if;
						else
							master_wr_en <= '0';
							master_rd_en <= '1';
						end if;
					else
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(nextY + nextBlockY, 8) & unsigned(to_unsigned(nextX + nextBlockX, 9)) & '0'));	
						master_be <= "11";  -- byte enable
						master_wr_en <= '0';
						master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
		
				when others=>
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;	
	
   process (slave_rd_en, slave_addr,posX,posY,acc)
   BEGIN	       
		slave_readdata <= (others => '-');
		if (slave_rd_en = '1') then
			case slave_addr is
				--outputs
				when "0000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_0000";
				--X unsigned, 0 to SCREEN_WIDTH
				when "0001" => slave_readdata <= std_logic_vector(to_unsigned(posX,32));
				--Y unsigned, 0 to SCREEN_HEIGHT
				when "0010" => slave_readdata <= std_logic_vector(to_unsigned(posY,32));
				--Accuracy (0 to 64), higher is more accurate
				when "0011" => slave_readdata <= std_logic_vector(to_unsigned(acc,32));
				--Ready (active high)
				when "0100" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & ready;
				
				--debug stuff
				--20
				when "0101" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--24
				when "0110" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--28
				when "0111" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--32
				when "1000" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--36
				when "1001" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--40
				when "1010" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--44
				when "1011" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--48
				when "1100" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--52
				when "1101" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				--56
				when "1110" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				--What?
				when others => slave_readdata <= std_logic_vector(to_unsigned(0,32));
			end case;
		end if;
    end process;			
			
	slave_waitrequest <= '0';
end bhv;
