# TCL File Generated by Component Editor 13.0sp1
# Sat Apr 04 03:11:21 PDT 2015
# DO NOT MODIFY


# 
# blobs_master "blobs_master" v1.0
#  2015.04.04.03:11:21
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module blobs_master
# 
set_module_property DESCRIPTION ""
set_module_property NAME blobs_master
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME blobs_master
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL blobs_master
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file blobs.vhd VHDL PATH blobs.vhd
add_fileset_file outliner.vhd VHDL PATH outliner.vhd
add_fileset_file blobs_master.vhd VHDL PATH blobs_master.vhd TOP_LEVEL_FILE
add_fileset_file pixel_drawer.vhd VHDL PATH pixel_drawer.vhd


# 
# parameters
# 
add_parameter pixel_buffer_base STD_LOGIC_VECTOR 0 ""
set_parameter_property pixel_buffer_base DEFAULT_VALUE 0
set_parameter_property pixel_buffer_base DISPLAY_NAME pixel_buffer_base
set_parameter_property pixel_buffer_base WIDTH 32
set_parameter_property pixel_buffer_base TYPE STD_LOGIC_VECTOR
set_parameter_property pixel_buffer_base UNITS None
set_parameter_property pixel_buffer_base DESCRIPTION ""
set_parameter_property pixel_buffer_base HDL_PARAMETER true


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

add_interface_port avalon_master pb2_master_addr address Output 32
add_interface_port avalon_master pb2_master_rd_en read Output 1
add_interface_port avalon_master pb2_master_wr_en write Output 1
add_interface_port avalon_master pb2_master_be byteenable Output 2
add_interface_port avalon_master pb2_master_readdata readdata Input 16
add_interface_port avalon_master pb2_master_writedata writedata Output 16
add_interface_port avalon_master pb2_master_waitrequest waitrequest Input 1


# 
# connection point avalon_master_1
# 
add_interface avalon_master_1 avalon start
set_interface_property avalon_master_1 addressUnits SYMBOLS
set_interface_property avalon_master_1 associatedClock clock
set_interface_property avalon_master_1 associatedReset reset
set_interface_property avalon_master_1 bitsPerSymbol 8
set_interface_property avalon_master_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_master_1 burstcountUnits WORDS
set_interface_property avalon_master_1 doStreamReads false
set_interface_property avalon_master_1 doStreamWrites false
set_interface_property avalon_master_1 holdTime 0
set_interface_property avalon_master_1 linewrapBursts false
set_interface_property avalon_master_1 maximumPendingReadTransactions 0
set_interface_property avalon_master_1 readLatency 0
set_interface_property avalon_master_1 readWaitTime 1
set_interface_property avalon_master_1 setupTime 0
set_interface_property avalon_master_1 timingUnits Cycles
set_interface_property avalon_master_1 writeWaitTime 0
set_interface_property avalon_master_1 ENABLED true
set_interface_property avalon_master_1 EXPORT_OF ""
set_interface_property avalon_master_1 PORT_NAME_MAP ""
set_interface_property avalon_master_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_1 pb1_master_addr address Output 32
add_interface_port avalon_master_1 pb1_master_rd_en read Output 1
add_interface_port avalon_master_1 pb1_master_wr_en write Output 1
add_interface_port avalon_master_1 pb1_master_be byteenable Output 2
add_interface_port avalon_master_1 pb1_master_readdata readdata Input 16
add_interface_port avalon_master_1 pb1_master_writedata writedata Output 16
add_interface_port avalon_master_1 pb1_master_waitrequest waitrequest Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end ext_draw_box export Input 1
add_interface_port conduit_end ext_start_drawing export Output 1
add_interface_port conduit_end ext_drawing_wait export Output 1
add_interface_port conduit_end ext_StatesDebug export Output 8
add_interface_port conduit_end ext_colDebug export Output 9
add_interface_port conduit_end ext_colSelect export Input 2

