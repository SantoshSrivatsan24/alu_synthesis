#general setup
#--------------

set_attr init_lib_search_path /opt/apps/cadence/softwares/custom/GPDK/gsclib045_all_v4.3/gsclib045/timing/

set_attr init_hdl_search_path ./  


#load the library
#------------------------------

set_attr library slow_vdd1v2_basicCells.lib

#Adding a clock to avoid unconstrained timing slack
#------------------------------------------------


set frequency    150.0          ;# Clock frequency in MHz
set myClk        clk          ;# clock name
set input_setup  10           ;# delay from clock to inputs valid (in ps)
set output_delay 30            ;# delay from clock to output valid (in ps)
set clock_period [expr 1000000.0 / $frequency]   ;# Clock period in ps



#load and elaborate the design
#------------------------------

read_hdl { processing_unit.v }
#read_hdl { cla32.v rk8.v rca.v rca32.v rk4.v rk2.v rca8.v rca4.v rca2.v twobit_add.v twobit_ha.v fulladder.v }
elaborate

#specify timing and design constraints
#--------------------------------------

#read_sdc constraints_top.sdc

#optional
#add optimization constraints
#----------------------------

set_drive     2.0 [all_inputs]
set_load      3.0 [all_outputs]
set_max_fanout 5   [all_inputs]

#synthesize the design
#---------------------

syn_generic

#optional

syn_map
syn_opt

#analyze design
#------------------

report timing > process_timing.rep

report area > process_area.rep

report power > process_power.rep

report gates > process_gates.rep

#export design
#-------------

write_hdl > process_netlist.v

write_sdc > constraints.sdc

write_script > constraints.g

write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge > delays.sdf



#optional steps
#optional steps
# export design for Innovus
#-----------------------

#write_design [-basename string] [-gzip_files] [-tcf] [-innovus] [-hierarchical] [design]

write_design -innovus process

gui_show
