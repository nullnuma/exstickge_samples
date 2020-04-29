const ipc = window.nodeRequire('electron').ipcRenderer;

let canvasObj = {
    ready: false
};
$(function() {
    $("#btn_start,#btn_stop").click(function() {
        if (canvasObj.ready) {
            canvasObj.ready = false;
            return;
        }
        const P_WIDTH = parseInt(document.getElementById("x_size").value);
        const P_HEIGHT = parseInt(document.getElementById("y_size").value);
        canvasObj.canvas = $('#canvas')
            .attr('width', P_WIDTH)
            .attr('height', P_HEIGHT);
        canvasObj.ctx = canvasObj.canvas[0].getContext('2d');

        canvasObj.imageData = canvasObj.ctx.getImageData(0, 0, canvasObj.canvas.width(), canvasObj.canvas.height());
        canvasObj.width = canvasObj.imageData.width;
        canvasObj.height = canvasObj.imageData.height;

        canvasObj.pixels = canvasObj.imageData.data;
        canvasObj.ready = true;
        ipc.send('imgreq');

    });
    ipc.send("connect");
    $("#btn_conn").click(() => {
        let ip = $("#ip").val();
        let port = $("#port").val()
        if (ip.match(/(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/) && port.match(/([1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]{1})/)) {
            ipc.send('connect', {
                ip: ip,
                port: port
            });
        } else {
            $("#log").text("error ip or port");
        }
    });
    $("#btn_disconn").click(() => {
        ipc.send('disconn');
    });
});

ipc.on("recv", (event, mes) => {
    if (canvasObj.ready == false) return;
    let base = (mes[0] * 16777216 + mes[1] * 65536 + mes[2] * 256 + mes[3]);
    canvasObj.pixels.set(mes.slice(4, 260), base * 4);
    if (base % (canvasObj.width * 4 * 4) == 0) { //描画の頻度を落とす
        canvasObj.ctx.putImageData(canvasObj.imageData, 0, 0);
    }
});
ipc.on("recvend", () => {
    canvasObj.ctx.putImageData(canvasObj.imageData, 0, 0);
    canvasObj.ready = false;
});

ipc.on("isopen", (event, arg) => {
    console.log("isopen", arg);
    if (arg) {
        $("#btn_conn").hide();
        $("#btn_disconn").show();
    } else {
        $("#btn_conn").show();
        $("#btn_disconn").hide();
    }
    $("#ip").prop('disabled', arg);
    $("#port").prop('disabled', arg);
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

watchValue(canvasObj, "ready", (v1, v2) => {
    console.log(`old:${v1}  new:${v2}`);
    if (v2) {
        $("#btn_start").hide();
        $("#btn_stop").show();
    } else {
        $("#btn_start").show();
        $("#btn_stop").hide();
    }
    $("#x_size").prop('disabled', v2);
    $("#y_size").prop('disabled', v2);
});