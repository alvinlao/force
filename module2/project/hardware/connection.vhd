-- Author	:	Jae Yeong Bae
-- Team		:	EECE 381 Group 18
-- Date		:	March 10 2015

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity connection is
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;
		
		conn_data_bus : out std_logic_vector(7 downto 0);
		conn_ack	: in std_logic;
		conn_en		: out std_logic;
		conn_keep	: out std_logic;
				
		-- master_addr : out std_logic_vector(31 downto 0);
		-- master_rd_en : out std_logic;
		-- master_wr_en : out std_logic;
		-- master_be : out std_logic_vector(1 downto 0);
		-- master_readdata : in std_logic_vector(15 downto 0);
		-- master_writedata: out  std_logic_vector(15 downto 0);
		-- master_waitrequest : in std_logic;
		
		slave_addr: in std_logic_vector(3 downto 0);
		slave_rd_en: in std_logic;
		slave_wr_en: in std_logic;
		slave_readdata: out std_logic_vector(31 downto 0);
		slave_writedata: in std_logic_vector(31 downto 0);
		slave_waitrequest : out std_logic
	);
end connection;

architecture bhv of connection is

	type StatesType				is (Standby, InitializingBuffer, Transfer, Resting, Waiting, Warming, Error);
	SIGNAL data_buffer			: std_logic_vector(31 downto 0);
	signal current_state	: StatesType := Standby;
	signal state 					: std_logic_vector(31 downto 0);
	signal  bytes_sent : integer range 0 to 3 := 0;
	
	BEGIN
	  
	process (clk, reset_n)
	variable wait_clock_count : integer range 0 to 3;
	variable trsf_clock_count : integer range 0 to 3;
	BEGIN
		if (reset_n = '0') then			
			data_buffer <= B"0000_0000_0000_0000_0000_0000_0000_0000";
			current_state <= Standby;
			conn_en <= '0';
			conn_keep <= '0';
			conn_data_bus <= B"0000_0000";
			
		elsif rising_edge(clk) then
		slave_waitrequest <= '1';
			case (current_state) is
				when Standby => 
					slave_waitrequest <= '0';
					current_state <= Standby;
					
					conn_en <= '0';
					conn_keep <= '0';
					conn_data_bus <= B"0000_0000";
					
						if (slave_wr_en = '1') then
							if (slave_addr="0000") then
								data_buffer <= slave_writedata;
								current_state <= Waiting;
								bytes_sent <= 0;
							end if;
						end if;
					
				when Transfer =>
					current_state <= Transfer;
					conn_en <= '1' ;
					case (bytes_sent) is
						when 0=>
							--send leftmost portion
							conn_data_bus <= data_buffer(31 downto 24);
							conn_keep <= '1';
						when 1=>
							--send leftmost portion
							conn_data_bus <= data_buffer(23 downto 16);
							conn_keep <= '1';
						when 2=>
							--send leftmost portion
							conn_data_bus <= data_buffer(15 downto 8);
							conn_keep <= '1';
						when others =>
							--send 4th portion
							conn_data_bus <= data_buffer(7 downto 0);
							conn_keep <= '0';
					end case;

					if (conn_ack = '1') then
						trsf_clock_count := trsf_clock_count + 1;
						if (trsf_clock_count = 3) then
							if (bytes_sent = 3) then
								data_buffer <= B"0000_0000_0000_0000_0000_0000_0000_0000";
								current_state <= Standby;
							else
								bytes_sent <= bytes_sent + 1;
								current_state <= Waiting;
							end if;
						end if;
					else
						trsf_clock_count := 0;
					end if;

					
				when Waiting=>
					current_state <= Waiting;
					--Waiting for Ack to go LOW
					conn_en <= '0';
					conn_keep <= '0';
					conn_data_bus <= B"0000_0000";
					if (conn_ack = '0') then
						wait_clock_count := wait_clock_count + 1;
						if (wait_clock_count = 3) then
							current_state <= Transfer;
						end if;
					else
						wait_clock_count := 0;
					end if;
				
				when Error=>
					current_state <= Standby;
					conn_en <= '0';
					conn_keep <= '0';
					conn_data_bus <= B"0000_0000";
					
				when others=>
					-- why are we here?
					current_state <= Standby;
					conn_en <= '0';
					conn_keep <= '0';
					conn_data_bus <= B"0000_0000";
			end case;
		end if;	
	end process;	
		
   -- process (slave_rd_en, slave_addr,data_buffer,state)
   -- BEGIN	       
		-- slave_readdata <= (others => '-');
		-- if (slave_rd_en = '1') then
			-- case slave_addr is
				
				-- when "0000" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				-- when "0001" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				-- when "0010" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				-- when "0011" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				-- when "0100" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				----debug stuff
				----20
				-- when "0101" => slave_readdata <= data_buffer;
				----24
				-- when "0110" => slave_readdata <= state;
				----28
				-- when "0111" => slave_readdata <= std_logic_vector(to_unsigned(bytes_sent,32));
				----32
				-- when "1000" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----36
				-- when "1001" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----40
				-- when "1010" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----44
				-- when "1011" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----48
				-- when "1100" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----52
				-- when "1101" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				----56
				-- when "1110" => slave_readdata <= std_logic_vector(to_unsigned(0,32));
				
				----What?
				-- when others => slave_readdata <= std_logic_vector(to_unsigned(0,32));
			-- end case;
		-- end if;
    -- end process;			
end bhv;
