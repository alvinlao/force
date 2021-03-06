-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity outliner is
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
				
		data_in: in std_logic_vector(34 downto 0);
		data_wait: out std_logic;
		start : in std_logic;
		
		pixel_buffer_base : in std_logic_vector (31 downto 0)
	);
end outliner;

architecture bhv of outliner is
	CONSTANT SCREEN_WIDTH 	: integer := 320;
	CONSTANT SCREEN_HEIGHT 	: integer := 240;
	CONSTANT COLOR1			: std_logic_vector := "0000011111100000";
	CONSTANT COLOR2			: std_logic_vector := "0000011111111111";
	
	TYPE	StatesTYPE	is (Initialize, Standby, Drawing,Waiting);
	TYPE	DrawingTYPE	is (Top, Bottom, LeftSide, RightSide);
	
	SIGNAL current_state 	: StatesTYPE := Standby;
	SIGNAL X1 : integer range 0 to SCREEN_WIDTH;
	SIGNAL X2 : integer range 0 to SCREEN_WIDTH;
	SIGNAL Y1 : integer range 0 to SCREEN_HEIGHT;
	SIGNAL Y2 : integer range 0 to SCREEN_HEIGHT;
	
		
	BEGIN
	  
	process (clk, reset_n)
		VARIABLE nextX 				:	integer range 0 to SCREEN_WIDTH := 0;
		VARIABLE nextY 				:	integer range 0 to SCREEN_HEIGHT := 0;
		VARIABLE CurrentDrawing 	: DrawingTYPE;
		VARIABLE Color				: std_logic_vector (15 downto 0);
	BEGIN
		if (reset_n = '0') then			
			current_state <= Standby;
			nextX := 0;
			nextY := 0;
		elsif rising_edge(clk) then
			data_wait <= '1';
			case (current_state) is
				when Initialize =>
					X1 <= 0;
					X2 <= 0;
					Y1 <= 0;
					Y2 <= 0;
					master_wr_en <= '0';
					master_rd_en <= '0';
					nextX := 0;
					nextY := 0;

				when Standby => 
					data_wait <= '0';
					master_wr_en <= '0';
					master_rd_en <= '0';
					if (start = '1') then
							X1 <= to_integer(unsigned(data_in(25 downto 17)));
							X2 <= to_integer(unsigned(data_in(8 downto 0)));
							Y1 <= to_integer(unsigned(data_in(33 downto 26)));
							Y2 <= to_integer(unsigned(data_in(16 downto 9)));
							if (data_in(34) = '0') then
								Color := COLOR1;
							else
								Color := COLOR2;
							end if;
					
							if(X1 < X2) and (Y1 < Y2) then
								nextX := X1;
								nextY := Y1;
								CurrentDrawing := Top;
								current_state <= Waiting;
							else
								current_state <= Initialize;
							end if;
					end if;
				when Drawing =>
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(nextY,8) & to_unsigned(nextX,9) & '0'));
						master_writedata <= std_logic_vector(Color);
						master_rd_en <= '0';
						master_wr_en <= '1';
						master_be <= "11";
						current_state <= Waiting;
				when Waiting =>
					if (master_waitrequest = '0') then
						current_state <= Drawing;
						master_wr_en <='0';
						case (CurrentDrawing) is
							when Top=>
								-- when drawing top,
								-- increment X until X >X2
								nextX := nextX  + 1;
								if (nextX > X2) then
									-- next is drawing bottom,
									-- so align start position
									nextX := X1;
									nextY := Y2;
									CurrentDrawing := Bottom;
								end if;			
							when Bottom=>
								-- when drawing bottom,
								-- increment X until X >X2
								nextX := nextX  + 1;
								if (nextX > X2) then
									-- next is drawing left,
									-- so align start position
									nextX := X1;
									nextY := Y1;
									CurrentDrawing := Bottom;
								end if;			
							when LeftSide=>
								-- when drawing left,
								-- increment Y until Y >Y2
								nextY := nextY  + 1;
								if (nextY > Y2) then
									-- next is drawing right,
									-- so align start position
									nextX := X2;
									nextY := Y1;
									CurrentDrawing := Bottom;
								end if;			
							when RightSide=>
								-- when drawing left,
								-- increment Y until Y >Y2
								nextX := nextX  + 1;
								if (nextX > X2) then
									-- done outlining, return to standby
									current_state <= Initialize;
								end if;			
							when others=>
								current_state <= Initialize;
							end case;
						end if;
				
				when others=>
					-- why are we here?
					current_state <= Standby;
			end case;
		end if;	
	end process;	
end bhv;