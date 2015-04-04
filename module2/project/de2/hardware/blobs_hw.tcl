# TCL File Generated by Component Editor 13.0sp1
# Fri Apr 03 15:17:28 PDT 2015
# DO NOT MODIFY


# 
# blobs "blobs" v1.0
#  2015.04.03.15:17:28
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module blobs
# 
set_module_property DESCRIPTION ""
set_module_property NAME blobs
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME blobs
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL blobs
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file blobs.vhd VHDL PATH blobs.vhd TOP_LEVEL_FILE


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
add_parameter max_blob_count INTEGER 5
set_parameter_property max_blob_count DEFAULT_VALUE 5
set_parameter_property max_blob_count DISPLAY_NAME max_blob_count
set_parameter_property max_blob_count TYPE INTEGER
set_parameter_property max_blob_count UNITS None
set_parameter_property max_blob_count ALLOWED_RANGES -2147483648:2147483647
set_parameter_property max_blob_count HDL_PARAMETER true


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
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end draw_box export Input 1


# 
# connection point pb_master
# 
add_interface pb_master avalon start
set_interface_property pb_master addressUnits SYMBOLS
set_interface_property pb_master associatedClock clock
set_interface_property pb_master associatedReset reset
set_interface_property pb_master bitsPerSymbol 8
set_interface_property pb_master burstOnBurstBoundariesOnly false
set_interface_property pb_master burstcountUnits WORDS
set_interface_property pb_master doStreamReads false
set_interface_property pb_master doStreamWrites false
set_interface_property pb_master holdTime 0
set_interface_property pb_master linewrapBursts false
set_interface_property pb_master maximumPendingReadTransactions 0
set_interface_property pb_master readLatency 0
set_interface_property pb_master readWaitTime 1
set_interface_property pb_master setupTime 0
set_interface_property pb_master timingUnits Cycles
set_interface_property pb_master writeWaitTime 0
set_interface_property pb_master ENABLED true
set_interface_property pb_master EXPORT_OF ""
set_interface_property pb_master PORT_NAME_MAP ""
set_interface_property pb_master SVD_ADDRESS_GROUP ""

add_interface_port pb_master pb_master_rd_en read Output 1
add_interface_port pb_master pb_master_wr_en write Output 1
add_interface_port pb_master pb_master_be byteenable Output 2
add_interface_port pb_master pb_master_readdata readdata Input 16
add_interface_port pb_master pb_master_writedata writedata Output 16
add_interface_port pb_master pb_master_waitrequest waitrequest Input 1
add_interface_port pb_master pb_master_addr address Output 32


# 
# connection point outline_master
# 
add_interface outline_master avalon start
set_interface_property outline_master addressUnits SYMBOLS
set_interface_property outline_master associatedClock clock
set_interface_property outline_master associatedReset reset
set_interface_property outline_master bitsPerSymbol 8
set_interface_property outline_master burstOnBurstBoundariesOnly false
set_interface_property outline_master burstcountUnits WORDS
set_interface_property outline_master doStreamReads false
set_interface_property outline_master doStreamWrites false
set_interface_property outline_master holdTime 0
set_interface_property outline_master linewrapBursts false
set_interface_property outline_master maximumPendingReadTransactions 0
set_interface_property outline_master readLatency 0
set_interface_property outline_master readWaitTime 1
set_interface_property outline_master setupTime 0
set_interface_property outline_master timingUnits Cycles
set_interface_property outline_master writeWaitTime 0
set_interface_property outline_master ENABLED true
set_interface_property outline_master EXPORT_OF ""
set_interface_property outline_master PORT_NAME_MAP ""
set_interface_property outline_master SVD_ADDRESS_GROUP ""

add_interface_port outline_master outline_master_addr address Output 3
add_interface_port outline_master outline_master_rd_en read Output 1
add_interface_port outline_master outline_master_wr_en write Output 1
add_interface_port outline_master outline_master_readdata readdata Input 40
add_interface_port outline_master outline_master_writedata writedata Output 40
add_interface_port outline_master outline_master_waitrequest waitrequest Input 1

