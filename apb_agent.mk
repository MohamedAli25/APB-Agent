APB_AGENT_DEFINED 	= 1

APB_ROOT_PATH				?= .																# root of the files to be compiled
APB_INCLUDE_DIR  		:= $(strip $(APB_ROOT_PATH))/../..	# include directory for the `include 
APB_FILES_PACKAGE		:=  																# package files to be compiled
APB_FILES_INTERFACE	:=  																# interface files to be compiled
COMPILE 						= $(strip $(APB_ROOT_PATH))/$(1) 		# used to append the root_path to the file_name

################################## Files to be compiled ##########################################
APB_FILES_PACKAGE						+= $(call COMPILE,apb_agent_pkg.sv)
APB_FILES_INTERFACE					+= $(call COMPILE,apb_if.sv)
APB_FILES_INTERFACE					+= $(call COMPILE,apb_driver_bfm.sv)
APB_FILES_INTERFACE					+= $(call COMPILE,apb_monitor_bfm.sv)
#################################################################################################

APB_BUILD_AGENT: APB_BUILD_PACKAGE APB_BUILD_INTERFACES

APB_BUILD_PACKAGE: 
	@vlog +incdir+${UVM_HOME} +incdir+${APB_INCLUDE_DIR} ${APB_FILES_PACKAGE}  -suppress 2275 
	@echo APB Package BUILD Done
	@echo ------------------------------------------------------------------------------------------

APB_BUILD_INTERFACES:
	@vlog +incdir+${UVM_HOME} +incdir+${APB_INCLUDE_DIR} ${APB_FILES_INTERFACE}  -suppress 2275 
	@echo APB Interfaces BUILD Done
	@echo ------------------------------------------------------------------------------------------
