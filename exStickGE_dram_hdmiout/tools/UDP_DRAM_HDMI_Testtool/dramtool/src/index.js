const ipc = window.nodeRequire('electron').ipcRenderer;
$(function() {
    var blob = null; // 画像(BLOBデータ)
    const THUMBNAIL_WIDTH = 64; // 画像リサイズ後の横の長さの最大値
    const THUMBNAIL_HEIGHT = 64; // 画像リサイズ後の縦の長さの最大値
    $('#imgfile').change(function() {
        let file = $(this).prop('files')[0];
        console.log(file);
        var image = new Image();
        var reader = new FileReader();
        reader.onload = function(e) {
            image.onload = function() {
                var width, height;
                if (image.width > image.height) {
                    // 横長の画像は横のサイズを指定値にあわせる
                    var ratio = image.height / image.width;
                    width = THUMBNAIL_WIDTH;
                    height = THUMBNAIL_WIDTH * ratio;
                } else {
                    // 縦長の画像は縦のサイズを指定値にあわせる
                    var ratio = image.width / image.height;
                    width = THUMBNAIL_HEIGHT * ratio;
                    height = THUMBNAIL_HEIGHT;
                }
                // サムネ描画用canvasのサイズを上で算出した値に変更
                var canvas = $('#canvas')
                    .attr('width', width)
                    .attr('height', height);
                var ctx = canvas[0].getContext('2d');
                // canvasに既に描画されている画像をクリア
                ctx.clearRect(0, 0, width, height);
                // canvasにサムネイルを描画
                ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, width, height);

                // canvasからbase64画像データを取得
                blob = new Buffer.from(ctx.getImageData(0, 0, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT).data);
                console.log(blob);
                ipc.send("imgsend", blob);
            }
            image.src = e.target.result;
        }
        reader.readAsDataURL(file);
    });
    ipc.send("isopen");
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
    })
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
})