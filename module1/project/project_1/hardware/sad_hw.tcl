# TCL File Generated by Component Editor 13.0sp1
# Tue Feb 10 15:15:59 PST 2015
# DO NOT MODIFY


# 
# sad "sad" v1.0
#  2015.02.10.15:15:59
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module sad
# 
set_module_property DESCRIPTION ""
set_module_property NAME sad
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME sad
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sad
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file sad.vhd VHDL PATH sad.vhd TOP_LEVEL_FILE


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
add_parameter win_size_x INTEGER 20
set_parameter_property win_size_x DEFAULT_VALUE 20
set_parameter_property win_size_x DISPLAY_NAME win_size_x
set_parameter_property win_size_x TYPE INTEGER
set_parameter_property win_size_x UNITS None
set_parameter_property win_size_x ALLOWED_RANGES -2147483648:2147483647
set_parameter_property win_size_x HDL_PARAMETER true
add_parameter win_size_y INTEGER 20
set_parameter_property win_size_y DEFAULT_VALUE 20
set_parameter_property win_size_y DISPLAY_NAME win_size_y
set_parameter_property win_size_y TYPE INTEGER
set_parameter_property win_size_y UNITS None
set_parameter_property win_size_y ALLOWED_RANGES -2147483648:2147483647
set_parameter_property win_size_y HDL_PARAMETER true
add_parameter block_size_x INTEGER 7
set_parameter_property block_size_x DEFAULT_VALUE 7
set_parameter_property block_size_x DISPLAY_NAME block_size_x
set_parameter_property block_size_x TYPE INTEGER
set_parameter_property block_size_x UNITS None
set_parameter_property block_size_x ALLOWED_RANGES -2147483648:2147483647
set_parameter_property block_size_x HDL_PARAMETER true
add_parameter block_size_y INTEGER 7
set_parameter_property block_size_y DEFAULT_VALUE 7
set_parameter_property block_size_y DISPLAY_NAME block_size_y
set_parameter_property block_size_y TYPE INTEGER
set_parameter_property block_size_y UNITS None
set_parameter_property block_size_y ALLOWED_RANGES -2147483648:2147483647
set_parameter_property block_size_y HDL_PARAMETER true
add_parameter step_x INTEGER 1
set_parameter_property step_x DEFAULT_VALUE 1
set_parameter_property step_x DISPLAY_NAME step_x
set_parameter_property step_x TYPE INTEGER
set_parameter_property step_x UNITS None
set_parameter_property step_x ALLOWED_RANGES -2147483648:2147483647
set_parameter_property step_x HDL_PARAMETER true
add_parameter step_y INTEGER 1
set_parameter_property step_y DEFAULT_VALUE 1
set_parameter_property step_y DISPLAY_NAME step_y
set_parameter_property step_y TYPE INTEGER
set_parameter_property step_y UNITS None
set_parameter_property step_y ALLOWED_RANGES -2147483648:2147483647
set_parameter_property step_y HDL_PARAMETER true


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
set_interface_property avalon_master readWaitTime 0
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


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave slave_addr address Input 4
add_interface_port avalon_slave slave_rd_en read Input 1
add_interface_port avalon_slave slave_wr_en write Input 1
add_interface_port avalon_slave slave_readdata readdata Output 32
add_interface_port avalon_slave slave_writedata writedata Input 32
add_interface_port avalon_slave slave_waitrequest waitrequest Output 1
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0

