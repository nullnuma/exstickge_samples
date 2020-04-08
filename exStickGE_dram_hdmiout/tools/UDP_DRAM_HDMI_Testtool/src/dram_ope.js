const dgram = require("dgram");

let DRAMOPE = function(ip, port, recvip, recvport) {
    this.isopen = true;
    this.sock = dgram.createSocket("udp4");
    this.ipaddr = ip;
    this.port = port;
    this.sock.bind(recvport, recvip);
}

DRAMOPE.prototype.open = function(ip, port, recvip, recvport) {
    if (this.isopen == false) {
        console.log("Open now");
        this.isopen = true;
        this.sock = dgram.createSocket("udp4");
        this.ipaddr = ip;
        this.port = port;
        this.sock.bind(recvport, recvip);
    } else {
        console.log("Already Open");
    }
}

DRAMOPE.prototype.close = function() {
    this.isopen = false;
    this.sock.close();
}


DRAMOPE.prototype.getSock = function() {
    return this.sock;
}

DRAMOPE.prototype.writeString = function(addr, str) {
    this.writeBinData(addr, Buffer.from(str));
};

DRAMOPE.prototype.writeBinData = function(addr, bindata) {
    let len = bindata.length;
    if (len > 256) {
        console.log("size over");
        return 0;
    }
    if (addr < 0 || 0x7FFFFFFF < addr) {
        console.log("addr error");
        return 0;
    }
    let buf = Buffer.alloc(4 + len);
    buf.writeUInt32BE((addr << 1) | 0x1, 0);
    bindata.copy(buf, 4);
    this.sock.send(buf, 0, buf.length, this.port, this.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

DRAMOPE.prototype.readData = function(addr, size_tmp) {
    if (size_tmp > 64) {
        console.log("size over");
        return 0;
    }
    if (addr < 0 || 0x7FFFFFFF < addr) {
        console.log("addr error");
        return 0;
    }
    let size = size_tmp - 1;
    let buf = Buffer.alloc(8);
    buf.writeUInt32BE((addr << 1) | 0x0, 0);
    buf.writeUInt32BE(size, 4);
    this.sock.send(buf, 0, buf.length, this.port, this.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

DRAMOPE.prototype.parseData = function(message, rinfo, callback) {

    let addr = message.readUInt32BE(0);
    let buf = Buffer.alloc(rinfo.size - 4);
    message.copy(buf, 0, 4);
    callback(buf, addr, (rinfo.size - 4) / 4);
};

module.exports = DRAMOPE;