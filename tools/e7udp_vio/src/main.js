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
const recvport = 0x4001;
const recvip = "0.0.0.0";
const UDPINST = { isopen: false };

let mainWindow;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 800,
        webPreferences: {
            nodeIntegration: false,
            preload: path.join(app.getAppPath(), 'preload.js'),
            contextIsolation: true
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
        UDPINST.port = parseInt(arg_port);
        UDPINST.sock.bind(arg_recvport, arg_recvip);
        UDPINST.sock.on('message', (message) => { callback(message); });
        console.log("Open now");
        getInfo();
    } else {
        console.log("Already Open");
    }
};

const close = () => {
    UDPINST.isopen = false;
    UDPINST.sock.close();
};

const recvData = (mes) => {
    mainWindow.webContents.send('recv', mes);
};
const getInfo = () => {
    let buf = Buffer.alloc(4);
    buf.writeUInt32BE(0x200, 0);
    console.log("send getinfo");
    UDPINST.sock.send(buf, 0, buf.length, UDPINST.port, UDPINST.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

const setReq = (port, val) => {
    let buf = Buffer.alloc(8);

    buf.writeUInt8(0x00, 0);
    buf.writeUInt8(0x0, 1);
    buf.writeUInt8(0x0, 2);//mode
    buf.writeUInt8(port & 0xff, 3);//addr
    buf.writeUInt32BE(val, 4);

    UDPINST.sock.send(buf, 0, buf.length, UDPINST.port, UDPINST.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

const getReq = (port) => {
    let buf = Buffer.alloc(4);

    buf.writeUInt8(0x0, 0);
    buf.writeUInt8(0x0, 1);
    buf.writeUInt8(0x1, 2);
    buf.writeUInt8(port & 0xff, 3);

    UDPINST.sock.send(buf, 0, buf.length, UDPINST.port, UDPINST.ipaddr, (err, bytes) => {
        if (err) throw err;
    });
};

ipcMain.on('setreq', (event, arg) => {
    setReq(arg.port, arg.val);
});

ipcMain.on('getreq', (event, arg) => {
    getReq(arg.port);
});

ipcMain.on("isopen", (event, arg) => {
    mainWindow.webContents.send('isopen', isopen);
});
ipcMain.on("connect", (event, arg) => {
    console.log("open");
    connect(arg.ip, arg.port, recvip, recvport, recvData);
});
ipcMain.on("disconn", (event, arg) => {
    console.log("close");
    close();
});