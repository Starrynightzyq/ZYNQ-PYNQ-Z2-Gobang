# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLICK_LONG" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_EDGE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_MULT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_START" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_EDGE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_MULT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_START" -parent ${Page_0}


}

proc update_PARAM_VALUE.CLICK_LONG { PARAM_VALUE.CLICK_LONG } {
	# Procedure called to update CLICK_LONG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLICK_LONG { PARAM_VALUE.CLICK_LONG } {
	# Procedure called to validate CLICK_LONG
	return true
}

proc update_PARAM_VALUE.X_EDGE { PARAM_VALUE.X_EDGE } {
	# Procedure called to update X_EDGE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_EDGE { PARAM_VALUE.X_EDGE } {
	# Procedure called to validate X_EDGE
	return true
}

proc update_PARAM_VALUE.X_MAX { PARAM_VALUE.X_MAX } {
	# Procedure called to update X_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_MAX { PARAM_VALUE.X_MAX } {
	# Procedure called to validate X_MAX
	return true
}

proc update_PARAM_VALUE.X_MULT { PARAM_VALUE.X_MULT } {
	# Procedure called to update X_MULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_MULT { PARAM_VALUE.X_MULT } {
	# Procedure called to validate X_MULT
	return true
}

proc update_PARAM_VALUE.X_START { PARAM_VALUE.X_START } {
	# Procedure called to update X_START when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_START { PARAM_VALUE.X_START } {
	# Procedure called to validate X_START
	return true
}

proc update_PARAM_VALUE.Y_EDGE { PARAM_VALUE.Y_EDGE } {
	# Procedure called to update Y_EDGE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_EDGE { PARAM_VALUE.Y_EDGE } {
	# Procedure called to validate Y_EDGE
	return true
}

proc update_PARAM_VALUE.Y_MAX { PARAM_VALUE.Y_MAX } {
	# Procedure called to update Y_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_MAX { PARAM_VALUE.Y_MAX } {
	# Procedure called to validate Y_MAX
	return true
}

proc update_PARAM_VALUE.Y_MULT { PARAM_VALUE.Y_MULT } {
	# Procedure called to update Y_MULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_MULT { PARAM_VALUE.Y_MULT } {
	# Procedure called to validate Y_MULT
	return true
}

proc update_PARAM_VALUE.Y_START { PARAM_VALUE.Y_START } {
	# Procedure called to update Y_START when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_START { PARAM_VALUE.Y_START } {
	# Procedure called to validate Y_START
	return true
}


proc update_MODELPARAM_VALUE.X_START { MODELPARAM_VALUE.X_START PARAM_VALUE.X_START } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_START}] ${MODELPARAM_VALUE.X_START}
}

proc update_MODELPARAM_VALUE.Y_START { MODELPARAM_VALUE.Y_START PARAM_VALUE.Y_START } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_START}] ${MODELPARAM_VALUE.Y_START}
}

proc update_MODELPARAM_VALUE.X_MAX { MODELPARAM_VALUE.X_MAX PARAM_VALUE.X_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_MAX}] ${MODELPARAM_VALUE.X_MAX}
}

proc update_MODELPARAM_VALUE.Y_MAX { MODELPARAM_VALUE.Y_MAX PARAM_VALUE.Y_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_MAX}] ${MODELPARAM_VALUE.Y_MAX}
}

proc update_MODELPARAM_VALUE.X_EDGE { MODELPARAM_VALUE.X_EDGE PARAM_VALUE.X_EDGE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_EDGE}] ${MODELPARAM_VALUE.X_EDGE}
}

proc update_MODELPARAM_VALUE.Y_EDGE { MODELPARAM_VALUE.Y_EDGE PARAM_VALUE.Y_EDGE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_EDGE}] ${MODELPARAM_VALUE.Y_EDGE}
}

proc update_MODELPARAM_VALUE.X_MULT { MODELPARAM_VALUE.X_MULT PARAM_VALUE.X_MULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_MULT}] ${MODELPARAM_VALUE.X_MULT}
}

proc update_MODELPARAM_VALUE.Y_MULT { MODELPARAM_VALUE.Y_MULT PARAM_VALUE.Y_MULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_MULT}] ${MODELPARAM_VALUE.Y_MULT}
}

proc update_MODELPARAM_VALUE.CLICK_LONG { MODELPARAM_VALUE.CLICK_LONG PARAM_VALUE.CLICK_LONG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLICK_LONG}] ${MODELPARAM_VALUE.CLICK_LONG}
}

