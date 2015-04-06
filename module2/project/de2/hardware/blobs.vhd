-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity blobs is
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;
		
		draw_box : in std_logic;
		
		StatesDebug: out std_logic_vector(7 downto 0);
		ColDebug: out std_logic_vector(8 downto 0);
		ColSelect : in std_logic_vector(1 downto 0);
		
		outline_start : out std_logic;
		outline_data : out std_logic_vector(34 downto 0);
		outline_wait : in std_logic;
						
		pb_master_addr : out std_logic_vector(31 downto 0);
		pb_master_rd_en : out std_logic;
		pb_master_wr_en : out std_logic;
		pb_master_be : out std_logic_vector(1 downto 0);
		pb_master_readdata : in std_logic_vector(15 downto 0);
		pb_master_writedata: out  std_logic_vector(15 downto 0);
		pb_master_waitrequest : in std_logic;

		slave_addr: in std_logic_vector(3 downto 0);
		slave_rd_en: in std_logic;
		slave_wr_en: in std_logic;
		slave_readdata: out std_logic_vector(31 downto 0);
		slave_writedata: in std_logic_vector(31 downto 0);
		slave_waitrequest : out std_logic;
		
		pixel_buffer_base : in std_logic_vector (31 downto 0)
	);
end blobs;

architecture bhv of blobs is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	
	TYPE	StatesTYPE			is (Initialize,Standby,
									DetectingColumns,
									DetectingColumn1_Top,
									DetectingColumn1_Bottom,
									DetectingColumn2_Top,
									DetectingColumn2_Bottom,
									Finalizing, Previewing);
	TYPE ColTYPE				is  array(0 to 3) of integer range 0 to SCREEN_WIDTH;
	
	SIGNAL	current_state 		:	StatesTYPE := Initialize;
	SIGNAL	ready				:	std_logic := '0';
	SIGNAL	Channel1Midpoint	:	std_logic_vector (31 downto 0);
	SIGNAL	Channel2Midpoint	:	std_logic_vector (31 downto 0);
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting			:	std_logic := '0';
			
		VARIABLE	curX 				:	integer range -1 to SCREEN_WIDTH := 0;
		VARIABLE	curY 				:	integer range -1 to SCREEN_HEIGHT := 0;
		
		VARIABLE	LookingForColumn	:	integer range 0 to 3 := 0;
		
		VARIABLE	Col					:	ColTYPE := ((others=> 0));
		VARIABLE	CurrentColHasWhite	:	std_logic := '0';
		VARIABLE	ColumnFound			:	std_logic := '0';
		
		VARIABLE	Col1Top				: integer range 0 to SCREEN_HEIGHT;
		VARIABLE	Col1Bot				: integer range 0 to SCREEN_HEIGHT;
		VARIABLE	Col2Top				: integer range 0 to SCREEN_HEIGHT;
		VARIABLE	Col2Bot				: integer range 0 to SCREEN_HEIGHT;
		
		VARIABLE	DrawingBox			: integer range 1 to 2 := 1;
		
	BEGIN
		if (reset_n = '0') then			
			current_state <= Initialize;
		elsif rising_edge(clk) then
			pb_master_wr_en <= '0';
			pb_master_rd_en <= '0';
			outline_start <= '0';
			
			if (ColSelect = "00") then
				ColDebug <= std_logic_vector(to_unsigned(Col1Bot,9));
			elsif(ColSelect = "01") then
				ColDebug <= std_logic_vector(to_unsigned(Col(1),9));
			elsif(ColSelect = "10") then
				ColDebug <= std_logic_vector(to_unsigned(Col(2),9));
			else
				ColDebug <= std_logic_vector(to_unsigned(Col(3),9));
			end if;
			
			case (current_state) is
				when Initialize =>
					StatesDebug <= "00000001";
					curX := 0;
					curY := 0;
					
					LookingForColumn 	:= 0;
					Col 				:= ((others=> 0));
					CurrentColHasWhite 	:= '0';
					
					Col1Top := 0;
					Col2Top := 0;
					Col1Bot := 0;
					Col2Bot := 0;
					
					current_state <= Standby;
					
				when Standby => 
					StatesDebug <= "00000010";
					if (slave_wr_en = '1') then
						if (slave_addr="0000") then
							if (slave_writedata(1)='1') then
								-- PROCESS HAS BEEN TRIGGERED, START COMPUTATION							
								ready <= '0';
								current_state <= DetectingColumns;
								curX := 0;
								curY := 0;
								load_waiting := '0';
							end if;
						end if;
					end if;
				when DetectingColumns =>
				StatesDebug <= "00000100";
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
							if (pb_master_readdata(15)='1') then
								if (LookingForColumn = 0) then
									Col(0) := curX;
									ColumnFound := '1';
								elsif (LookingForColumn = 2) then
									Col(2) := curX;
									ColumnFound := '1';
								else
									CurrentColHasWhite := '1';
								end if;
							end if;
								
							curY := curY+1;
							if ((curY = SCREEN_HEIGHT) or (ColumnFound='1')) then
								--End of Column (or no need to continue this column)
								if (CurrentColHasWhite = '0') then
									if (LookingForColumn = 1) then
										Col(1) := curX;
										ColumnFound := '1';
									elsif (LookingForColumn = 3) then
										Col(3) := curX;
										ColumnFound := '1';
									end if;
								end if;
								
								curY := 0;
								curX := curX +1;
								CurrentColHasWhite := '0';
								
								if (ColumnFound = '1') then
									if (LookingForColumn = 3) then
										--Found All Columns
										curX := Col(0);
										curY := 0;
										current_state <= DetectingColumn1_Top;
									else
										LookingForColumn := LookingForColumn + 1;
									end if;
								end if;
								
								ColumnFound := '0'; 
								
								if (curX = SCREEN_WIDTH) then
									-- DONE COMPUTATION
									
									curX := Col(0);
									curY := 0;
									current_state <= DetectingColumn1_Top;
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curY, 8) & to_unsigned(curX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					
				when DetectingColumn1_Top=>
				StatesDebug <= "00001000";
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';
							
							if (pb_master_readdata(15)='1') then
								--found Top
								Col1Top := curY;
								curX := Col(2);
								curY := 0;
								current_state <= DetectingColumn2_Top;
							end if;
							
							curX := curX + 1;
							if (curX > Col(1)) then
								curX := Col(0);
								curY := curY + 1;
								if (curY = SCREEN_HEIGHT) then
									--failed to find top
									Col1Top := curY;
									curX := Col(2);
									curY := 0;
									current_state <= DetectingColumn2_Top;
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curY, 8) & to_unsigned(curX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					
				when DetectingColumn1_Bottom=>
				StatesDebug <= "00010000";
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';
							
							if (pb_master_readdata(15)='1') then
								--found Bottom
								Col1Bot := curY;
								curX := Col(2);
								curY := SCREEN_HEIGHT-1;
								current_state <= DetectingColumn2_Bottom;
							end if;
							
							curX := curX + 1;
							if (curX > Col(1)) then
								curX := Col(0);
								curY := curY - 1;
								if (curY = -1) then
									--failed to find bottom
									Col1Bot := curY;
									curX := Col(2);
									curY := SCREEN_HEIGHT-1;
									current_state <= DetectingColumn2_Bottom;
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curY, 8) & to_unsigned(curX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					

				when DetectingColumn2_Top=>
				StatesDebug <= "00100000";
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';
							
							if (pb_master_readdata(15)='1') then
								--found Top
								Col2Top := curY;
								curX := Col(0);
								curY := SCREEN_HEIGHT-1;
								current_state <= DetectingColumn1_Bottom;
							end if;
							
							curX := curX + 1;
							if (curX > Col(3)) then
								curX := Col(2);
								curY := curY + 1;
								if (curY = SCREEN_HEIGHT) then
									--failed to find top
									Col2Top := curY;
									curX := Col(0);
									curY := SCREEN_HEIGHT-1;
									current_state <= DetectingColumn1_Bottom;
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curY, 8) & to_unsigned(curX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					

				when DetectingColumn2_Bottom=>
					StatesDebug <= "01000000";
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';
							
							if (pb_master_readdata(15)='1') then
								--found Bottom
								Col2Bot := curY;
								curX := 0;
								curY := 0;
								load_waiting := '1';
								current_state <= Finalizing;
							end if;
							
							curX := curX + 1;
							if (curX > Col(3)) then
								curX := Col(2);
								curY := curY - 1;
								if (curY = -1) then
									--failed to find bottom
									Col2Bot := curY;
									curX := 0;
									curY := 0;
									load_waiting := '1';
									current_state <= Finalizing;
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(curY, 8) & to_unsigned(curX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					
				when Finalizing=>
					ready <= '1';
					Channel1Midpoint <= std_logic_vector(to_unsigned(0,7) & to_unsigned(Col(0)+((Col(1) - Col(0))/2),9) & to_unsigned((Col1Top+(Col1Bot - Col1Top)/2),8) & to_unsigned(0,8));
					Channel2Midpoint <= std_logic_vector(to_unsigned(0,7) & to_unsigned(Col(2)+((Col(3) - Col(2))/2),9) & to_unsigned((Col2Top+(Col2Bot - Col2Top)/2),8) & to_unsigned(0,8));
					current_state <= Previewing;

				when Previewing=>
					StatesDebug <= "10000000";
					if (draw_box = '1') then
						if (load_waiting = '0') then
							if (DrawingBox = 1) then
								outline_data <= std_logic_vector('1' & to_unsigned(Col2Top,8) & to_unsigned(Col(2),9) & to_unsigned(Col2Bot,8) & to_unsigned(Col(3),9));
								outline_start <= '1';
								load_waiting := '1';
								current_state <= Initialize;
								DrawingBox := 2;
							else
								outline_data <= std_logic_vector('0' & to_unsigned(Col1Top,8) & to_unsigned(Col(0),9) & to_unsigned(Col1Bot,8) & to_unsigned(Col(1),9));
								outline_start <= '1';
								load_waiting := '1';
								current_state <= Initialize;
								DrawingBox := 1;
							end if;
						else
							if (outline_wait ='0') then
								load_waiting := '0';
							end if;
						end if;
					else
						current_state <= Initialize;
					end if;
				when others=>
					StatesDebug <= "00000000";
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;

  process (slave_rd_en, slave_addr,Channel1Midpoint,Channel2Midpoint)
    BEGIN	       
		 slave_readdata <= (others => '-');
		 if (slave_rd_en = '1') then
			 case slave_addr is
				
				--0 ready
				 when "0000" => slave_readdata <= std_logic_vector(to_unsigned(0,31)) & ready;
				--4 ch1 xy
				 when "0001" => slave_readdata <= Channel1Midpoint;
				--8 ch2 xy
				 when "0010" => slave_readdata <= Channel2Midpoint;
				
				 when "0011" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				 when "0100" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
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