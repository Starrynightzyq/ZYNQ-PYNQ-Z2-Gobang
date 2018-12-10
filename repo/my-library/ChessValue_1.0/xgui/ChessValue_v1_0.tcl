# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "live_Five"
  ipgui::add_param $IPINST -name "live_Four"
  ipgui::add_param $IPINST -name "sleep_Four"
  ipgui::add_param $IPINST -name "live_Three"
  ipgui::add_param $IPINST -name "live_Two"
  ipgui::add_param $IPINST -name "live_One"
  ipgui::add_param $IPINST -name "un_known"

}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.live_Five { PARAM_VALUE.live_Five } {
	# Procedure called to update live_Five when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.live_Five { PARAM_VALUE.live_Five } {
	# Procedure called to validate live_Five
	return true
}

proc update_PARAM_VALUE.live_Four { PARAM_VALUE.live_Four } {
	# Procedure called to update live_Four when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.live_Four { PARAM_VALUE.live_Four } {
	# Procedure called to validate live_Four
	return true
}

proc update_PARAM_VALUE.live_One { PARAM_VALUE.live_One } {
	# Procedure called to update live_One when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.live_One { PARAM_VALUE.live_One } {
	# Procedure called to validate live_One
	return true
}

proc update_PARAM_VALUE.live_Three { PARAM_VALUE.live_Three } {
	# Procedure called to update live_Three when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.live_Three { PARAM_VALUE.live_Three } {
	# Procedure called to validate live_Three
	return true
}

proc update_PARAM_VALUE.live_Two { PARAM_VALUE.live_Two } {
	# Procedure called to update live_Two when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.live_Two { PARAM_VALUE.live_Two } {
	# Procedure called to validate live_Two
	return true
}

proc update_PARAM_VALUE.sleep_Four { PARAM_VALUE.sleep_Four } {
	# Procedure called to update sleep_Four when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.sleep_Four { PARAM_VALUE.sleep_Four } {
	# Procedure called to validate sleep_Four
	return true
}

proc update_PARAM_VALUE.un_known { PARAM_VALUE.un_known } {
	# Procedure called to update un_known when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.un_known { PARAM_VALUE.un_known } {
	# Procedure called to validate un_known
	return true
}


proc update_MODELPARAM_VALUE.live_Five { MODELPARAM_VALUE.live_Five PARAM_VALUE.live_Five } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.live_Five}] ${MODELPARAM_VALUE.live_Five}
}

proc update_MODELPARAM_VALUE.live_Four { MODELPARAM_VALUE.live_Four PARAM_VALUE.live_Four } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.live_Four}] ${MODELPARAM_VALUE.live_Four}
}

proc update_MODELPARAM_VALUE.sleep_Four { MODELPARAM_VALUE.sleep_Four PARAM_VALUE.sleep_Four } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.sleep_Four}] ${MODELPARAM_VALUE.sleep_Four}
}

proc update_MODELPARAM_VALUE.live_Three { MODELPARAM_VALUE.live_Three PARAM_VALUE.live_Three } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.live_Three}] ${MODELPARAM_VALUE.live_Three}
}

proc update_MODELPARAM_VALUE.live_Two { MODELPARAM_VALUE.live_Two PARAM_VALUE.live_Two } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.live_Two}] ${MODELPARAM_VALUE.live_Two}
}

proc update_MODELPARAM_VALUE.live_One { MODELPARAM_VALUE.live_One PARAM_VALUE.live_One } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.live_One}] ${MODELPARAM_VALUE.live_One}
}

proc update_MODELPARAM_VALUE.un_known { MODELPARAM_VALUE.un_known PARAM_VALUE.un_known } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.un_known}] ${MODELPARAM_VALUE.un_known}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

