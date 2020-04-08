const dgram = require("dgram");

let BRAMOPE = function (ip, port, recvip, recvport) {
	this.isopen = true;
	this.sock = dgram.createSocket("udp4");
	this.ipaddr = ip;
	this.port = port;
	this.sock.bind(recvport, recvip);
}

BRAMOPE.prototype.open = function (ip, port, recvip, recvport) {
	if (this.isopen == false) {
		this.sock = dgram.createSocket("udp4");
		this.ipaddr = ip;
		this.port = port;
		this.sock.bind(recvport, recvip);
		this.isopen = true;
	} else {
		console.log("Already Open");
	}
}

BRAMOPE.prototype.close = function () {
	this.isopen = false;
	this.sock.close();
}


BRAMOPE.prototype.getSock = function () {
	return this.sock;
}

BRAMOPE.prototype.writeString = function (addr, str) {
	writeBinData(addr, Buffer.from(str));
};

BRAMOPE.prototype.writeBinData = function (addr, bindata) {
	let len = bindata.length;
	let size = parseInt((len + 3) / 4) - 1;
	if (size > 256 * 4) {
		console.log("size over");
		return 0;
	}
	if (addr < 0 || 262144 < addr) {
		console.log("addr error");
		return 0;
	}
	let buf = Buffer.alloc(4 + len);
	buf[0] = addr >>> 8;
	buf[1] = addr & 0x00ff;
	buf[2] = size >>> 7;
	buf[3] = (size << 1) | 0x1;
	bindata.copy(buf, 4);
	this.sock.send(buf, 0, buf.length, this.port, this.ipaddr, (err, bytes) => {
		if (err) throw err;
	});
};

BRAMOPE.prototype.readData = function (addr, size_tmp) {
	let size = size_tmp - 1;
	let buf = Buffer.alloc(4);
	buf[0] = addr >>> 8;
	buf[1] = addr & 0x00ff;
	buf[2] = (size) >>> 7;
	buf[3] = ((size) << 1) | 0x0;
	this.sock.send(buf, 0, buf.length, this.port, this.ipaddr, (err, bytes) => {
		if (err) throw err;
	});
};

BRAMOPE.prototype.parseData = function (message, rinfo, callback) {

	let addr = message.readUInt16BE(0);
	let size = (message.readUInt16BE(2) >>> 1) + 1;
	let buf = Buffer.alloc(rinfo.size - 4);
	message.copy(buf, 0, 4);
	callback(buf, addr, size);
};

module.exports = BRAMOPE;