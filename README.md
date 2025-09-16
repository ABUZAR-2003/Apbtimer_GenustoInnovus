# Apbtimer_GenustoInnovus

Tools Used: 

Logic Synthesis: Cadence Genus

Floorplanning, Placement, CTS, Routing: Cadence Innovus

Technology: 45nm standard cell library

---

🚀 Flow Steps

1. RTL Design

Designed apb_timer.v in Verilog.

Verified functionality with a self-checking testbench.



2. Synthesis (Genus)

Used synth.tcl and apb_timer.sdc for constraints.

Generated gate-level netlist and synthesis reports.



3. Floorplanning

Defined die/core area, power rings & stripes.

Inserted IO and power pads.



4. Placement

Performed standard cell placement.

Verified congestion and utilization.



5. Clock Tree Synthesis (CTS)

Used cts.tcl to balance clock skew/latency.

Generated CTS timing and clock tree reports.



6. Routing

Global and detailed routing performed.

Verified DRC clean layout.



7. Static Timing Analysis (STA)

Post-route timing checks performed.

Ensured setup/hold closure.



8. Final Outputs

Gate-level netlist (.v)

DEF and GDSII layout (.def, .gds)

Timing & power reports

SDF for back-annotation


---

📊 Key Results

Core Utilization: ~50%

Timing Closure: No setup/hold violations after routing

Clock Skew: Within acceptable limits after CTS

Final GDSII: Ready for tapeout
