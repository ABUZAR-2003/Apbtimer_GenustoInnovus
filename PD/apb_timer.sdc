# Create clock
create_clock -name PCLK -period 10 [get_ports PCLK]

# Define reset as asynchronous
set_false_path -from [get_ports PRESETn]

# Input/output delay assumptions (relative to PCLK)
set_input_delay  2 -clock PCLK [remove_from_collection [all_inputs] [get_ports PRESETn]]
set_output_delay 2 -clock PCLK [all_outputs]

# Clock gating relation (PCLKG derived from PCLK)
create_generated_clock -name PCLKG -source [get_ports PCLK] [get_ports PCLKG]

# Set driving cell and load for synthesis accuracy
set_driving_cell -lib_cell BUFX4 [all_inputs]
set_load 0.1 [all_outputs]
