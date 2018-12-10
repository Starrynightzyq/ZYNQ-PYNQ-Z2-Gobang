# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "baud" -parent ${Page_0}
  ipgui::add_param $IPINST -name "clk_freq" -parent ${Page_0}


}

proc update_PARAM_VALUE.baud { PARAM_VALUE.baud } {
	# Procedure called to update baud when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.baud { PARAM_VALUE.baud } {
	# Procedure called to validate baud
	return true
}

proc update_PARAM_VALUE.clk_freq { PARAM_VALUE.clk_freq } {
	# Procedure called to update clk_freq when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.clk_freq { PARAM_VALUE.clk_freq } {
	# Procedure called to validate clk_freq
	return true
}


proc update_MODELPARAM_VALUE.clk_freq { MODELPARAM_VALUE.clk_freq PARAM_VALUE.clk_freq } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.clk_freq}] ${MODELPARAM_VALUE.clk_freq}
}

proc update_MODELPARAM_VALUE.baud { MODELPARAM_VALUE.baud PARAM_VALUE.baud } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.baud}] ${MODELPARAM_VALUE.baud}
}

