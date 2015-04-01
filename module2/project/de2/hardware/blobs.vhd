-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity blobs is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		max_blob_count	: integer := 5
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
end blobs;

architecture bhv of blobs is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	
	TYPE	StatesTYPE			is (Initialize,Standby,Computing,Finalizing);
	TYPE	FrameTYPE			is array(0 to SCREEN_WIDTH, 0 to SCREEN_HEIGHT) of integer range 0 to max_blob_count;
	TYPE 	BlobsTYPE			is array (0 to max_blob_count) of std_logic_vector(33 downto 0);
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
	SIGNAL blobs	: BlobsTYPE;
	SIGNAL nextBlobsId : integer range 1 to max_blob_count;
	SIGNAL ready : std_logic := '1';
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
		
--		VARIABLE Frame				: FrameType;
	
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		
		VARIABLE Frame	: FrameTYPE;
		
		VARIABLE tmpHasNeighbour	:	std_logic;
		VARIABLE tmpNeighbourID		: integer range 0 to max_blob_count;
		
		VARIABLE tmpX1	:	 integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpY1	:	 integer range 0 to SCREEN_HEIGHT;
		VARIABLE tmpX2	:	 integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpY2	:	 integer range 0 to SCREEN_HEIGHT;
		
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
					nextBlobsId <= 1;
					ready <= '1';
					
					current_state <= Standby;
					
				when Standby => 
						load_waiting := '0';
						ready <= '1';
						
						if (slave_wr_en = '1') then
						if (slave_addr="0000") then
							if (slave_writedata(0) = '1') then
								current_state <= Computing;
								nextX := 0;
								nextY := 0;
								load_waiting := '0';
								ready <= '0';
							end if;
						end if;
					end if;
				when Computing =>
					ready <= '0';
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting := '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
							if (master_readdata(15)='1') then
								tmpHasNeighbour := '0';
								if (Frame(nextX-1,nextY) /= 0) then
									tmpHasNeighbour := '0';
									tmpNeighbourID := Frame(nextX-1,nextY);
								elsif (Frame(nextX-1,nextY-1) /= 0) then
									tmpHasNeighbour := '0';
									tmpNeighbourID := Frame(nextX-1,nextY-1);
								elsif (Frame(nextX,nextY-1) /= 0) then
									tmpHasNeighbour := '0';
									tmpNeighbourID := Frame(nextX,nextY-1);
								elsif (Frame(nextX+1,nextY-1) /= 0) then
									tmpHasNeighbour := '0';
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
									current_state <= Finalizing;
									load_waiting := '1';
								end if;
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
					
				when Finalizing=>
					ready <= '1';
				when others=>
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;	

   process (slave_rd_en, slave_addr,blobs)
   begin	       
		slave_readdata <= (others => '-');
		if (slave_rd_en = '1') then
			case slave_addr is
				when "0000" => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0000_000"&ready;
				when "0001" => slave_readdata <= "000000000000000" & blobs(1)(33 downto 17);
				when "0010" => slave_readdata <= "000000000000000" & blobs(1)(16 downto 0);
				when "0011" => slave_readdata <= "000000000000000" & blobs(2)(33 downto 17);
				when "0100" => slave_readdata <= "000000000000000" & blobs(2)(16 downto 0);
				--debug stuff
				--20
				when "0101" => slave_readdata <= std_logic_vector(to_unsigned(nextBlobsId,32));
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
				when others => slave_readdata <= b"0000_0000_0000_0000_0000_0000_0001_0000"; --address x - 16
			end case;
		end if;
    end process;			
end bhv;