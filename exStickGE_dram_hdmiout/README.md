# exStickGE_dram_hdmiout

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

- Connect a display into CN2 on the exStickGE-VISION board.
- Set IP-address of your host PC into `10.0.0.1`, to communicate exStickGE via UDP/IP.
- See [tools/UDP_DRAM_HDMI_Testtool/README.md](tools/UDP_DRAM_HDMI_Testtool/README.md)

