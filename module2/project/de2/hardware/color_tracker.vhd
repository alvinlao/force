-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity color_tracker is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		back_buffer_base : std_logic_vector := x"00000000";
		find_color : integer := 0;
		thresold	:	integer := 25 --between 0(black) to 32(white)
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
		master_waitrequest : in std_logic
	);
end color_tracker;

architecture bhv of color_tracker is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	
	TYPE StatesTYPE			is (Initialize,Standby,Computing);
--	Type FrameType 			is	array(0 to SCREEN_WIDTH, 0 to SCREEN_HEIGHT) of integer range 0 to 32;
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
		
--		VARIABLE Frame				: FrameType;
	
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		VARIABLE tmpColor			:	integer range 0 to 32;
		VARIABLE tmpGrey			:	integer range 0 to 32;
		variable tmpDiff			:	integer range 0 to 32;
		
	BEGIN
		if (reset_n = '0') then			
			current_state <= Initialize;
			nextX := 0;
			nextY := 0;
		elsif rising_edge(clk) then
			master_wr_en <= '0';
			master_rd_en <= '0';
			
			case (current_state) is
				when Initialize =>
					nextX := 0;
					nextY := 0;
					
					current_state <= Standby;
					
				when Standby => 
						load_waiting := '0';
						current_state <= Computing;		
				when Computing =>
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting := '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
								tmpGrey := (to_integer(unsigned(master_readdata(15 downto 11))&'1') + to_integer(unsigned(master_readdata(10 downto 6))) + to_integer(unsigned(master_readdata(4 downto 0))&'1'))/3;
								
								--We are looking for pixel that has greatest positive difference between find_color and larger of other two
								--if looking for red
								if (find_color = 0) then
									tmpColor := to_integer(unsigned(master_readdata(15 downto 11))&'1');
									
								--if looking for color_tracker
								elsif (find_color = 1) then
									tmpColor := to_integer(unsigned(master_readdata(10 downto 6)));
									
								--if looking for blue
								elsif (find_color = 2) then 
									tmpColor := to_integer(unsigned(master_readdata(4 downto 0))&'1');
									
								end if;
								
								if (tmpColor - tmpGrey < 0) then
									tmpDiff := 0;
								else
									tmpDiff := tmpColor - tmpGrey;
								end if;
								
								if (master_waitrequest='0') then
									
									if(tmpDiff < thresold) then
										master_writedata <= std_logic_vector(to_unsigned(0,16));
									else
										master_writedata <= std_logic_vector(to_unsigned(65535,16));
									end if;
									
								
									master_addr <= std_logic_vector(unsigned(back_buffer_base) + unsigned(to_unsigned(nextY, 8) & to_unsigned(nextX, 9) & '0'));
									master_be <= "11";  -- byte enable
									master_wr_en <= '1';
									master_rd_en <= '0';
									
								
									nextX := nextX+1;
									if(nextX = SCREEN_WIDTH) then
										nextX := 0;
										nextY := nextY +1;
										
										if (nextY = SCREEN_HEIGHT) then
											-- DONE COMPUTATION
											
											nextX := 0;
											nextY := 0;
											current_state <= Initialize;
											load_waiting := '1';
										end if;
									end if;
								else
									master_wr_en <='0';
								end if;
						else
							master_wr_en <= '0';
							master_rd_en <= '1';
						end if;
					else
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(nextY, 8) & to_unsigned(nextX, 9) & '0'));	
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
end bhv;
