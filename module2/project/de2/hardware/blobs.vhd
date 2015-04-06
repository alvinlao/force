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
									Finalizing);
	TYPE ColTYPE				is  array(0 to 3) of integer range 0 to SCREEN_WIDTH;
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
		
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
		
		VARIABLE	DrawingBox			: integer range 0 to 2;
		
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
					DrawingBox			:= 0;
					
					Col1Top := 0;
					Col2Top := 0;
					Col1Bot := 0;
					Col2Bot := 0;
					
					current_state <= Standby;
					
				when Standby => 
							StatesDebug <= "00000010";
						current_state <= DetectingColumns;
						curX := 0;
						curY := 0;
						load_waiting := '0';
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
					StatesDebug <= "10000000";
					if (draw_box = '1') then
						if (load_waiting = '0') then
							--if (DrawingBox = 1) then
								outline_data <= std_logic_vector('1' & to_unsigned(Col2Top,8) & to_unsigned(Col(2),9) & to_unsigned(Col2Bot,8) & to_unsigned(Col(3),9));
							--elsif (DrawingBox = 2) then
							--	outline_data <= std_logic_vector('0' & to_unsigned(Col1Top,8) & to_unsigned(Col(0),9) & to_unsigned(Col1Bot,8) & to_unsigned(Col(1),9));
							--else
							--	outline_data <= std_logic_vector('0' & to_unsigned(1,8) & to_unsigned(1,9) & to_unsigned(10,8) & to_unsigned(10,9));
							--end if;
							outline_start <= '1';
							load_waiting := '1';
							current_state <= Initialize;
						else
							if (outline_wait ='0') then
							--	outline_start <= '0';
								load_waiting := '0';
							--	if (DrawingBox = 0) then
							--		DrawingBox := 1;
							--	elsif(DrawingBox = 1) then
							--		DrawingBox := 2;
							--	else
									--current_state <= Initialize;
								--end if;
							end if;
						end if;
					else
						if (load_waiting = '0') then
							--if (DrawingBox = 1) then
								--outline_data <= std_logic_vector('1' & to_unsigned(Col2Top,8) & to_unsigned(Col(2),9) & to_unsigned(Col2Bot,8) & to_unsigned(Col(3),9));
							--elsif (DrawingBox = 2) then
								outline_data <= std_logic_vector('0' & to_unsigned(Col1Top,8) & to_unsigned(Col(0),9) & to_unsigned(Col1Bot,8) & to_unsigned(Col(1),9));
							--else
							--	outline_data <= std_logic_vector('0' & to_unsigned(1,8) & to_unsigned(1,9) & to_unsigned(10,8) & to_unsigned(10,9));
							--end if;
							outline_start <= '1';
							load_waiting := '1';
							current_state <= Initialize;
						else
							if (outline_wait ='0') then
							--	outline_start <= '0';
								load_waiting := '0';
							--	if (DrawingBox = 0) then
							--		DrawingBox := 1;
							--	elsif(DrawingBox = 1) then
							--		DrawingBox := 2;
							--	else
									--current_state <= Initialize;
								--end if;
							end if;
						end if;
					end if;
				when others=>
					StatesDebug <= "00000000";
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;
end bhv;