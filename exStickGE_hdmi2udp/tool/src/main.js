const {
    app,
    Menu,
    BrowserWindow,
    ipcMain
} = require('electron');
const path = require('path');
const url = require('url');
const fs = require('fs');
const dgram = require("dgram");

//IP Setting
const recvport = 0x4000;
const recvip = "0.0.0.0";
const port = 0x4000;
const ipaddr = "10.0.0.3";
const UDPINST = { isopen: false };

let mainWindow;


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
    mainWindow.webContents.openDevTools();

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

const sleep = (time) => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve();
        }, time);
    });
};
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
    mainWindow.webContents.send('recv', mes);
};

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