library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video_system is
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
            overflow_flag_from_the_Video_In_Decoder         : out   std_logic                                         -- overflow_flag
	);
end video_system;

architecture rtl of video_system is
    component Video_System is
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
            overflow_flag_from_the_Video_In_Decoder         : out   std_logic                                         -- overflow_flag
        );
    end component Video_System;
	 
	 SIGNAL TDRESET,OVErflow_flag,SCL,SDT : STD_logic;
	 
	 begin

    u0 : component Video_System
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
            I2C_SCLK_from_the_AV_Config                     => SCL                     --                                    .SCLK
				
        );

		  TD_RESET <= '1';
	end;