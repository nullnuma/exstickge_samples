const fs = require("fs");
const DRAMOPE = require("./dram_ope");

if (process.argv.length != 4) {
	console.log(`Usage ${process.argv[0]} ${process.argv[1]} <totalbyte> <filename>`);
	return;
}

const filename = process.argv[3];
const filesize = parseInt(process.argv[2]);


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

process.on("exit", function () {
	console.log("Exitting...");
	fs.writeFileSync(filename, data);
	console.log("Saved!");
})
process.on("SIGINT", function () {
	process.exit(0);
});

//Socket Event
dramope.sock.on("listening", () => {
	const address = dramope.sock.address();
	console.log('UDP socket listening on ' + address.address + ":" + address.port);
});

let count = 0;
let total = 0;

dramope.sock.on('message', (message, remote) => {
	dramope.parseData(message, remote, (buf, addr, word) => {
		buf.copy(data, addr * 4, 0);
		count++;
		total += word * 4;
		console.log(`addr:${addr} word:${word} byte:${word*4} count:${count} total:${total}`);

		//すべて受信したら
		if (!(count < filesize / (word_per_transfer * 4))) {
			console.log("all recv");
			process.exit(0);
		}
	});
});


const data = Buffer.alloc(filesize);
let i = 0;
const send = () => {
	dramope.readData(i * word_per_transfer, word_per_transfer);
	i++;
	if (i < filesize / (word_per_transfer * 4)) {
		setTimeout(() => {
			send();
		}, send_interval);
	}
}
send();