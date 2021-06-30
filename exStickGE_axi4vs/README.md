# exStickGE_axi4vs

This is an example which displays a picture on a monitor conntected by HDMI. The image is written by UDP/IP packets.

## Requirements
- Vivado 2020.1

## Build

```
vivado -mode batch -source ./create_project.tcl
```

You can get `prj/exstickge_dram_hdmiout.runs/impl_1/top.bit` after the compilation finished.
The IP-address of exStickGE is `10.0.0.3/24`.

## Usage


