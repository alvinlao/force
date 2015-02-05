library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_1 is
	port(
            VGA_CLK                 : out   std_logic;                                        -- CLK
            VGA_HS                  : out   std_logic;                                        -- HS
            VGA_VS                  : out   std_logic;                                        -- VS
            VGA_BLANK               : out   std_logic;                                        -- BLANK
            VGA_SYNC                : out   std_logic;                                        -- SYNC
            VGA_R                   : out   std_logic_vector(9 downto 0);                     -- R
            VGA_G                   : out   std_logic_vector(9 downto 0);                     -- G
            VGA_B                   : out   std_logic_vector(9 downto 0);                     -- B
            CLOCK_50                                           : in    std_logic                     := 'X';             -- clk
            KEY : IN STD_logic_vector(3 DOWNTO 0);
            I2C_SDAT              : inout std_logic                     := 'X';             -- SDAT
            I2C_SCLK                    : out   std_logic;                                        -- SCLK
            SRAM_DQ		           : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
            SRAM_ADDR                : out   std_logic_vector(17 downto 0);                    -- ADDR
            SRAM_LB_N                : out   std_logic;                                        -- LB_N
            SRAM_UB_N                : out   std_logic;                                        -- UB_N
            SRAM_CE_N                : out   std_logic;                                        -- CE_N
            SRAM_OE_N                : out   std_logic;                                        -- OE_N
            SRAM_WE_N                : out   std_logic;                                        -- WE_N
            TD_CLK27                : in    std_logic                     := 'X';             -- TD_CLK27
            TD_DATA                 : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- TD_DATA
            TD_HS                   : in    std_logic                     := 'X';             -- TD_HS
            TD_VS                   : in    std_logic                     := 'X';             -- TD_VS
				
            TD_RESET              : out   std_logic;                                        -- TD_RESET
				Video_In_Decoder_external_interface_clk27_reset : in    std_logic                     := 'X';             -- clk27_reset
            overflow_flag_from_the_Video_In_Decoder         : out   std_logic;                                         -- overflow_flag

-- sdram
				DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
				DRAM_ADDR : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
				DRAM_BA_0, DRAM_BA_1 : BUFFER STD_LOGIC;
				DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
				DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				DRAM_UDQM, DRAM_LDQM : BUFFER STD_LOGIC;
-- sdCard
				b_SD_DAT : INOUT STD_LOGIC;
				b_SD_CMD : INOUT STD_LOGIC;
				b_SD_DAT3 : INOUT STD_LOGIC;
				o_SD_CLOCK : OUT STD_LOGIC
	);
end project_1;

architecture rtl of project_1 is
	signal DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal BA : STD_LOGIC_VECTOR(1 DOWNTO 0);

    component project_1_qsys
        port (
            VGA_CLK_from_the_VGA_Controller                 : out   std_logic;                                        -- CLK
            VGA_HS_from_the_VGA_Controller                  : out   std_logic;                                        -- HS
            VGA_VS_from_the_VGA_Controller                  : out   std_logic;                                        -- VS
            VGA_BLANK_from_the_VGA_Controller               : out   std_logic;                                        -- BLANK
            VGA_SYNC_from_the_VGA_Controller                : out   std_logic;                                        -- SYNC
            VGA_R_from_the_VGA_Controller                   : out   std_logic_vector(9 downto 0);                     -- R
            VGA_G_from_the_VGA_Controller                   : out   std_logic_vector(9 downto 0);                     -- G
            VGA_B_from_the_VGA_Controller                   : out   std_logic_vector(9 downto 0);                     -- B
            clk_0                                           : in    std_logic                     := 'X';             -- clk
            reset_n                                         : in    std_logic                     := 'X';             -- reset_n
            I2C_SDAT_to_and_from_the_AV_Config              : inout std_logic                     := 'X';             -- SDAT
            I2C_SCLK_from_the_AV_Config                     : out   std_logic;                                        -- SCLK
            SRAM_DQ_to_and_from_the_Pixel_Buffer            : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
            SRAM_ADDR_from_the_Pixel_Buffer                 : out   std_logic_vector(17 downto 0);                    -- ADDR
            SRAM_LB_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- LB_N
            SRAM_UB_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- UB_N
            SRAM_CE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- CE_N
            SRAM_OE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- OE_N
            SRAM_WE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- WE_N
            TD_CLK27_to_the_Video_In_Decoder                : in    std_logic                     := 'X';             -- TD_CLK27
            TD_DATA_to_the_Video_In_Decoder                 : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- TD_DATA
            TD_HS_to_the_Video_In_Decoder                   : in    std_logic                     := 'X';             -- TD_HS
            TD_VS_to_the_Video_In_Decoder                   : in    std_logic                     := 'X';             -- TD_VS
            Video_In_Decoder_external_interface_clk27_reset : in    std_logic                     := 'X';             -- clk27_reset
            TD_RESET_from_the_Video_In_Decoder              : out   std_logic;                                        -- TD_RESET
            overflow_flag_from_the_Video_In_Decoder         : out   std_logic;                                         -- overflow_flag
				sdram_controller_wire_addr                      : out   std_logic_vector(11 downto 0);                    -- addr
            sdram_controller_wire_ba                        : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_controller_wire_cas_n                     : out   std_logic;                                        -- cas_n
            sdram_controller_wire_cke                       : out   std_logic;                                        -- cke
            sdram_controller_wire_cs_n                      : out   std_logic;                                        -- cs_n
            sdram_controller_wire_dq                        : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_controller_wire_dqm                       : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_controller_wire_ras_n                     : out   std_logic;                                        -- ras_n
            sdram_controller_wire_we_n                      : out   std_logic;                                         -- we_n
				sdram_clk_clk												: OUT STD_LOGIC;
				sd_card_b_SD_cmd   : inout std_logic ; -- b_SD_cmd
            sd_card_b_SD_dat   : inout std_logic ; -- b_SD_dat
            sd_card_b_SD_dat3  : inout std_logic ; -- b_SD_dat3
            sd_card_o_SD_clock : out   std_logic         -- o_SD_clock
        );
    end component project_1_qsys;
	 
	 SIGNAL TDRESET,overflow_flag,SCL,SDT : STD_logic;
	 
	 begin

	 DRAM_BA_0 <= BA(0);
	 DRAM_BA_1 <= BA(1);
	 DRAM_UDQM <= DQM(1);
	 DRAM_LDQM <= DQM(0);
	 
    u0 : component project_1_qsys
        port map (
            VGA_CLK_from_the_VGA_Controller                 => 	VGA_CLK,                 --   VGA_Controller_external_interface.CLK
            VGA_HS_from_the_VGA_Controller                  => VGA_HS,                  --                                    .HS
            VGA_VS_from_the_VGA_Controller                  => VGA_VS,                  --                                    .VS
            VGA_BLANK_from_the_VGA_Controller               => VGA_BLANK,               --                                    .BLANK
            VGA_SYNC_from_the_VGA_Controller                => VGA_SYNC,                --                                    .SYNC
            VGA_R_from_the_VGA_Controller                   => VGA_R,                   --                                    .R
            VGA_G_from_the_VGA_Controller                   => VGA_G,                   --                                    .G
            VGA_B_from_the_VGA_Controller                   => VGA_B,                   --                                    .B
            clk_0                                           => CLOCK_50,                                           --                        clk_0_clk_in.clk
            reset_n                                         => KEY(0),                                         --                  clk_0_clk_in_reset.reset_n
            SRAM_DQ_to_and_from_the_Pixel_Buffer            => SRAM_DQ,            --     Pixel_Buffer_external_interface.DQ
            SRAM_ADDR_from_the_Pixel_Buffer                 => SRAM_ADDR,                 --                                    .ADDR
            SRAM_LB_N_from_the_Pixel_Buffer                 => SRAM_LB_N,                 --                                    .LB_N
            SRAM_UB_N_from_the_Pixel_Buffer                 => SRAM_UB_N,                 --                                    .UB_N
            SRAM_CE_N_from_the_Pixel_Buffer                 => SRAM_CE_N,                 --                                    .CE_N
            SRAM_OE_N_from_the_Pixel_Buffer                 => SRAM_OE_N,                 --                                    .OE_N
            SRAM_WE_N_from_the_Pixel_Buffer                 => SRAM_WE_N,                 --                                    .WE_N
            TD_CLK27_to_the_Video_In_Decoder                => TD_CLK27,                -- Video_In_Decoder_external_interface.TD_CLK27
            TD_DATA_to_the_Video_In_Decoder                 => TD_DATA,                 --                                    .TD_DATA
            TD_HS_to_the_Video_In_Decoder                   => TD_HS,                   --                                    .TD_HS
            TD_VS_to_the_Video_In_Decoder                   => TD_VS,                   --                                    .TD_VS

            Video_In_Decoder_external_interface_clk27_reset => '0', --                                    .clk27_reset
				TD_RESET_from_the_Video_In_Decoder              => TDRESET,              --                                    .TD_RESET
            overflow_flag_from_the_Video_In_Decoder         => OVErflow_flag,          --                                    .overflow_flag
				I2C_SDAT_to_and_from_the_AV_Config              => SDT,              --        AV_Config_external_interface.SDAT
            I2C_SCLK_from_the_AV_Config                     => SCL,                     --                                    .SCLK
				sdram_controller_wire_addr                      => DRAM_ADDR,                      --               sdram_controller_wire.addr
            sdram_controller_wire_ba                        => BA,                        --                                    .ba
            sdram_controller_wire_cas_n                     => DRAM_CAS_N,                     --                                    .cas_n
            sdram_controller_wire_cke                       => DRAM_CKE,                       --                                    .cke
            sdram_controller_wire_cs_n                      => DRAM_CS_N,                      --                                    .cs_n
            sdram_controller_wire_dq                        => DRAM_DQ,                        --                                    .dq
            sdram_controller_wire_dqm                       => DQM,                       --                                    .dqm
            sdram_controller_wire_ras_n                     => DRAM_RAS_N,                     --                                    .ras_n
            sdram_controller_wire_we_n                      => DRAM_WE_N,                       --                                    .we_n
				sdram_clk_clk												=> DRAM_CLK,
				sd_card_b_SD_cmd   => b_SD_CMD,   -- sd_card.b_SD_cmd
            sd_card_b_SD_dat   => b_SD_dat,   --        .b_SD_dat
            sd_card_b_SD_dat3  => b_SD_dat3,  --        .b_SD_dat3
            sd_card_o_SD_clock => o_SD_clock  --        .o_SD_clock
        );

		  TD_RESET <= '1';
	end;