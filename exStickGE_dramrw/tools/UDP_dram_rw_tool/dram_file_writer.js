const fs = require("fs");
const DRAMOPE = require("./dram_ope");
if (process.argv.length != 3) {
	console.log(`Usage ${process.argv[0]} ${process.argv[1]} <filename>`);
	return;
}

const filename = process.argv[2];

//IP Setting
const recvport = 0x4056
const recvip = "0.0.0.0";
const port = 0x4000;
const ipaddr = "10.0.0.3";

//一度に転送するワード数(4-byte=1word max 64-word)
const word_per_transfer = 64;
//送信する間隔
const send_interval = 10;

//Init
const dramope = new DRAMOPE(ipaddr, port, recvip, recvport);

let count = 0;
let total = 0;

const byte_per_transfer = word_per_transfer * 4;
const chunk = Buffer.alloc(byte_per_transfer);
let size = 0;
const fd = fs.openSync(filename, "r");

const readfile = () => {
	try {
		if (((size = fs.readSync(fd, chunk, 0, byte_per_transfer, total)) !== 0)) {
			dramope.writeBinData(total / 4, chunk);
			count++;
			total += size;
			console.log(`count: ${count} byte: ${total} size: ${size}`);
			setTimeout(() => {
				readfile();
			}, send_interval);
		} else {
			fs.closeSync(fd);
			process.exit(0);
		}
	} catch (e) {
		console.log(e.message);
	}
};
readfile();