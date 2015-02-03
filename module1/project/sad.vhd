library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sad is
	generic(
		pixel_buffer_base : std_logic_vector := x"00000000";
		win_size_x: integer := 20;
		win_size_y: integer := 20;
		block_size_x: integer := 7;
		block_size_y: integer := 7;
		step_x: integer := 1;
		step_y: integer := 1		
	);	
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;
		
		start 	: in std_logic;
		ready 	: out std_logic;
		
		posX 	: out std_logic_vector(8 downto 0);
		posY 	: out std_logic_vector(7 downto 0);
		acc		: out std_logic_vector(5 downto 0);
		
		
		slave_addr: in std_logic_vector(2 downto 0);
		slave_rd_en: in std_logic;
		slave_wr_en: in std_logic;
		slave_readdata: out std_logic_vector(31 downto 0);
		slave_writedata: in std_logic_vector(31 downto 0);
		
		master_addr : out std_logic_vector(31 downto 0);
		master_rd_en : out std_logic;
		master_wr_en : out std_logic;
		master_be : out std_logic_vector(1 downto 0);
		master_readdata : in std_logic_vector(15 downto 0);
		master_writedata: out  std_logic_vector(15 downto 0);
		master_waitrequest : in std_logic
	);
end sad;

architecture bhv of sad is
	type States is (Standby,Loading,CalculatingSAD, AddingSAD,Picking);
	type WindowType is array (0 to win_size_x, 0 to win_size_y) of std_logic_vector(15 downto 0);
	type BlockType is array (0 to block_size_x, 0 to block_size_y) of std_logic_vector(15 downto 0);
	type SadBlockType is array (0 to block_size_x-1, 0 to block_size_y-1) of integer range 0 to 65536;
	type SadWindowType is array (0 to (win_size_x - block_size_x)/step_x, 0 to (win_size_y - block_size_y)/step_y) of SadBlockType;
	type SADForEachBlocksType is array (0 to (win_size_x - block_size_x)/step_x, 0 to (win_size_y - block_size_y)/step_y) of integer range 0 to 65536;
	
    signal current_state : States := Standby;
	signal next_state : States := Standby;
	
	signal Window : WindowType;
	signal nextLoadX : integer range 0 to win_size_x;
	signal nextLoadY : integer range 0 to win_size_y;
	
	
	signal lastPosX : integer range 0 to 320;
	signal lastPosY : integer range 0 to 240;
	signal windowStartX : integer range 0 to (320 - win_size_x);
	signal windowStartY : integer range 0 to (240 - win_size_y);
	
	signal ReferenceBlock : BlockType;
	signal SADForEachBlock :SADForEachBlocksType;

	signal lastAddX : integer range 0 to 320;
	signal lastAddY : integer range 0 to 240;
	
	
	begin
	
		--state machine process;
		process(clk, reset_n)
		begin
			if (reset_n = '0') then
				current_state <= Standby;
				next_state <= Standby;
			elsif rising_edge(clk) then
			next_state <= current_state;
				case current_state is
					when Standby => 
						if (start = '1') then
							next_state <= Loading;
							nextLoadX <= 0;
							nextLoadY <= 0;
						end if;
					when Loading => 
					
					when CalculatingSAD => 
					
					when AddingSAD => 
					
					when Picking => 
					
					when others =>
						next_state <= current_state;
				end case;
			end if;
		end process;	  
	   
		--do some shit - loading
		process(clk)
		begin
			if(rising_edge(clk)) then
				if (current_state = Loading) then
				
						-- this section needs more work
						master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(to_unsigned(windowStartX + nextLoadX, 9)) & unsigned(to_unsigned(windowStartY + nextLoadY, 8)) & '0');	
						master_be <= "11";  -- byte enable
						master_wr_en <= '0';
						master_rd_en <= '1';
						  
						Window(nextLoadX,nextLoadY) <= master_readdata;
						--
				end if;
			end if;
		end process;
		
		
		--generate some shit - calculating sad for blocks
		
GEN_WIN_ROW:
    for WIN_ROW in 0 to ((win_size_x - block_size_x)/step_x) generate
    begin
GEN_WIN_COL:
        for WIN_COL in 0 to ((win_size_y - block_size_y)/step_y) generate
        begin
GEN_BLK_ROW:
			for BLK_ROW in 0 to (block_size_x-1) generate
			begin
GEN_BLK_ROW:
				for BLK_COL in 0 to (block_size_y-1) generate
				begin
					process(current_state, clk)
					begin
						if(rising_edge(clk)) then
							if (current_state = CalculatingSAD) then
							SADCollection(WIN_ROW,WIN_COL)(BLK_ROW,BLK_COL) <= to_integer(
								(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(15 downto 11)) - signed('0'&ReferenceBlock(WIN_ROW+BLK_ROW,WIN_COL+BLK_COL)(15 downto 11)))) and B"01_1111") + 
								(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(10 downto 5)) - signed('0'&ReferenceBlock(WIN_ROW+BLK_ROW,WIN_COL+BLK_COL)(10 downto 5)))) and B"011_1111" ) + 
								(unsigned((signed('0'&Window((WIN_ROW*step_x)+BLK_ROW,(WIN_COL*step_y)+BLK_COL)(4 downto 0)) - signed('0'&ReferenceBlock(WIN_ROW+BLK_ROW,WIN_COL+BLK_COL)(4 downto 0)))) and B"01_1111")
								);
							end if;
							next_state <= AddingSAD;
						end if;
					end process;
				end generate;				
			end generate;
			
			
			
        end generate;	
  end generate;
	
	   
	   -- generate some more shit  - add 
gen_win_row_2:
    for win_row in 0 to ((win_size_x - block_size_x)/step_x) generate
    begin
gen_win_col_2:
        for win_col in 0 to ((win_size_y - block_size_y)/step_y) generate
        begin
			process(current_state, clk)
			begin
				if(rising_edge(clk)) then
					if (current_state = AddingSAD) then
						SADForEachBlock(win_row,win_col) = SADForEachBlock(win_row,win_col) + SADCollection(win_row,win_col)(lastAddX,lastAddY);
						lastAddX <= lastAddX+1;
						if(lastAddX = 320) then
							lastAddX <= 0;
							lastAddY <= lastAddY +1
							
							if (lastAddY = 240) then
								next_state <= Picking;
							end if;
						end if;
					end if;
				end if;
			end process;			
		end generate;				
	end generate;
   
   
   
   
   
   
   
   
   
   
   
		  
	process (slave_rd_en, slave_addr)
   begin	       
      slave_readdata <= (others => '-');
      if (slave_rd_en = '1') then
          case slave_addr is
              when "000" => slave_readdata <= "00000000000000000000000";
              when "001" => slave_readdata <= "000000000000000000000000";
              when "010" => slave_readdata <= "00000000000000000000000";
              when "011" => slave_readdata <= "000000000000000000000000";
              when "100" => slave_readdata <= "0000000000000000";
              when "101" => slave_readdata <= "0000";
              when others => null;
            end case;
         end if;
    end process;						
				
end bhv;
