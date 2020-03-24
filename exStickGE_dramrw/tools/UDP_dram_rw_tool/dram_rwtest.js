const fs = require("fs");
const DRAMOPE = require("./dram_ope");
if (process.argv.length != 3) {
	console.log(`Usage ${process.argv[0]} ${process.argv[1]} <RW transfer_byte_num>`);
	return;
}
const transfer_byte_num = parseInt(process.argv[2]);
if (transfer_byte_num % 4) {
	console.log("<RW transfer_byte_num> must be a multiple of 4");
	return;
}

//IP Setting
const recvport = 0x4056
const recvip = "0.0.0.0";
const port = 0x4000;
const ipaddr = "10.0.0.3";
//一度に転送するワード数(4-byte=1word max 64-word)
const word_per_transfer = 64;
//送信する間隔
const send_interval = 0;

//Init
const dramope = new DRAMOPE(ipaddr, port, recvip, recvport);

let count = 0;
let w_total = 0;
let r_total = 0;

const byte_per_transfer = word_per_transfer * 4;

let testdata = Buffer.alloc(transfer_byte_num);
let recvdata = Buffer.alloc(transfer_byte_num);
//Init Test Random Data
for (let i = 0; i < transfer_byte_num; i++) {
	testdata[i] = Math.floor(Math.random() * 256);
}


const senddata = () => {
	const size = (w_total + byte_per_transfer <= transfer_byte_num) ? byte_per_transfer : (transfer_byte_num - w_total);
	dramope.writeBinData(w_total / 4, testdata.slice(w_total, w_total + size));
	count++;
	w_total += size;
	console.log(`count : ${count} total: ${w_total} size: ${size}`);
	if (w_total < transfer_byte_num) {
		setTimeout(() => {
			senddata();
		}, send_interval);
	} else {
		//recv
		count = 0;
		recvcmd_send();
	}
};
senddata();

dramope.sock.on('message', (message, remote) => {
	dramope.parseData(message, remote, (buf, addr, word) => {
		buf.copy(recvdata, addr * 4, 0);
		count++;
		r_total += word * 4;
		console.log(`addr ${addr} size ${word} byte ${word*4} count ${count} r_total ${r_total}`);

		//すべて受信したら
		if (!(count < transfer_byte_num / (word_per_transfer * 4))) {
			console.log("all recv");
			//比較
			let i, mismatch_cnt = 0;
			for (i = 0; i < transfer_byte_num; i++) {
				if (testdata[i] != recvdata[i]) {
					console.log(`no match index: ${i}`);
					mismatch_cnt++;
				}
			}
			console.log(`compare ${(mismatch_cnt == 0)?"Success":"Fail("+mismatch_cnt+")"}`);
			console.log(Buffer.compare(recvdata, testdata));
			process.exit(0);
		}
	});
});

let recvcmd_cnt = 0;
const recvcmd_send = () => {
	const total_byte = (recvcmd_cnt * byte_per_transfer);
	const wordsize = (total_byte + byte_per_transfer <= transfer_byte_num) ? word_per_transfer : (transfer_byte_num - total_byte) / 4;
	dramope.readData(recvcmd_cnt * word_per_transfer, wordsize);
	recvcmd_cnt++;
	if (recvcmd_cnt < transfer_byte_num / (word_per_transfer * 4)) {
		setTimeout(() => {
			recvcmd_send();
		}, send_interval);
	}
}