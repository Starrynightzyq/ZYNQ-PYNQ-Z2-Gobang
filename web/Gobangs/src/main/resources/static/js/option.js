var restart=document.getElementById("restart");
var sendflag=0;//防止重复发送数据
restart.onclick=function(){
    restartfunc();
};

$("#previous").unbind("click").click(function () {
   repentfunc();
});

$("#mention").click(function () {
   mention();
});

//重新开始封装方法
function restartfunc() {
    $.ajax({
        type:"POST",
        url:"/restart?sendflag="+sendflag,
        data:{},
        cache:"false",
        timeout:600000,
        success: function (result) {
            resetPlayer();
            window.location.href="/guide";
            flag=result;
            console.log("flag为"+sendflag);
        }
    });
    // //清空画布
    // context.clearRect(0,0,chess.width,chess.height);
    // //棋盘初始化
    // ChessBoardInitilize();
    // //画布初始化
    // CanvasInitialize();
    // flag=true;
}
function repentfunc() {
    $.ajax({
        type: "POST",
        contentType: "text",
        url: "/previous?sendflag="+sendflag,
        data: {},
        cache:"false",
        timeout: 600000,
        success: function (result) {
           sendflag=result;
        }
    });
    //清空画布
    context.clearRect(0,0,chess.width,chess.height);
    //棋盘初始化
    ChessBoardInitilize();
    //画布初始化
    CanvasInitialize();
    //flag初始化
    flag=true;
}
function mention() {
    $.ajax({
        type: "POST",
        url: "/mention?sendflag="+sendflag,
        data: {},
        cache:"false",
        timeout: 600000,
        success:function (result) {
            sendflag=result;
            console.log(sendflag);
        }
    });
    alert("提示完毕！","您得到了开发者的指引，请继续战斗吧！",function () {

    },{type:'success',confimButtonText:'OK'});
}

//测试alert用
$("#test").click(function () {
    confirm(" 黑子获胜！","是否进入下一难度的挑战？",function (isConfirm) {
        if(isConfirm){
            window.location.href="/gobang";
        }
        else {
            $.ajax({
                type: "POST",
                contentType: "text",
                url: "/restart",
                data: "提示",
                cache:"false",
                timeout: 600000
            });
            window.location.href="/guide";
        }

    },{confirmButtonText:'进入新的挑战',cancelButtonText:'回到选择页面',width:600});
});
