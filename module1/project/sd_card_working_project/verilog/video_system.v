module video_system (
	// Inputs
	CLOCK_50,
	CLOCK_27,
	TD_CLK27,
	KEY,

	//  Video In
	TD_DATA,
	TD_HS,
	TD_VS,

	// Bidirectionals
	//  Memory (SRAM)
	SRAM_DQ,
	
	//  AV Config
	I2C_SDAT,

	// Outputs
	// 	Memory (SRAM)
	VGA_VS,
	VGA_BLANK,
	VGA_SYNC,
	VGA_R,
	VGA_G,
	VGA_B,

	//  Video In
	TD_RESET
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input				TD_CLK27;
input		[3:0]	KEY;

//  Video In
input		[ 7: 0]	TD_DATA;
input				TD_HS;
input				TD_VS;

// Bidirectionals
// 	Memory (SRAM)
inout		[15:0]	SRAM_DQ;

//  AV_Config
inout				I2C_SDAT;

// Outputs
// 	Memory (SRAM)
output		[17:0]	SRAM_ADDR;

output				SRAM_CE_N;
output				SRAM_WE_N;
output				SRAM_OE_N;
output				SRAM_UB_N;
output				SRAM_LB_N;

//  AV_Config
output				I2C_SCLK;

//  VGA
output				VGA_CLK;
output				VGA_HS;
output				VGA_VS;
output				VGA_BLANK;
output				VGA_SYNC;
output		[ 9: 0]	VGA_R;
output		[ 9: 0]	VGA_G;
output		[ 9: 0]	VGA_B;

//  Video In
output				TD_RESET;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign TD_RESET		= 1'b1;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Video_System Char_Buffer_System (
	// 1) global signals:
	.clk_0									(CLOCK_50),
	.reset_n								(KEY[0]),

	// the_Pixel_Buffer
	.SRAM_DQ_to_and_from_the_Pixel_Buffer	(SRAM_DQ),
	.SRAM_ADDR_from_the_Pixel_Buffer		(SRAM_ADDR),
	.SRAM_LB_N_from_the_Pixel_Buffer		(SRAM_LB_N),
	.SRAM_UB_N_from_the_Pixel_Buffer		(SRAM_UB_N),
	.SRAM_CE_N_from_the_Pixel_Buffer		(SRAM_CE_N),
	.SRAM_OE_N_from_the_Pixel_Buffer		(SRAM_OE_N),
	.SRAM_WE_N_from_the_Pixel_Buffer		(SRAM_WE_N),

	// the_Video_In_Decoder
	.TD_CLK27_to_the_Video_In_Decoder		(CLOCK_27),
//	.TD_CLK27_to_the_Video_In_Decoder		(TD_CLK27),
	.TD_DATA_to_the_Video_In_Decoder		(TD_DATA),
	.TD_HS_to_the_Video_In_Decoder			(TD_HS),
	.TD_RESET_from_the_Video_In_Decoder		(),
	.TD_VS_to_the_Video_In_Decoder			(TD_VS),

	// the_AV_Config
	.I2C_SCLK_from_the_AV_Config			(I2C_SCLK),
	.I2C_SDAT_to_and_from_the_AV_Config		(I2C_SDAT),

	// the_vga_controller
	.VGA_CLK_from_the_VGA_Controller		(VGA_CLK),
	.VGA_HS_from_the_VGA_Controller			(VGA_HS),
	.VGA_VS_from_the_VGA_Controller			(VGA_VS),
	.VGA_BLANK_from_the_VGA_Controller		(VGA_BLANK),
	.VGA_SYNC_from_the_VGA_Controller		(VGA_SYNC),
	.VGA_R_from_the_VGA_Controller			(VGA_R),
	.VGA_G_from_the_VGA_Controller			(VGA_G),
	.VGA_B_from_the_VGA_Controller			(VGA_B)
);

endmodule

