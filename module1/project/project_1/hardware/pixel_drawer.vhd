library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_drawer is
generic(
    pixel_buffer_base : std_logic_vector := x"00080000"
	 );
port (
    clk: in std_logic;
    reset_n: in std_logic;
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
    master_waitrequest : in std_logic);
end pixel_drawer;

architecture rtl of pixel_drawer is
    signal x1,x2 : std_logic_vector(8 downto 0);
    signal y1,y2 : std_logic_vector(7 downto 0);
    signal colour : std_logic_vector(15 downto 0);	 
    signal done : std_logic := '0';
	 signal hold_position : std_logic := '0';
	 
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
    -- not strictly required, but perhaps provides a more Ã¢â‚¬Å“naturalÃ¢â‚¬Â operation for
    -- whoever is writing the C code.

    variable x1_local,x2_local : std_logic_vector(8 downto 0);
    variable y1_local,y2_local : std_logic_vector(7 downto 0);
    variable colour_local : std_logic_vector(15 downto 0);
	 
	 variable counter : integer := 0; -- Counter used for a quick wait
	 
	  -- The original values of the line
	variable x1_original,x2_original : std_logic_vector(8 downto 0);
	variable y1_original,y2_original : std_logic_vector(7 downto 0);
	variable error_original : signed(18 downto 0);
	 
	 variable sx, sy : integer;
	 variable dx : signed(10 downto 0);
	 variable dy : signed(9 downto 0);
	 variable error : signed(18 downto 0);
	 variable e2 : signed(37 downto 0);
	  
    begin
       if (reset_n = '0') then
          master_wr_en<= '0';
          master_rd_en<= '0';
          processing := '0';
          state := 0;
          done <= '0';
			 hold_position <= '0';

        elsif rising_edge(clk) then

           -- on a rising clock edge, if we are currently in the middle of a
           -- drawing operation, step through the drawing state machine.

           if processing = '1' then
               -- Initiate a write operation on the master bus.  The address of
               -- of the write operation points to the pixel buffer plus an offset
               -- that is computed from the x1_local and y1_local.  The final Ã¢â‚¬Ëœ0Ã¢â‚¬â„¢
               -- is because each pixel takes 16 bits in memory.  The data of the
               -- write operation is the colour value (16 bits).

               if state = 0 then
                  master_addr <= std_logic_vector(unsigned(pixel_buffer_base) +
 						                   unsigned( y1_local & x1_local & '0'));	
                  master_writedata <= colour_local;
                  master_be <= "11";  -- byte enable
                  master_wr_en <= '1';
                  master_rd_en <= '0';
                  state := 1; -- on the next rising clock edge, do state 1 operations
						done <= '0';

               -- After starting a write operation, we need to wait until
               -- master_waitrequest is 0.  If it is 1, stay in state 1.

               elsif state = 1 and master_waitrequest = '0' then
                  master_wr_en  <= '0';
                  state := 0;
						e2 := error * 2;
						
						if (x1_local = x2_local) and (y1_local = y2_local) then
							-- Done
							done <= '1';
                     processing := '0';
							if (hold_position = '1') then
								state := 2;
								processing := '1';
								x1_local := x1_original;
								x2_local := x2_original;
								y1_local := y1_original;
								y2_local := y2_original;
								error := error_original;
							end if;
						else 
							-- Keep going
							if (e2 >= dy) then
								error := error + dy;
								x1_local := std_logic_vector(unsigned(x1_local)+sx);
							end if;
							
							if (e2 <= dx) then
								error := error + dx;
								y1_local := std_logic_vector(unsigned(y1_local)+sy);								 
							end if;
						end if;
					elsif state = 2 then
						if (counter = 1000) then
							state := 0;
							counter := 0;
						end if;
						counter := counter + 1;
               end if;
             end if;					

             -- We should also check if there is a write on the slave bus.  If so, copy the
             -- written value into one of our internal registers.
	
             if (slave_wr_en = '1') then
                case slave_addr is

                    -- These four should be self-explantory
                    when "000" => x1 <= slave_writedata(8 downto 0);
                    when "001" => y1 <= slave_writedata(7 downto 0);
                    when "010" => x2 <= slave_writedata(8 downto 0);
                    when "011" => y2 <= slave_writedata(7 downto 0);
                    when "100" => colour <= slave_writedata(15 downto 0);

                    -- If the user tries to write to offset 5, we are to start drawing
                    when "101" =>
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

								  x1_local := x1;
								  x2_local := x2;
								  y1_local := y1;
								  y2_local := y2;
								  
                          if (x1 < x2) then
                             sx := 1;
                          else
									  sx := -1;
                          end if;
								
                          if (y1 < y2) then
                             sy := 1;
                          else
                             sy := -1;
                          end if;									

								  dx := abs(signed("00" & x2_local) - signed("00" & x1_local));
								  -- Negative
								  dy := -abs(signed("00" & y2_local) - signed("00" & y1_local));
								  error := resize(dx + dy, error'length);
								  
                          colour_local := colour;
								  
								  x1_original := x1_local;
								  x2_original := x2_local;
								  y1_original := y1_local;
								  y2_original := y2_local;
								  error_original := error;
                        end if;
						 when "110" => hold_position <= slave_writedata(0);
                   when others => null;
                end case;
            end if;
         end if;
   end process;	  
		  
	
   -- This process is used to describe what to do when a Ã¢â‚¬Å“readÃ¢â‚¬Â operation occurs on the
   -- slave interface (this is because the C program does a memory read).  Depending
   -- on the address read, we return x1, x2, y1, y2, the colour, or the done flag.

   process (slave_rd_en, slave_addr, x1, x2, y1, y2, colour, done, hold_position)
   begin	       
      slave_readdata <= (others => '-');
      if (slave_rd_en = '1') then
          case slave_addr is
              when "000" => slave_readdata <= "00000000000000000000000" & x1;
              when "001" => slave_readdata <= "000000000000000000000000" & y1;
              when "010" => slave_readdata <= "00000000000000000000000" & x2;
              when "011" => slave_readdata <= "000000000000000000000000" & y2;
              when "100" => slave_readdata <= "0000000000000000" & colour;
              when "101" => slave_readdata <= (0=>done, others=>'0');
				  when "110" => slave_readdata <= (0=>hold_position, others=>'0');
              when others => null;
            end case;
         end if;
    end process;						
				
end rtl;
