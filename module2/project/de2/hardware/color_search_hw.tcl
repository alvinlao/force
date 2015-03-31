# TCL File Generated by Component Editor 13.0sp1
# Tue Mar 31 15:44:38 PDT 2015
# DO NOT MODIFY


# 
# color_search "color_search" v1.0
#  2015.03.31.15:44:38
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module color_search
# 
set_module_property DESCRIPTION ""
set_module_property NAME color_search
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME color_search
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL color_tracker
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file color_tracker.vhd VHDL PATH color_tracker.vhd TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter pixel_buffer_base STD_LOGIC_VECTOR 0
set_parameter_property pixel_buffer_base DEFAULT_VALUE 0
set_parameter_property pixel_buffer_base DISPLAY_NAME pixel_buffer_base
set_parameter_property pixel_buffer_base TYPE STD_LOGIC_VECTOR
set_parameter_property pixel_buffer_base UNITS None
set_parameter_property pixel_buffer_base ALLOWED_RANGES 0:4294967295
set_parameter_property pixel_buffer_base HDL_PARAMETER true
add_parameter back_buffer_base STD_LOGIC_VECTOR 0
set_parameter_property back_buffer_base DEFAULT_VALUE 0
set_parameter_property back_buffer_base DISPLAY_NAME back_buffer_base
set_parameter_property back_buffer_base TYPE STD_LOGIC_VECTOR
set_parameter_property back_buffer_base UNITS None
set_parameter_property back_buffer_base ALLOWED_RANGES 0:4294967295
set_parameter_property back_buffer_base HDL_PARAMETER true
add_parameter find_color INTEGER 0 ""
set_parameter_property find_color DEFAULT_VALUE 0
set_parameter_property find_color DISPLAY_NAME find_color
set_parameter_property find_color WIDTH ""
set_parameter_property find_color TYPE INTEGER
set_parameter_property find_color UNITS None
set_parameter_property find_color ALLOWED_RANGES -2147483648:2147483647
set_parameter_property find_color DESCRIPTION ""
set_parameter_property find_color HDL_PARAMETER true
add_parameter thresold INTEGER 15
set_parameter_property thresold DEFAULT_VALUE 15
set_parameter_property thresold DISPLAY_NAME thresold
set_parameter_property thresold TYPE INTEGER
set_parameter_property thresold UNITS None
set_parameter_property thresold ALLOWED_RANGES -2147483648:2147483647
set_parameter_property thresold HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master master_addr address Output 32
add_interface_port avalon_master master_rd_en read Output 1
add_interface_port avalon_master master_wr_en write Output 1
add_interface_port avalon_master master_be byteenable Output 2
add_interface_port avalon_master master_readdata readdata Input 16
add_interface_port avalon_master master_writedata writedata Output 16
add_interface_port avalon_master master_waitrequest waitrequest Input 1

