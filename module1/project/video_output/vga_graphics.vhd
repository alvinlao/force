library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_graphics is
	port (
	--GPIO_1 : out std_LOGIC;
		LEDG : OUT STD_LOGIC_VECTOR(7 downto 0);
		KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		CLOCK_50 : IN STD_LOGIC;
		CLOCK_27 : IN STD_LOGIC;
		VGA_R: out std_logic_vector(9 downto 0);	
		VGA_G: out std_logic_vector(9 downto 0);	
		VGA_B: out std_logic_vector(9 downto 0);	
		VGA_CLK: out std_logic;
		VGA_BLANK: out std_logic;	
		VGA_HS:out std_logic;	
		VGA_VS:out std_logic;	
		VGA_SYNC:out std_logic;
		SRAM_DQ : INOUT STD_LOGIC_VECTOR(15 downto 0);
		SRAM_ADDR : OUT STD_LOGIC_VECTOR(17 downto 0);
		SRAM_LB_N : OUT STD_LOGIC;
		SRAM_UB_N : OUT STD_LOGIC;
		SRAM_CE_N : OUT STD_LOGIC;
		SRAM_OE_N : OUT STD_LOGIC;
		SRAM_WE_N : OUT STD_LOGIC;
		DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
		DRAM_ADDR : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		DRAM_BA_0, DRAM_BA_1 : BUFFER STD_LOGIC;
		DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
		DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_UDQM, DRAM_LDQM : BUFFER STD_LOGIC;
		TD_DATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		TD_HS : IN STD_LOGIC;
		TD_VS : IN STD_LOGIC
	);
end vga_graphics;
architecture structural of vga_graphics is
	component nios_system is
		port (
			clk_clk : IN STD_LOGIC;
			reset_reset_n : IN STD_LOGIC;
			sram_DQ : INOUT STD_LOGIC_VECTOR(15 downto 0);
			sram_ADDR : OUT STD_LOGIC_VECTOR(17 downto 0);
			sram_LB_N : OUT STD_LOGIC;
			sram_UB_N : OUT STD_LOGIC;
			sram_CE_N : OUT STD_LOGIC;
			sram_OE_N : OUT STD_LOGIC;
			sram_WE_N : OUT STD_LOGIC;
			sdram_clk_clk : OUT STD_LOGIC;
			sdram_wire_addr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			sdram_wire_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			sdram_wire_cas_n : OUT STD_LOGIC;
			sdram_wire_cke : OUT STD_LOGIC;
			sdram_wire_cs_n : OUT STD_LOGIC;
			sdram_wire_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => 'X');
			sdram_wire_dqm : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
			sdram_wire_ras_n : OUT STD_LOGIC;
			sdram_wire_we_n : OUT STD_LOGIC;
			vga_controller_CLK : OUT STD_LOGIC;
			vga_controller_HS : OUT STD_LOGIC;
			vga_controller_VS : OUT STD_LOGIC;
			vga_controller_BLANK : OUT STD_LOGIC;
			vga_controller_SYNC : OUT STD_LOGIC;
			vga_controller_R : OUT STD_LOGIC_VECTOR(9 downto 0);
			vga_controller_G : OUT STD_LOGIC_VECTOR(9 downto 0);
			vga_controller_B : OUT STD_LOGIC_VECTOR(9 downto 0);
			v_in_position_x_export : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			v_in_position_y_export : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			v_in_rgb_export : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			v_in_pixel_enabled_export : IN STD_LOGIC
		);
	end component;
	component video_in is
		port (
			CLOCK_50 : IN STD_LOGIC;
			CLOCK_27 : IN STD_LOGIC;
			reset : IN STD_LOGIC;

			TD_DATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			TD_HS : IN STD_LOGIC;
			TD_VS : IN STD_LOGIC;

			waitrequest : IN STD_LOGIC;

			--Outputs
			TD_RESET : OUT STD_LOGIC;

			x : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			red : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			green : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			blue : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			pixel_en : OUT STD_LOGIC
		);
	end component;
	
	signal position_x : STD_LOGIC_VECTOR(8 DOWNTO 0);
	signal position_y : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal red : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal green : STD_LOGIC_VECTOR(5 DOWNTO 0);
	signal blue : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal en : STD_LOGIC;
	signal position : STD_LOGIC_VECTOR(16 DOWNTO 0);
	signal rgb : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal waitrequest : STD_LOGIC;
	signal TD_RESET : STD_LOGIC;
	signal DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal BA : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
begin
	DRAM_BA_0 <= BA(0);
	DRAM_BA_1 <= BA(1);
	DRAM_UDQM <= DQM(1);
	DRAM_LDQM <= DQM(0);
	
NiosII: nios_system
	port map (
		clk_clk => CLOCK_50,
		reset_reset_n => KEY(0),
		vga_controller_CLK => VGA_CLK,
		vga_controller_HS => VGA_HS,
		vga_controller_VS => VGA_VS,
		vga_controller_BLANK => VGA_BLANK,
		vga_controller_SYNC => VGA_SYNC,
		vga_controller_R => VGA_R,
		vga_controller_G => VGA_G,
		vga_controller_B => VGA_B,
		sram_DQ => SRAM_DQ,
		sram_ADDR => SRAM_ADDR,
		sram_LB_N => SRAM_LB_N,
		sram_UB_N => SRAM_UB_N,
		sram_CE_N => SRAM_CE_N,
		sram_OE_N => SRAM_OE_N,
		sram_WE_N => SRAM_WE_N,
		sdram_clk_clk => DRAM_CLK,
		sdram_wire_addr => DRAM_ADDR,
		sdram_wire_ba => BA,
		sdram_wire_cas_n => DRAM_CAS_N,
		sdram_wire_cke => DRAM_CKE,
		sdram_wire_cs_n => DRAM_CS_N,
		sdram_wire_dq => DRAM_DQ,
		sdram_wire_dqm => DQM,
		sdram_wire_ras_n => DRAM_RAS_N,
		sdram_wire_we_n => DRAM_WE_N,
		v_in_position_x_export => position_x,
		v_in_position_y_export => position_y,
		v_in_rgb_export => rgb,
		v_in_pixel_enabled_export => en
	);
--	DRAM_CLK <= CLOCK_50;

VI : video_in	
	port map (
		CLOCK_50 => CLOCK_50,
		CLOCK_27 => CLOCK_27,
		reset => not KEY(0),

		TD_DATA => TD_DATA,
		TD_HS => TD_HS,
		TD_VS => TD_VS,

		waitrequest => waitrequest,

		--Outputs
		TD_RESET => TD_RESET,

		x => position_x,
		y => position_y,
		red => red,
		green => green,
		blue => blue,
		pixel_en => en
	);
	
	rgb <= red & green & blue;
	waitrequest <= '0';
	LEDG <= en & "0001111";
	--GPIO_1 <= en;
end structural;