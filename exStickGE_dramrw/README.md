# exStickGE_dramrw

This is an exmaple to read and write the on-board DRAM via UDP/IP.

## Requirements
- Vivado 2020.1

## Build

```
vivado -mode batch -source ./create_project.tcl
```
You can get `prj/exstickge_dram_hdmiout.runs/impl_1/top.bit` after the compilation finished.
The IP-address of exStickGE is `10.0.0.3/24`.

## Usage

- Set IP-address of your host PC into `10.0.0.1`, to communicate exStickGE via UDP/IP.
- See [tools/UDP_dram_rw_tool/README.md ](tools/UDP_dram_rw_tool/README.md)
