-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity green is
	generic(
		pixel_buffer_base	:	std_logic_vector	:= x"00000000";
		find_color 			:	integer				:= 0;
		max_blobs_count		:	integer				:= 100
	);	
	port (
		clk					:	in std_logic;
		reset_n				:	in std_logic;
				
		master_addr			:	out std_logic_vector(31 downto 0);
		master_rd_en		:	out std_logic;
		master_wr_en		:	out std_logic;
		master_be			:	out std_logic_vector(1 downto 0);
		master_readdata		:	in std_logic_vector(15 downto 0);
		master_writedata	:	out  std_logic_vector(15 downto 0);
		master_waitrequest	:	in std_logic;
		
		slave_addr			:	in std_logic_vector(3 downto 0);
		slave_rd_en			:	in std_logic;
		slave_wr_en			:	in std_logic;
		slave_readdata		:	out std_logic_vector(31 downto 0);
		slave_writedata		:	in std_logic_vector(31 downto 0);
		slave_waitrequest	:	out std_logic
	);
end green;

architecture bhv of green is
	CONSTANT SCREEN_WIDTH 	:	integer	:= 320;
	CONSTANT SCREEN_HEIGHT 	:	integer	:= 240;
	
	TYPE	StatesTYPE			is	(Initialize,Standby,Computing, Finalizing);
	TYPE	FrameTYPE			is	array(0 to SCREEN_WIDTH, 0 to SCREEN_HEIGHT) of integer range 0 to max_blobs_count;
	TYPE	FilterBufferType	is	array (0 to SCREEN_WIDTH*2+2) of integer range 0 to 32;
	TYPE	BlobsType			is	array(0 to max_blobs_count) of std_logic_vector(33 downto 0);
	
	SIGNAL	current_state 	:	StatesTYPE	:= Initialize;
	SIGNAL	ready			:	std_logic	:= '0';
	
	SIGNAL	posX			:	integer range 0 to SCREEN_WIDTH;
	SIGNAL	posY			:	integer range 0 to SCREEN_HEIGHT;
	SIGNAL	acc				:	integer range 0 to 32;
	SIGNAL	threshold		:	integer range 0 to 32	:= 25;
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE	load_waiting		:	std_logic	:= '0';
		
		VARIABLE	Frame				:	FrameType;
		VARIABLE	FilterBuffer		:	FilterBufferType;
		VARIABLE	FilterBufferNext	:	integer range 0 to SCREEN_WIDTH*2+2	:= 0;
		
		VARIABLE	NextNewBlobId		:	integer range 0 to max_blobs_count	:= 0;
		VARIABLE	Blobs				:	BlobsType;
	
		VARIABLE	nextX 				:	integer range 0 to SCREEN_WIDTH	:= 0;
		VARIABLE	nextY 				:	integer range 0 to SCREEN_HEIGHT	:= 0;
		VARIABLE	tmpCount			:	integer range 0 to max_blobs_count := 1;
		VARIABLE	tmpColor			:	integer range 0 to 32;
		VARIABLE	tmpGrey				:	integer range 0 to 32;
		VARIABLE	tmpDiff				:	integer range 0 to 32;
		
		VARIABLE	candidateX			:	integer range 0 to SCREEN_WIDTH;
		VARIABLE	candidateY			:	integer range 0 to SCREEN_HEIGHT;
		VARIABLE	candidateAcc		:	integer range 0 to 32;
		
	BEGIN
		if (reset_n = '0') then			
			current_state <= Initialize;
			ready <= '0';
			nextX	:= 0;
			nextY	:= 0;
			tmpCount	:= 0;
			candidateX	:= 0;
			candidateY	:= 0;
		elsif rising_edge(clk) then
			master_wr_en <= '0';
			master_rd_en <= '0';
			
			case (current_state) is
				when Initialize =>
					nextX	:= 0;
					nextY	:= 0;
					FilterBufferNext	:= 0;
					NextNewBlobId		:= 1;
					current_state <= Standby;
					
				when Standby => 
								ready <= '0';
								load_waiting	:= '0';
								
								current_state <= Computing;		
								
					-- if (slave_wr_en = '1') then
						-- if (slave_addr="0000") then
							-- if (slave_writedata(1)='1') then
								--PROCESS HAS BEEN TRIGGERED, START COMPUTATION							
								-- ready <= '0';
								-- load_waiting	:= '0';
								
								-- current_state <= Computing;							
							-- end if;
						-- end if;
					-- end if;

				when Computing =>
					if (load_waiting = '1') then
						if (master_waitrequest = '0') then
							load_waiting	:= '0';
							master_wr_en <= '0';
							master_rd_en <= '0';

							-- MASTER READDATE is	VALID;
							-- DO SOME OPERATIONS
							
								tmpGrey	:= (to_integer(unsigned(master_readdata(15 downto 11))&'1') + to_integer(unsigned(master_readdata(10 downto 6))) + to_integer(unsigned(master_readdata(4 downto 0))&'1'))/3;
								
								--We are looking for pixel that has greatest positive difference between find_color and larger of other two
								--if looking for red
								if (find_color = 0) then
									tmpColor	:= to_integer(unsigned(master_readdata(15 downto 11))&'1');
									
								--if looking for green
								elsif (find_color = 1) then
									tmpColor	:= to_integer(unsigned(master_readdata(10 downto 6)));
									
								--if looking for blue
								elsif (find_color = 2) then 
									tmpColor	:= to_integer(unsigned(master_readdata(4 downto 0))&'1');
									
								end if;
								
								--Get the Diff
								if (tmpColor - tmpGrey < 0) then
									tmpDiff	:= 0;
								else
									tmpDiff	:= tmpColor - tmpGrey;
								end if;
								
								--Median Filter (TODO)
									
								--BINARIZE AND BLOBIZE
								if(tmpDiff < threshold) then
									Frame(nextX,nextY) := 0; --not a valid pixel
								else
									--this is a valid pixel.
									--look for neighbours
									if(Frame(nextX-1,nextY) /= 0) then
										--this is a neighbour
										--assign same blobId to this one
										Frame(nextX,nextY) := Frame(nextX-1,nextY);
										
										--update Blobs Boundary
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(33 downto 25))) > nextX) then
										--if current pixel is leftmost pixel of current blob
											Blobs(Frame(nextX,nextY))(33 downto 25) := std_logic_vector(to_unsigned(nextX,9));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(16 downto 8))) < nextX) then
										--if current pixel is rightmost pixel of current blob
											Blobs(Frame(nextX,nextY))(16 downto 8) := std_logic_vector(to_unsigned(nextX,9));
										end if;
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(24 downto 17))) > nextY) then
										--if current pixel is topmost pixel of current blob
											Blobs(Frame(nextX,nextY))(24 downto 17) := std_logic_vector(to_unsigned(nextY,8));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(7 downto 0))) < nextY) then
										--if current pixel is bottommost pixel of current blob
											Blobs(Frame(nextX,nextY))(7 downto 0) := std_logic_vector(to_unsigned(nextY,8));
										end if;
										
									
									elsif(Frame(nextX-1,nextY-1) /= 0) then
										--this is a neighbour
										--assign same blobId to this one
										Frame(nextX,nextY) := Frame(nextX-1,nextY-1);
										
										--update Blobs Boundary
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(33 downto 25))) > nextX) then
										--if current pixel is leftmost pixel of current blob
											Blobs(Frame(nextX,nextY))(33 downto 25) := std_logic_vector(to_unsigned(nextX,9));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(16 downto 8))) < nextX) then
										--if current pixel is rightmost pixel of current blob
											Blobs(Frame(nextX,nextY))(16 downto 8) := std_logic_vector(to_unsigned(nextX,9));
										end if;
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(24 downto 17))) > nextY) then
										--if current pixel is topmost pixel of current blob
											Blobs(Frame(nextX,nextY))(24 downto 17) := std_logic_vector(to_unsigned(nextY,8));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(7 downto 0))) < nextY) then
										--if current pixel is bottommost pixel of current blob
											Blobs(Frame(nextX,nextY))(7 downto 0) := std_logic_vector(to_unsigned(nextY,8));
										end if;
										
									elsif(Frame(nextX,nextY-1) /= 0) then
										--this is a neighbour
										--assign same blobId to this one
										Frame(nextX,nextY) := Frame(nextX-1,nextY-1);
										
										--update Blobs Boundary
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(33 downto 25))) > nextX) then
										--if current pixel is leftmost pixel of current blob
											Blobs(Frame(nextX,nextY))(33 downto 25) := std_logic_vector(to_unsigned(nextX,9));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(16 downto 8))) < nextX) then
										--if current pixel is rightmost pixel of current blob
											Blobs(Frame(nextX,nextY))(16 downto 8) := std_logic_vector(to_unsigned(nextX,9));
										end if;
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(24 downto 17))) > nextY) then
										--if current pixel is topmost pixel of current blob
											Blobs(Frame(nextX,nextY))(24 downto 17) := std_logic_vector(to_unsigned(nextY,8));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(7 downto 0))) < nextY) then
										--if current pixel is bottommost pixel of current blob
											Blobs(Frame(nextX,nextY))(7 downto 0) := std_logic_vector(to_unsigned(nextY,8));
										end if;
										
									elsif(Frame(nextX+1,nextY-1) /= 0) then
										--this is a neighbour
										--assign same blobId to this one
										Frame(nextX,nextY) := Frame(nextX-1,nextY-1);
										
										--update Blobs Boundary
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(33 downto 25))) > nextX) then
										--if current pixel is leftmost pixel of current blob
											Blobs(Frame(nextX,nextY))(33 downto 25) := std_logic_vector(to_unsigned(nextX,9));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(16 downto 8))) < nextX) then
										--if current pixel is rightmost pixel of current blob
											Blobs(Frame(nextX,nextY))(16 downto 8) := std_logic_vector(to_unsigned(nextX,9));
										end if;
										if (to_integer(unsigned(Blobs(Frame(nextX,nextY))(24 downto 17))) > nextY) then
										--if current pixel is topmost pixel of current blob
											Blobs(Frame(nextX,nextY))(24 downto 17) := std_logic_vector(to_unsigned(nextY,8));
										elsif (to_integer(unsigned(Blobs(Frame(nextX,nextY))(7 downto 0))) < nextY) then
										--if current pixel is bottommost pixel of current blob
											Blobs(Frame(nextX,nextY))(7 downto 0) := std_logic_vector(to_unsigned(nextY,8));
										end if;
									
									else
										-- it has no neighbour
										-- it is a new blob
										Blobs(NextNewBlobId) := std_logic_vector(to_unsigned(nextX,9))&std_logic_vector(to_unsigned(nextY,8))&std_logic_vector(to_unsigned(nextX,9))&std_logic_vector(to_unsigned(nextY,8));
										NextNewBlobId := NextNewBlobId + 1;
									end if;
									
								end if;
								
								
								nextX	:= nextX+1;
								if(nextX = SCREEN_WIDTH) then
									nextX	:= 0;
									nextY	:= nextY +1;
									
									if (nextY = SCREEN_HEIGHT) then
										-- DONE COMPUTATION
										
										nextX	:= to_integer(unsigned(Blobs(1)(33 downto 25)));
										nextY	:= to_integer(unsigned(Blobs(1)(24 downto 17)));
										tmpCount	:= 1;
										
										current_state <= Finalizing;
										load_waiting	:= '1';
									end if;
								end if;
						else
							master_wr_en <= '0';
							master_rd_en <= '1';
						end if;
					else
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(nextY, 8) & unsigned(to_unsigned(nextX, 9)) & '0'));	
						master_be <= "11";  -- byte enable
						master_wr_en <= '0';
						master_rd_en <= '1';
						
						load_waiting	:= '1';
					end if;
				when Finalizing=>
						if(tmpCount < NextNewBlobId) then
							
							if(master_waitrequest ='0') then
								master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + to_integer(unsigned(Blobs(NextNewBlobId)(24 downto 17))) + to_integer(unsigned(Blobs(NextNewBlobId)(33 downto 25))));
								master_writedata <="1111100000000000";
								master_be <= "11";  -- byte enable
								master_wr_en <= '1';
								master_rd_en <= '0';
								
								nextX	:= nextX+1;
								if(nextX = to_integer(unsigned(Blobs(NextNewBlobId)(16 downto 8)))) then
									nextX	:= to_integer(unsigned(Blobs(NextNewBlobId)(33 downto 25)));
									nextY	:= nextY +1;
									
									if (nextY = to_integer(unsigned(Blobs(NextNewBlobId)(7 downto 0)))) then
										-- DONE CYCLE
																		
										tmpCount	:= tmpCount+1;
										nextX	:= to_integer(unsigned(Blobs(NextNewBlobId)(33 downto 25)));
										nextY	:= to_integer(unsigned(Blobs(NextNewBlobId)(24 downto 17)));
									end if;
								end if;
								
							end if;
						else
							current_state <=Initialize;
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
				--Accuracy (0 to 64), higher is	more accurate
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
