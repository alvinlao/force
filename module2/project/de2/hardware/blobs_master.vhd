library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blobs_master is
generic(
    pixel_buffer_base : std_logic_vector := x"00000000"
	 );
port (
    clk: in std_logic;
    reset_n: in std_logic;
	
	ext_draw_box : in std_logic;
	ext_start_drawing: out std_logic;
	ext_drawing_wait: out std_logic;
	ext_StatesDebug : out std_logic_vector (7 downto 0);
	ext_colDebug	: out std_logic_vector( 8 downto 0);
	ext_colSelect	: in std_logic_vector( 1 downto 0);
	
    pb1_master_addr : out std_logic_vector(31 downto 0);
    pb1_master_rd_en : out std_logic;
    pb1_master_wr_en : out std_logic;
    pb1_master_be : out std_logic_vector(1 downto 0);
    pb1_master_readdata : in std_logic_vector(15 downto 0);
    pb1_master_writedata: out  std_logic_vector(15 downto 0);
    pb1_master_waitrequest : in std_logic;
	
    pb2_master_addr : out std_logic_vector(31 downto 0);
    pb2_master_rd_en : out std_logic;
    pb2_master_wr_en : out std_logic;
    pb2_master_be : out std_logic_vector(1 downto 0);
    pb2_master_readdata : in std_logic_vector(15 downto 0);
    pb2_master_writedata: out  std_logic_vector(15 downto 0);
    pb2_master_waitrequest : in std_logic
	);
end blobs_master;

architecture rtl of blobs_master is

	component blobs
		port (
			clk		: in std_logic;
			reset_n	: in std_logic;
			
			draw_box : in std_logic;
			StatesDebug : out std_logic_vector(7 downto 0);
			ColDebug : out std_logic_vector (8 downto 0);
			ColSelect : in std_logic_vector (1 downto 0);
			
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
	end component blobs;

	component pixel_drawer
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
	end component pixel_drawer;
	 
	 
	 
	 
	 
	 SIGNAL outline_start : std_logic;
	 SIGNAL outline_data : std_logic_vector(34 downto 0);
	 SIGNAL outline_wait : std_logic;
	 
	 begin
u0 : component blobs
        port map (
			clk						=> clk,
			reset_n					=> reset_n,
			
			draw_box 				=> ext_draw_box,
			StatesDebug				=> ext_StatesDebug,
			ColDebug				=>	ext_colDebug,
			ColSelect				=>	ext_colSelect,
			
			outline_start 			=> outline_start,
			outline_data 			=> outline_data,
			outline_wait 			=> outline_wait,
							
			pb_master_addr 			=>	pb1_master_addr,
			pb_master_rd_en 		=>	pb1_master_rd_en,
			pb_master_wr_en 		=>	pb1_master_wr_en,
			pb_master_be 			=>	pb1_master_be,
			pb_master_readdata 		=>	pb1_master_readdata,
			pb_master_writedata		=>	pb1_master_writedata,
			pb_master_waitrequest	=>	pb1_master_waitrequest,
			
			pixel_buffer_base		=> pixel_buffer_base
        );
		
u1 : component pixel_drawer
        port map (
			clk						=> clk,
			reset_n					=> reset_n,
			
			master_addr 			=> pb2_master_addr,
			master_rd_en 			=> pb2_master_rd_en,
			master_wr_en			=> pb2_master_wr_en,
			master_be				=> pb2_master_be,
			master_readdata			=> pb2_master_readdata,
			master_writedata		=> pb2_master_writedata,
			master_waitrequest		=> pb2_master_waitrequest,
				
			data_in					=> outline_data,
			data_wait				=> outline_wait,
			start 					=> outline_start,
			
			pixel_buffer_base		=> pixel_buffer_base
        );
		
		ext_drawing_wait <= outline_wait;
		ext_start_drawing <= outline_start;
end;
