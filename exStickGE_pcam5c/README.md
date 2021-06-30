# exStickGE_pcam5c

This is an example to capture Pcam5C image and read the image via UDP/IP.

## Requirements
- Vivado 2020.1

## Build

```
vivado -mode batch -source ./create_project.tcl
```

You can get `prj/exstickge_dram_hdmiout.runs/impl_1/top.bit` after the compilation finished.
The IP-address of exStickGE is `10.0.0.3/24`.

## Usage

```bash
cd ../exStickGE_hdmi2dram2udp/tool/
electron src
```
Set the capturing resolution into 1920x1080.

## Resources
- [pg232-mipi-csi2-rx](https://www.xilinx.com/support/documentation/ip_documentation/mipi_csi2_rx_subsystem/v5_0/pg232-mipi-csi2-rx.pdf)
- [exStickGEでPcam5Cを動かしてみた](https://e-trees.jp/wp/?p=922)

