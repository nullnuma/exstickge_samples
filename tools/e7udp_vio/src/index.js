
let canvasObj = {
    ready: false
};

let INPUT_NUM = 0;
let OUTPUT_NUM = 0;

let setReq = (port, val) => {
    window.electron.send('setreq', {
        port: port,
        val: val
    });
};

let getReq = (port) => {
    window.electron.send('getreq', {
        port: port
    });
};

$(function () {
    setTimeout(() => {
        $("#btn_conn").click();
    }, 500);
    $("#btn_conn").click(() => {
        let ip = $("#ip").val();
        let port = $("#port").val()
        if (ip.match(/(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/) && port.match(/([1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]{1})/)) {
            window.electron.send('connect', {
                ip: ip,
                port: port
            });
        } else {
            $("#log").text("error ip or port");
        }
    });
    $("#btn_disconn").click(() => {
        window.electron.send('disconn');
    });

});

const zeropadding = (val, len) => {
    return ("0".repeat(len) + val).slice(-len);
};

window.electron.on("recv", (mes) => {
    let port, val, i;
    switch (mes[2]) {
        case 1://read from reg
            port = mes[3];
            document.getElementById(`in_${port}`).value = "0x" + zeropadding(mes[4].toString(16), 2) + zeropadding(mes[5].toString(16), 2) + zeropadding(mes[6].toString(16), 2) + zeropadding(mes[7].toString(16), 2);
            document.getElementById(`in_${port}`).classList.add("bg-info");
            setTimeout(() => {
                document.getElementById(`in_${port}`).classList.remove("bg-info");
            }, 2000);
            break;
        case 2://read info
            //Init
            INPUT_NUM = mes[6];
            OUTPUT_NUM = mes[7];
            InitProbe();
            break;
        case 3://irq
            val = mes[3];
            for (i = 0; val > 0; val = val >> 1, i++) {
                if (val & 0x1) {
                    getReq(i);
                }
            }
            break;
    }
});

window.electron.on("isopen", (arg) => {
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

function InitProbe () {
    let pin_template = document.getElementById('pin_template');
    let pout_template = document.getElementById('pout_template');
    let node, i;

    node = document.getElementById('pout_root');
    while (node.firstChild) {
        node.removeChild(node.firstChild);
    }
    node = document.getElementById('pin_root');
    while (node.firstChild) {
        node.removeChild(node.firstChild);
    }

    for (i = 0; i < OUTPUT_NUM; i++) {
        node = pout_template.content.cloneNode(true);
        node.querySelector('.probe_name').textContent = `Out${i + 1} 0x`;
        node.querySelector('input').id = `out_${i}`;
        node.querySelector('input').addEventListener('change', (e) => {
            let port = parseInt(e.srcElement.id.match(/[0-9]+/));
            let val = parseInt(e.srcElement.value, 16);
            if (e.srcElement.value == val.toString(16) && 0 <= val && val <= 0xffffffff) {
                setReq(port, val);
                document.getElementById(`out_${port}`).classList.add("bg-info");
                setTimeout(() => {
                    document.getElementById(`out_${port}`).classList.remove("bg-info");
                }, 1000);
            } else {
                e.srcElement.value = "error";
                document.getElementById(`out_${port}`).classList.add("bg-danger");
                setTimeout(() => {
                    document.getElementById(`out_${port}`).classList.remove("bg-danger");
                }, 1000);
            }
        });
        document.getElementById('pout_root').appendChild(node);
    }

    for (i = 0; i < INPUT_NUM; i++) {
        node = pin_template.content.cloneNode(true);
        node.querySelector('.probe_name').textContent = `In${i + 1}`;
        node.querySelector('input').id = `in_${i}`;
        document.getElementById('pin_root').appendChild(node);
        getReq(i);
    }
}

function watchValue (obj, propName, func) {
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