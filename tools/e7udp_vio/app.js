"use strict";

const dgram = require('dgram');

const PORT = 16385;
const HOST ='10.0.0.3';

const sock = dgram.createSocket('udp4');

sock.on('listening', () =>{
	const addr = sock.address();
	console.log(`addr ${addr.address}`);	
});

sock.on('message', (mes,remote)=>{
	console.log(mes,remote);
})

sock.bind(16385,'10.0.0.1');
let mode = 1;
let buf;
if(mode == 0){
	buf = Buffer.alloc(8);
	buf.writeUInt8(0xff, 0);
	buf.writeUInt8(0x1, 1);
	buf.writeUInt8(mode, 2);//mode
	buf.writeUInt8(0x1, 3);//addr
	buf.writeUInt32BE(0x11223355, 4);
}else if(mode == 1){
	buf = Buffer.alloc(8);
	buf.writeUInt8(0xff, 0);
	buf.writeUInt8(0x0, 1);
	buf.writeUInt8(mode, 2);
	buf.writeUInt8(0x0, 3);
}
console.log("send", buf);
sock.send(buf, 0, buf.length, PORT, HOST, (err, bytes) => {
    if (err) throw err;
});

