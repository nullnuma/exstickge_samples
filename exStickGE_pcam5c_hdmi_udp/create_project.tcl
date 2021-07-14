set project_dir    "./prj"
set project_name   "exstickge_pcam_hdmi_udp"
set project_target "xc7a200tsbg484-2"
set source_files { \
			../misc/axi4m_to_fifo.vhd \
			../misc/fifo_to_axi4m_2000.vhd \
			../misc/resetgen.v \
			../misc/axi4_lite_reader.sv \
			../misc/i2c_iface.vhd \
			../misc/reset_counter.vhd \
			../digilent/DVI/900p_edid.data \
			../digilent/DVI/ChannelBond.vhd \
			../digilent/DVI/ClockGen.vhd \
			../digilent/DVI/DVI_Constants.vhd \
			../digilent/DVI/EEPROM_8b.vhd \
			../digilent/DVI/GlitchFilter.vhd \
			../digilent/DVI/InputSERDES.vhd \
			../digilent/DVI/OutputSERDES.vhd \
			../digilent/DVI/PhaseAlign.vhd \
			../digilent/DVI/ResyncToBUFG.vhd \
			../digilent/DVI/SyncAsync.vhd \
			../digilent/DVI/SyncAsyncReset.vhd \
			../digilent/DVI/SyncBase.vhd \
			../digilent/DVI/TMDS_Clocking.vhd \
			../digilent/DVI/TMDS_Decoder.vhd \
			../digilent/DVI/TMDS_Encoder.vhd \
			../digilent/DVI/TWI_SlaveCtl.vhd \
			../digilent/DVI/dvi2rgb.vhd \
			../digilent/DVI/rgb2dvi.vhd \
			../xilinx/2020.1/mig_a.prj \
			../edif/e7udpip_rgmii_artix7.edif \
			../edif/e7udpip_rgmii_artix7_stub.v \
			../vision/init_sccb_top.vhd \
			../vision/videoaxis2dram.v \
			../digilent/AXI_BayerToRGB/hdl/AXI_BayerToRGB.vhd \
			../digilent/AXI_BayerToRGB/hdl/LineBuffer.vhd \
			../digilent/AXI_GammaCorrection/hdl/AXI_GammaCorrection.vhd \
			../digilent/AXI_GammaCorrection/hdl/StoredGammaCoefs.vhd \
			../uplutils/e7udp_vio.v \
			../uplutils/udp_axi.v \
			./sources/pic_combine.v \
			./sources/pic_read.v \
			./sources/rgb2dram.v \
			./sources/pic_read.v \
			./sources/top.v \
}

set constraint_files { \
			./sources/top.xdc \
		       }

set simulation_files { \
			../vision/init_sccb_top_tb.vhd \
			../xilinx/2020.1/sccb_bmem_tb.vhd \
		       }

create_project -force $project_name $project_dir -part $project_target
add_files -norecurse $source_files
add_files -fileset constrs_1 -norecurse $constraint_files

update_ip_catalog

import_ip -files ../xilinx/2020.1/fifo_36_2000.xci
import_ip -files ../xilinx/2020.1/fifo_37_1000_ft.xci
import_ip -files ../xilinx/2020.1/fifo_40_32_ft.xci
import_ip -files ../xilinx/2020.1/mig_7series_0.xci
import_ip -files ../xilinx/2020.1/mipi_csi2_rx_subsystem_0.xci
#import_ip -files ../xilinx/2020.1/sccb_bmem_280M480p.xci
import_ip -files ../xilinx/2020.1/sccb_bmem.xci
import_ip -files ../xilinx/2020.1/fifo_dataread.xci
import_ip -files ../xilinx/2020.1/axi_interconnect_M1S3.xci
import_ip -files ./ip/clk_wiz_0.xci
import_ip -files ./ip/clk_wiz_1.xci
import_ip -files ./ip/fifo_rgbtmp.xci
import_ip -files ./ip/ila_0.xci
import_ip -files ./ip/ila_1.xci
import_ip -files ./ip/ila_2.xci
import_ip -files ./ip/vio_0.xci
import_ip -files ./ip/vio_1.xci

set_property -dict [list CONFIG.Coe_File [file normalize ../xilinx/2020.1/pcam_480p_280M.coe]] [get_ips sccb_bmem]

set_property top top [current_fileset]
set_property target_constrs_file ./sources/top.xdc [current_fileset -constrset]

update_compile_order -fileset sources_1

add_files -fileset sim_1 -norecurse $simulation_files

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
