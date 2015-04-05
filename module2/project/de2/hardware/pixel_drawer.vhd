library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_drawer is
port (
    clk: in std_logic;
    reset_n: in std_logic;
				
		data_in: in std_logic_vector(34 downto 0);
		data_wait: out std_logic;
		start : in std_logic;
		
    master_addr : out std_logic_vector(31 downto 0);
    master_rd_en : out std_logic;
    master_wr_en : out std_logic;
    master_be : out std_logic_vector(1 downto 0);
    master_readdata : in std_logic_vector(15 downto 0);
    master_writedata: out  std_logic_vector(15 downto 0);
    master_waitrequest : in std_logic;
	
	pixel_buffer_base : in std_logic_vector (31 downto 0)
	);
	
end pixel_drawer;

architecture rtl of pixel_drawer is
	constant color1 : std_logic_vector (15 downto 0) := "0000011111100000";
	constant color2 : std_logic_vector (15 downto 0) := "0000000000011111";


    signal x1,x2 : std_logic_vector(8 downto 0);
    signal y1,y2 : std_logic_vector(7 downto 0);
    signal done : std_logic := '0';
	 
--	 constant pixel_buffer_base : std_logic_vector(31 downto 0) :=  x"00080000";
	 
begin

    -- This synchronous process is triggered on a rising clock edge.
    -- There are two things we might do on a rising clock edge.  We might
    -- respond to write operations on the slave bus, or we might step through
    -- the state machine to draw something to the pixel buffer.  We could
    -- have separated these into two processes.

    process(clk, reset_n)
    variable processing : bit := '0';  -- Used to indicate whether we are drawing
    variable state : integer;          -- Current state.  We could use enumerated types.

    -- The following are local copies of the coordinates and colour.  When the user
    -- starts a drawing operation, we immediately copy the coordinates here, so that
    -- if the user tries to change the coordinates while the draw operation is running,
    -- the draw operation completes with the old value of the coordinates.  This is
    -- not strictly required, but perhaps provides a more “natural” operation for
    -- whoever is writing the C code.

    variable x1_local,x2_local : std_logic_vector(8 downto 0);
    variable y1_local,y2_local : std_logic_vector(7 downto 0);
    variable colour_local : std_logic_vector(15 downto 0);	 

    -- This is used to remember the left-most x point as we draw the box.
    variable savedx : std_logic_vector(8 downto 0);
	 
    begin
       if (reset_n = '0') then
          master_wr_en<= '0';
          master_rd_en<= '0';
          processing := '0';
          state := 0;
          done <= '0';

        elsif rising_edge(clk) then

           -- on a rising clock edge, if we are currently in the middle of a
           -- drawing operation, step through the drawing state machine.
           if processing = '1' then
				data_wait <= '1';

               -- Initiate a write operation on the master bus.  The address of
               -- of the write operation points to the pixel buffer plus an offset
               -- that is computed from the x1_local and y1_local.  The final ‘0’
               -- is because each pixel takes 16 bits in memory.  The data of the
               -- write operation is the colour value (16 bits).

               if state = 0 then	
--                  master_addr <= std_logic_vector(unsigned(pixel_buffer_base) + steve +
--						                   unsigned( y1_local & x1_local & '0'));		  				   	          
                  master_addr <= std_logic_vector(unsigned(pixel_buffer_base) +
 						                   unsigned( y1_local & x1_local & '0'));	
                  master_writedata <= colour_local;
                  master_be <= "11";  -- byte enable
                  master_wr_en <= '1';
                  master_rd_en <= '0';
                  state := 1; -- on the next rising clock edge, do state 1 operations

               -- After starting a write operation, we need to wait until
               -- master_waitrequest is 0.  If it is 1, stay in state 1.

               elsif state = 1 and master_waitrequest = '0' then
			   
                  master_wr_en  <= '0';
                  state := 0;
                  if (x1_local = x2_local) then
                     if (y1_local = y2_local) then 
                        done <= '1';   -- box is done
                        processing := '0';
                     else
                        x1_local := savedx;
                        y1_local := std_logic_vector(unsigned(y1_local)+1);								 
                     end if;
                  else 
					if (y1_local = y2) or (y1_local = y1) then
                        x1_local := std_logic_vector(unsigned(x1_local)+1);
					else
						x1_local := std_logic_vector(unsigned(x2_local));
					end if;
                  end if;						
               end if;
             elsif (start = '1') then
				data_wait <= '1';
				if (unsigned(data_in(25 downto 17)) = 0) then
					x1 <= std_logic_vector(unsigned(data_in(25 downto 17)));
				else 
					x1 <= std_logic_vector(unsigned(data_in(25 downto 17))-1);
				end if;
				
				if (unsigned(data_in(8 downto 0)) = 359) then
					x2 <= std_logic_vector(unsigned(data_in(8 downto 0)));
				else 
					x2 <= std_logic_vector(unsigned(data_in(8 downto 0))+1);
				end if;
				
				if (unsigned(data_in(33 downto 26)) = 0) then
					y1 <= std_logic_vector(unsigned(data_in(33 downto 26)));
				else 
					y1 <= std_logic_vector(unsigned(data_in(33 downto 26))-1);
				end if;
				
				if (unsigned(data_in(16 downto 9)) = 239) then
					y2 <= std_logic_vector(unsigned(data_in(16 downto 9)));
				else 
					y2 <= std_logic_vector(unsigned(data_in(16 downto 9))+1);
				end if;
				
				if (data_in(34) = '0') then
					colour_local := color1;
				else
					colour_local := color2;
				end if;

				   if processing = '0' then
					  processing := '1';  -- start drawing on next rising clk edge
					  state := 0;
					  done <= '0';

					  -- The above drawing code assumes x1<x2 and y1<y2, however the
					  -- user may give us points with x1>x2 or y1>y2.  If so, swap
					  -- the x and y values.  In any case, copy to our internal _local
					  -- variables.  This ensures that if the user changes a coordinate
					  -- while a drawing is occurring, it continues to draw the box
					  -- as originally requested.

						  if (x1 < x2) then
							 x1_local := x1;
							 savedx := x1;
							 x2_local := x2;
						  else
							 x2_local := x1;
							 savedx := x2;
							 x1_local := x2;
						  end if;
								
						  if (y1 < y2) then
							 y1_local := y1;
							 y2_local := y2;
						  else
							 y2_local := y1;
							 y1_local := y2;
						  end if;									
					end if;
			else
				data_wait <= '0';
            end if;
         end if;
   end process;	  	
end rtl;
