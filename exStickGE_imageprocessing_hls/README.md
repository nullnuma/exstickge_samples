# exStickGE_imageprocessing_hls

This is an example which applies image processing into the image captured via HDMI. The image processing kernel is implemented by using Vivado HLS.

## Requirements
- Vivado 2019.1 with Vivado HLS

## Build

```
cd hls
vivado_hls grayscale/script.tcl
cd ..
vivado -mode batch -source ./create_project.tcl
```

You can get `prj/exstickge_dram_hdmiout.runs/impl_1/top.bit` after the compilation finished.
The IP-address of exStickGE is `10.0.0.3/24`.

## Usage


