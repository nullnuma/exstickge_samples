# exStickGE_udpvio

## Requirements
- Vivado 2020.1

## Build

```
vivado -mode batch -source ./create_project.tcl
```
The IP-address of exStickGE is `10.0.0.3/24`.

## Usage

```
cd ../tools/e7udp_vio
# Run npm only the first time
npm install
electron src
```