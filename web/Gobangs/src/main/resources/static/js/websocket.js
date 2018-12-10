    var str;
    var websocket = null;

//判断当前浏览器是否支持WebSocket
        if ('WebSocket' in window) {
            //建立连接，这里的/websocket ，是Servlet中注解中的那个值
            websocket = new WebSocket("ws://localhost:9090/websocket");
        }
        else {
            alert('当前浏览器 Not support websocket');
        }

//连接发生错误的回调方法
    websocket.onerror = function () {
        console.log("WebSocket连接发生错误");
    };

//连接成功建立的回调方法
    websocket.onopen = function () {
        console.log("WebSocket连接成功");
    };

//接收到消息的回调方法
    websocket.onmessage = function (event) {
        str=event.data;
        console.log(event.data);
        judge=StringToInt(str);
        wschess(judge);
    };

//连接关闭的回调方法
    websocket.onclose = function () {
        console.log("WebSocket连接关闭");
    };

//监听窗口关闭事件，当窗口关闭时，主动去关闭WebSocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    };

//关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    //提取接收字符串，转化为Int数组作为判断数据
      function StringToInt(str) {
        var m = str.length/ 2;
        if (m * 2 < str.length) {
            m++;
        }
        var cache=new Array(m);
        var j = 0;
        //字符串切割存入int类型数组
        for (var  i = 0; i < str.length; i++) {
            if (i % 2 == 0) {
                cache[j] = parseInt(str.substring(i, i + 2));
                j++;
            }
        }
        return cache;
    }

