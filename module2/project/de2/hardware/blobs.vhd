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
	CONSTANT max_RL_Size : integer := 5;
	CONSTANT max_blob_count : integer := 15;
	
	TYPE	StatesTYPE			is (Initialize,Standby,RunLengthEncoding,Blobbing,Finalizing);
	TYPE	RunLengthTYPE		is array(0 to SCREEN_HEIGHT, 0 to max_RL_Size) of std_logic_vector(21 downto 0);
	TYPE 	BlobsType			is array(0 to max_blob_count) of std_logic_vector(33 downto 0);
	
	SIGNAL current_state 	: StatesTYPE := Initialize;
	SIGNAL overflow			: std_logic := '0';
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE load_waiting		: std_logic := '0';
			
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		
		VARIABLE RunLength			: RunLengthTYPE := ((others=> (others=>(others=>'0'))));
		VARIABLE tmpInBlack			: std_logic;
		
		VARIABLE Blobs				: BlobsType := ((others=> (others=>'0')));
		
		VARIABLE tmpRun				: integer range 0 to max_RL_Size+1;
		VARIABLE tmpIndex 			: integer range 0 to max_RL_Size;
		
		VARIABLE tmpStart 	: integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpEnd 	: integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpPrevRowStart 	: integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpPrevRowEnd 	: integer range 0 to SCREEN_WIDTH;
		VARIABLE tmpNextBlobId : integer range 0 to max_blob_count;
		
		VARIABLE tmpBlob : integer range 0 to max_blob_count := 1;
		
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
					tmpInBlack := '0';
					overflow <= '0';
					current_state <= Standby;
					tmpNextBlobId := 1;
					RunLength := ((others=> (others=>(others=>'0'))));
					Blobs := ((others=> (others=>'0')));
					
				when Standby => 
						current_state <= RunLengthEncoding;
						nextX := 0;
						nextY := 0;
						load_waiting := '0';
				when RunLengthEncoding =>
					if (load_waiting = '1') then
						if (pb_master_waitrequest = '0') then
							load_waiting := '0';
							pb_master_wr_en <= '0';
							pb_master_rd_en <= '0';

							-- MASTER READDATE IS VALID;
							-- DO SOME OPERATIONS
							
							--Frame(nextX,nextY) := pb_master_readdata(15);
							
							if (pb_master_readdata(15)='1') then
								--if block is valid;
								if (tmpInBlack ='0') then
									-- start a new run
									tmpRun := tmpRun + 1;
									if (tmpRun > max_RL_Size) then
										overflow <= '1';
									end if;
									if (nextY = 0) then
										-- first row gets initialized with valid blobId
										RunLength(nextY,tmpRun) := std_logic_vector(to_unsigned(tmpNextBlobId,4) & to_unsigned(nextX,9) & to_unsigned(SCREEN_WIDTH-1,9));
										Blobs(tmpNextBlobId) := std_logic_vector(to_unsigned(0,8)&to_unsigned(nextX,9)&to_unsigned(0,8)&to_unsigned(0,9));
										tmpNextBlobId := tmpNextBlobId + 1;
									else
										RunLength(nextY,tmpRun) := std_logic_vector(to_unsigned(0,4) & to_unsigned(nextX,9) & to_unsigned(SCREEN_WIDTH-1,9));
									end if;
								end if;
							
							else
								--if block is not valid;
								if (tmpInBlack = '1') then
									-- finalize current run
									RunLength(nextY,tmpRun)(8 downto 0) := std_logic_vector(to_unsigned(nextX,9));
									if (RunLength(nextY,tmpRun)(21 downto 18) /= "0000") then
										--if RunLength has BlobId
										Blobs(to_integer(unsigned(RunLength(nextY,tmpRun)(21 downto 18))))(8 downto 0) := std_logic_vector(to_unsigned(nextX,9));
									end if;
								end if;
							end if;
								
							nextX := nextX+1;
							if(nextX = SCREEN_WIDTH) then
								-- new row
								nextX := 0;
								nextY := nextY +1;
								tmpRun := 0;
								tmpInBlack := '0';
								
								if (nextY = SCREEN_HEIGHT) then
									-- DONE COMPUTATION
									
									nextX := 1;
									nextY := 1;
									tmpStart := to_integer(unsigned(RunLength(nextY,nextX)(17 downto 9)));
									tmpEnd :=  to_integer(unsigned(RunLength(nextY,nextX)(8 downto 0)));
									tmpPrevRowStart :=  to_integer(unsigned(RunLength(nextY-1,tmpIndex)(17 downto 9)));
									tmpPrevRowEnd :=  to_integer(unsigned(RunLength(nextY-1,tmpIndex)(8 downto 0)));
					
									tmpIndex := 1;
									current_state <= Blobbing;
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
					
				when Blobbing=>
				
					if ((tmpPrevRowStart >= tmpStart) and (tmpPrevRowStart <= tmpEnd )) 
					or ((tmpPrevRowStart <= tmpStart) and (tmpPrevRowEnd >= tmpStart)) then
						-- there is overlap						
						if (RunLength(nextY,nextX)(21 downto 18) /= "0000") then
							-- if there is already Id assigned (It is a MERGE)
						end if;
						
						RunLength(nextY,nextX)(21 downto 18) := RunLength(nextY-1,tmpIndex)(21 downto 18);
						
						--increase Y2 to current Y
						Blobs(to_integer(unsigned(RunLength(nextY-1,tmpIndex)(21 downto 18))))(16 downto 9) := std_logic_vector(to_unsigned(nextY,8));
						
						--check X1 and X2 bounds and increase if needed
						if (to_integer(unsigned(Blobs(to_integer(unsigned(RunLength(nextY-1,tmpIndex)(21 downto 18))))(25 downto 17))) > nextX) then
							Blobs(to_integer(unsigned(RunLength(nextY-1,tmpIndex)(21 downto 18))))(25 downto 17) := std_logic_vector(to_unsigned(nextX,9));
						elsif(to_integer(unsigned(Blobs(to_integer(unsigned(RunLength(nextY-1,tmpIndex)(21 downto 18))))(8 downto 0))) <nextX) then
							Blobs(to_integer(unsigned(RunLength(nextY-1,tmpIndex)(21 downto 18))))(8 downto 0) := std_logic_vector(to_unsigned(nextX,9));
						end if;
					else
						tmpIndex := tmpIndex + 1;
						if (tmpIndex = max_RL_Size) or (RunLength(nextY-1,tmpIndex) = std_logic_vector(to_unsigned(0,34))) then
							-- finished looping for current run
							if (RunLength(nextY,nextX)(21 downto 18)="0000") then
								-- if current run still does not have a Id
								-- Assign a new Id;
								RunLength(nextY,nextX)(21 downto 18):= std_logic_vector(to_unsigned(tmpNextBlobId,4));
								Blobs(tmpNextBlobId) := std_logic_vector(to_unsigned(nextY,8)) & RunLength(nextY,nextX)(17 downto 9) & std_logic_vector(to_unsigned(0,8)) & RunLength(nextY,nextX)(8 downto 0);
								tmpNextBlobId := tmpNextBlobId + 1;
							end if;
							
							tmpIndex := 1;
							nextX := nextX + 1;
							if (nextX = max_RL_Size) then
								--finished current row
								nextX := 1;
								nextY := nextY+1;
								if (nextY = SCREEN_HEIGHT) then
									tmpBlob := 1;
									current_state <= Finalizing;
								end if;
							end if;
							
							tmpStart := to_integer(unsigned(RunLength(nextY,nextX)(17 downto 9)));
							tmpEnd :=  to_integer(unsigned(RunLength(nextY,nextX)(8 downto 0)));
							
						end if;
						
						tmpPrevRowStart :=  to_integer(unsigned(RunLength(nextY-1,tmpIndex)(17 downto 9)));
						tmpPrevRowEnd :=  to_integer(unsigned(RunLength(nextY-1,tmpIndex)(8 downto 0)));
						
					end if;
					
				when Finalizing=>
					if (draw_box = '1') then
						if (tmpBlob < tmpNextBlobId) then
							if (outline_wait ='0') then
								outline_data <= Blobs(tmpBlob);
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
						current_state <= Initialize;
					end if;
				when others=>
					-- why are we here?
					current_state <= Initialize;
			end case;
		end if;	
	end process;	
end bhv;