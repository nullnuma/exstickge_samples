set project_dir    "./prj"
set project_name   "exstickge_stream_recv"
set project_target "xc7a200tsbg484-2"
set source_files { \
			../misc/axi4m_to_fifo_overlap.v \
			../misc/fifo_to_axi4m_2000.vhd \
			./sources/top.v \
			../xilinx/2019.1/mig_a.prj \
			../edif/e7udpip_rgmii_artix7.edif \
			../edif/e7udpip_rgmii_artix7_stub.v \
			../misc/resetgen.v \
			../misc/pulse_timer.v \
			../misc/idelayctrl_wrapper.v \
			./sources/udp_hdmi_recv.v \
			./sources/hdmi_gen.v \
			./sources/rgb2tmds.v \
			./sources/syncgen.v \
			./sources/tmds_encoder.v \
			./sources/dvi_tx.v \
			./sources/hdmi_axi_addr.v \
}

set constraint_files { \
			./sources/top.xdc \
		       }

set simulation_files { \
		       }

create_project -force $project_name $project_dir -part $project_target
add_files -norecurse $source_files
add_files -fileset constrs_1 -norecurse $constraint_files

update_ip_catalog

import_ip -files ./ip/clk_wiz_0.xci
import_ip -files ./ip/clk_wiz_1.xci
import_ip -files ./ip/clk_wiz_2.xci
import_ip -files ../xilinx/2019.1/fifo_36_2000.xci
import_ip -files ../xilinx/2019.1/fifo_37_1000_ft.xci
import_ip -files ../xilinx/2019.1/fifo_40_32_ft.xci
import_ip -files ../xilinx/2019.1/mig_7series_0.xci
import_ip -files ../xilinx/2019.1/fifo_dataread_8000.xci
import_ip -files ../xilinx/2019.1/dvi_transmitter.xci

set_property top top [current_fileset]
set_property target_constrs_file ./sources/top.xdc [current_fileset -constrset]

update_compile_order -fileset sources_1

#add_files -fileset sim_1 -norecurse $simulation_files

update_compile_order -fileset sim_1

reset_project

set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

launch_runs synth_1 -jobs 4
wait_on_run synth_1

launch_runs impl_1 -jobs 4
wait_on_run impl_1
open_run impl_1
report_utilization -file [file join $project_dir "project.rpt"]
report_timing -file [file join $project_dir "project.rpt"] -append
 
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
close_project

quit
