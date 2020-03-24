# DRAM RW Tools

## dram_ope.js
DRAMの読み書き用ライブラリ

## dram_rwtest.js
データをnバイト書き込み読み出すテスト


### 1000バイト分テストする例
```bash
node dram_rwtest.js 1000
```

## dram_file_writer.js
ファイルをDRAM上に書き込む

### testdata.datを書き込む例
```bash
node dram_file_writer.js testdata.dat
```

## dram_file_reader.js
DRAM上のデータをファイルに書き込む

### DRAM上のデータをdump.outに1000バイト書き込む例
```bash
node dram_file_reader.js 1000 dump.dat
```