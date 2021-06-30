# exStickGE_loopback

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
