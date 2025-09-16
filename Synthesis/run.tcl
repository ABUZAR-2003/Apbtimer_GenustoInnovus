set_db init_lib_search_path /home/install/FOUNDRY/digital/45nm/LIBS/lib/max     
set_db lef_library /home/install/FOUNDRY/digital/45nm/LIBS/lef/gsclib045.fixed.lef

set_db library  slow.lib
    
read_hdl {./apb_timer.v}

elaborate

read_sdc ./apb_timer.sdc

syn_generic
syn_map
syn_opt

write_hdl > apb_timer_netlist.v
write_sdc  > apb_timer_constraint.sdc
   
gui_show

report timing > apb_timer_timing.rpt
report power > apb_timer_power.rpt
report area > apb_timer_cell.rpt
report gates > apb_timer_gates.rpt

