# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "HOLD_TIME" -parent ${Page_0}


}

proc update_PARAM_VALUE.HOLD_TIME { PARAM_VALUE.HOLD_TIME } {
	# Procedure called to update HOLD_TIME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HOLD_TIME { PARAM_VALUE.HOLD_TIME } {
	# Procedure called to validate HOLD_TIME
	return true
}


proc update_MODELPARAM_VALUE.HOLD_TIME { MODELPARAM_VALUE.HOLD_TIME PARAM_VALUE.HOLD_TIME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HOLD_TIME}] ${MODELPARAM_VALUE.HOLD_TIME}
}

