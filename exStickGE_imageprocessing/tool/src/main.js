const {
    app,
    Menu,
    BrowserWindow,
    ipcMain
} = require('electron');
const path = require('path');
const url = require('url');
const dgram = require("dgram");

//IP Setting
const recvport = 0x4000;
const recvip = "0.0.0.0";
let port = 0x4000;
let ipaddr = "10.0.0.3";
const UDPINST = { isopen: false };

let mainWindow;

//1度に受信するピクセル数
const DATA_PER_PACKET = 64; //MAX 64
const RESOLUTION_WIDTH = 1600;
const RESOLUTION_HEIGHT = 900;
const BASEADDR = 0x2000000 / 4;
let getnow_f = false;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1200,
        height: 800,
        webPreferences: {
            nodeIntegration: true
        }
    });

    mainWindow.loadURL(url.format({
        pathname: path.join(__dirname, 'index.html'),
        protocol: 'file:',
        slashes: true
    }));

    // 開発ツールを有効化
    if (process.argv.length > 2 && process.argv[2] == "debug") {
        mainWindow.webContents.openDevTools();
    }
    Menu.setApplicationMenu(null);

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
    watchValue(UDPINST, "isopen", (v1, v2) => {
        console.log(`old:${v1}  new:${v2}`);
        mainWindow.webContents.send('isopen', v2);
    });
}

require('electron-reload')(__dirname, {
    electron: require(`${__dirname}/../node_modules/electron`)
});

app.on('ready', createWindow);

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('activate', () => {
    if (mainWindow === null) {
        createWindow();
    }
});

function watchValue(obj, propName, func) {
    let value = obj[propName];
    Object.defineProperty(obj, propName, {
        get: () => value,
        set: newValue => {
            const oldValue = value;
            value = newValue;
            func(oldValue, newValue);
        },
        configurable: true
    });
}

const connect = (arg_ip, arg_port, arg_recvip, arg_recvport, callback) => {
    if (UDPINST.isopen == false) {
        UDPINST.isopen = true;
        UDPINST.sock = dgram.createSocket("udp4");
        UDPINST.ipaddr = arg_ip;
        UDPINST.port = arg_port;
        UDPINST.sock.bind(arg_recvport, arg_recvip);
        UDPINST.sock.on('message', (message) => { callback(message); });
        console.log("Open now");
    } else {
        console.log("Already Open");
    }
};

const close = () => {
    UDPINST.isopen = false;
    UDPINST.sock.close();
};

const recvData = (mes) => {
    let base = (mes[0] * 16777216 + mes[1] * 65536 + mes[2] * 256 + mes[3]) + 64 - BASEADDR;
    mainWindow.webContents.send('recv', { mes: mes, baseaddr: BASEADDR });
    if (base < RESOLUTION_WIDTH * RESOLUTION_HEIGHT) {
        let x = base % (RESOLUTION_WIDTH);
        let y = parseInt(base / RESOLUTION_WIDTH);
        readReq(x, y);
        console.log("next", "x", x, "y", y);
    } else {
        //終了
        getnow_f = false;
        mainWindow.webContents.send('recvend');
    }
};
const captureReq = () => {
    let buf = Buffer.alloc(4);
    buf.writeUInt32BE(0x1, 0);
    UDPINST.sock.send(buf, 0, buf.length, UDPINST.port, UDPINST.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

const readReq = (x, y) => {
    let buf = Buffer.alloc(8);
    buf.writeUInt32BE((BASEADDR + ((x + RESOLUTION_WIDTH * y)) << 1) | 0x0, 0);
    buf.writeUInt32BE(DATA_PER_PACKET - 1, 4);
    UDPINST.sock.send(buf, 0, buf.length, UDPINST.port, UDPINST.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

ipcMain.on("imgreq", () => {
    if (getnow_f == false) {
        getnow_f = true;
        captureReq();
        setTimeout(() => readReq(0, 0), 100);
    }
});

ipcMain.on("isopen", (event, arg) => {
    mainWindow.webContents.send('isopen', isopen);
});
ipcMain.on("connect", (event, arg) => {
    console.log("open");
    connect(ipaddr, port, recvip, recvport, recvData);
});
ipcMain.on("disconn", (event, arg) => {
    console.log("close");
});