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
		
		outline_start : out std_logic;
		outline_data : out std_logic_vector(33 downto 0);
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
	CONSTANT max_blob_count : integer := 5;
	
	TYPE	StatesTYPE			is (Initialize,Standby,Computing,Finalizing);
	TYPE	FrameTYPE			is array(0 to SCREEN_WIDTH, 0 to SCREEN_HEIGHT) of integer range 0 to max_blob_count;
	TYPE 	BlobsTYPE			is array (0 to max_blob_count) of std_logic_vector(33 downto 0);
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
	SIGNAL blobs	: BlobsTYPE;
	SIGNAL nextBlobsId : integer range 1 to max_blob_count;
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
			
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		
		VARIABLE Frame	: FrameTYPE;
		
		VARIABLE tmpHasNeighbour	:	std_logic;
		VARIABLE tmpNeighbourID		: integer range 0 to max_blob_count;
		
		VARIABLE tmpX1	:	 integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpY1	:	 integer range 0 to SCREEN_HEIGHT;
		VARIABLE tmpX2	:	 integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpY2	:	 integer range 0 to SCREEN_HEIGHT;
		
		VARIABLE tmpBlob : 	integer range 0 to max_blob_count;
		
	BEGIN
		if (reset_n = '0') then			
			current_state <= Initialize;
			nextX := 0;
			nextY := 0;
		elsif rising_edge(clk) then
			pb_master_wr_en <= '0';
			pb_master_rd_en <= '0';
			outline_start <= '0';
			
			case (current_state) is
				when Initialize =>
					nextX := 0;
					nextY := 0;
					nextBlobsId <= 1;
					
					current_state <= Standby;
					
				when Standby => 
						current_state <= Computing;
						nextX := 0;
						nextY := 0;
						load_waiting := '0';
				when Computing =>
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
							--Frame(nextX,nextY) := pb_master_readdata(15);
							
							if (pb_master_readdata(15)='1') then
								tmpHasNeighbour := '0';
								if (Frame(nextX-1,nextY) /= 0) then
									tmpHasNeighbour := '1';
									tmpNeighbourID := Frame(nextX-1,nextY);
								elsif (Frame(nextX-1,nextY-1) /= 0) then
									tmpHasNeighbour := '1';
									tmpNeighbourID := Frame(nextX-1,nextY-1);
								elsif (Frame(nextX,nextY-1) /= 0) then
									tmpHasNeighbour := '1';
									tmpNeighbourID := Frame(nextX,nextY-1);
								elsif (Frame(nextX+1,nextY-1) /= 0) then
									tmpHasNeighbour := '1';
									tmpNeighbourID := Frame(nextX+1,nextY-1);
								end if;
								if (tmpHasNeighbour='1') then
									-- has neighbour
									Frame(nextX,nextY) := tmpNeighbourID;
									
									tmpX1 := to_integer(unsigned(blobs(tmpNeighbourID)(25 downto 17)));
									tmpY1 := to_integer(unsigned(blobs(tmpNeighbourID)(33 downto 26)));
									tmpX2 := to_integer(unsigned(blobs(tmpNeighbourID)(8 downto 0)));
									tmpY2 := to_integer(unsigned(blobs(tmpNeighbourID)(16 downto 9)));
									if(tmpX1 > nextX) then
										tmpX1 := nextX;
									elsif (tmpX2 < nextX) then
										tmpX2 := nextX;
									end if;
									if(tmpY1 > nextY) then
										tmpY1 := nextY;
									elsif (tmpY2 < nextY) then
										tmpY2 := nextY;
									end if;
									blobs(tmpNeighbourID) <= std_logic_vector(to_unsigned(tmpY1,8)&to_unsigned(tmpX1,9)&to_unsigned(tmpY2,8)&to_unsigned(tmpX2,9));
									
									
								else
									--is start of new blob
									Frame(nextX,nextY) := nextBlobsId;
									blobs(nextBlobsId) <= std_logic_vector(to_unsigned(nextY,8)&to_unsigned(nextX,9)&to_unsigned(nextY,8)&to_unsigned(nextX,9));
									
									nextBlobsId <= nextBlobsId + 1;
								end if;
							end if;
								
							nextX := nextX+1;
							if(nextX = SCREEN_WIDTH) then
								nextX := 0;
								nextY := nextY +1;
								
								if (nextY = SCREEN_HEIGHT) then
									-- DONE COMPUTATION
									
									nextX := 0;
									nextY := 0;
									tmpBlob := 1;
									current_state <= Finalizing;
									load_waiting := '1';
								end if;
							end if;
						else
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '1';
						end if;
					else
						pb_master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(nextY, 8) & to_unsigned(nextX, 9) & '0'));	
						pb_master_be <= "11";  -- byte enable
						pb_master_wr_en <= '0';
						pb_master_rd_en <= '1';
						
						load_waiting := '1';
					end if;
					
				when Finalizing=>
					if (draw_box = '1') then
						if (tmpBlob < nextBlobsId) then
							if (outline_wait ='0') then
								outline_data <= blobs(tmpBlob);
								outline_start <= '1';
								tmpBlob := tmpBlob + 1;
							else
								outline_start <= '0';
							end if;
						else
							current_state <= Initialize;
						end if;
					else
						if (outline_wait ='0') then
							outline_data <= std_logic_vector(to_unsigned(100,8) & to_unsigned(100,9) & to_unsigned(200,8) & to_unsigned(200,9));
							outline_start <= '1';
						end if;
					end if;
				when others=>
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;	
end bhv;