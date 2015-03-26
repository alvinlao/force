-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity green is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		find_color : integer := 0;
		block_size : integer := 2;
		score_factor: integer := 2
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
end green;

architecture bhv of green is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	
	TYPE StatesTYPE			is (Initialize,Standby,Computing);
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
	SIGNAL ready			: std_logic := '0';
	
	SIGNAL posX				: integer range 0 to SCREEN_WIDTH;
	SIGNAL posY				: integer range 0 to SCREEN_HEIGHT;
	SIGNAL acc				: integer range 0 to 64;
	
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
	
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		VARIABLE nextBlockX			:	integer range 0  to block_size := 0;
		VARIABLE nextBlockY			:	integer range 0  to block_size := 0;
		
		VARIABLE candidateX 		:	integer range 0 to SCREEN_WIDTH;
		VARIABLE candidateY 		:	integer range 0 to SCREEN_WIDTH;
		VARIABLE candidateScore		:	integer range -(score_factor+1)*64*block_size*block_size to (score_factor+1)*64*block_size*block_size;
		
		VARIABLE tempRed			:	integer range 0 to 64;
		VARIABLE tempGreen			:	integer range 0 to 64;
		VARIABLE tempBlue			:	integer range 0 to 64;
		VARIABLE tempScoreForPixel	: 	integer range 0 to 64;
		VARIABLE tempScoreTotal 	: 	integer range 0 to (score_factor+1)*64*block_size*block_size;
		VARIABLE tempSecondaryScoreForPixel	: integer range 0 to 64;
		
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
					candidateScore := 0;
					tempScoreTotal := -(score_factor+1)*64*block_size*block_size;
					
					current_state <= Standby;
					
				when Standby => 
					if (slave_wr_en = '1') then
						if (slave_addr="0000") then
							if (slave_writedata(1)='1') then
								-- PROCESS HAS BEEN TRIGGERED, START COMPUTATION							
								ready <= '0';
								load_waiting := '0';
								
								current_state <= Computing;							
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
								tempRed := to_integer(unsigned(master_readdata(15 downto 11))&'1');
								tempGreen := to_integer(unsigned(master_readdata(10 downto 6))); --ignore LSB of GREEN
								tempBlue := to_integer(unsigned(master_readdata(4 downto 0))&'1');
								
								--We are looking for pixel that has greatest positive difference between find_color and larger of other two
								--if looking for red
								if (find_color = 0) then
									if (tempGreen > tempBlue) then
										tempScoreForPixel := tempRed - tempGreen + 32;
										tempSecondaryScoreForPixel := 64-(tempGreen-tempBlue);
									else
										tempScoreForPixel := tempRed - tempBlue;
										tempSecondaryScoreForPixel := 64-(tempBlue-tempGreen);
									end if;
									
								--if looking for green
								elsif (find_color = 1) then
									if (tempRed > tempBlue) then
										tempScoreForPixel := tempGreen - tempRed + 32;
										tempSecondaryScoreForPixel := 64-(tempRed-tempBlue);
									else
										tempScoreForPixel := tempGreen - tempBlue;
										tempSecondaryScoreForPixel := 64-(tempBlue-tempRed);
									end if;
									
								--if looking for blue
								elsif (find_color = 2) then 
									if (tempRed > tempGreen) then
										tempScoreForPixel := tempBlue - tempRed + 32;
										tempSecondaryScoreForPixel := 64-(tempRed-tempGreen);
									else
										tempScoreForPixel := tempBlue - tempGreen;
										tempSecondaryScoreForPixel := 64-(tempGreen-tempRed);
									end if;
								end if;
								
							
								tempScoreTotal := tempScoreTotal + (tempScoreForPixel*score_factor) + tempSecondaryScoreForPixel;
							--
							
							nextBlockX := nextBlockX + 1;
							if (nextBlockX = block_size) then
								nextBlockX := 0;
								nextBlockY := nextBlockY + 1;
								if (nextBlockY = block_size) then
									nextBlockY := 0;
									--done computing for the block;
									
									if (candidateScore < tempScoreTotal) then
										candidateX := nextX;
										candidateY := nextY;
										candidateScore := tempScoreTotal;
									end if;
									
									tempScoreTotal := 0;
								
								
									nextX := nextX+1;
									if(nextX = (SCREEN_WIDTH-block_size)) then
										nextX := 0;
										nextY := nextY +1;
										
										if (nextY = (SCREEN_HEIGHT-block_size)) then
											-- DONE COMPUTATION
											ready <= '1';
											posX <= candidateX+(block_size/2);
											posY <= candidateY+(block_size/2);
											acc <= candidateScore;
											
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
				--XYAcc encoded word
				when "0000" => slave_readdata <= std_logic_vector(to_unsigned(0,5))&std_logic_vector(to_unsigned(posX,9))&std_logic_vector(to_unsigned(posY,8))&std_logic_vector(to_unsigned(acc,10));
				--X unsigned, 0 to SCREEN_WIDTH
				when "0001" => slave_readdata <= std_logic_vector(to_unsigned(posX,32));
				--Y unsigned, 0 to SCREEN_HEIGHT
				when "0010" => slave_readdata <= std_logic_vector(to_unsigned(posY,32));
				--Accuracy (0 to 64), higher is more accurate
				when "0011" => slave_readdata <= std_logic_vector(to_signed(acc,32));
				--Ready (active high)
				when "0100" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000" & ready;
				
				--debug stuff
				--20
				when "0101" => slave_readdata <= std_logic_vector(to_unsigned(find_color,32));
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
