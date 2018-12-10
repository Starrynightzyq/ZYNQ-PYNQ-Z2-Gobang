var flag=true;
var judge=[];
var chess=document.getElementById('chess');
var context=chess.getContext('2d');//获得绘图环境
var ChessBoard=[];
// 提示次数
// var mentioncount=3;

function ChessBoardInitilize() {
    for (var i = 0; i < 15; i++) {
        ChessBoard[i] = [];
        for (var j = 0; j < 15; j++) {
            ChessBoard[i][j] = 0;
        }
    }
}
ChessBoardInitilize();
//画布初始化
CanvasInitialize();
//封装画布的初始化
function CanvasInitialize() {
    context.strokeStyle = "#BFBFBF";
    //画背景
    var logo = new Image();
    logo.src = "static/img/board.jpg";
    logo.onload = function () {
        context.drawImage(logo, -20, 0, 470, 470);
        drawChessBoard();
    };
    // drawChessBoard();
}

//画棋盘
function drawChessBoard() {
    context.beginPath();
    context.closePath();
	for(var i=0;i<15;i++)
	{
		//画纵线
		context.moveTo(15+30*i,15);
		context.lineTo(15+30*i,435);
		context.stroke();
		//画横线
		context.moveTo(15,15+30*i);
		context.lineTo(435,15+30*i);
		context.stroke();
	}
}

//落子
var oneStep=function(i,j,flag){
	context.beginPath();
	context.arc(15+30*i,15+j*30,13,0,2*Math.PI);//画圆
	context.closePath();
	var gradient=context.createRadialGradient(15+30*i+2,15+j*30-2,13,15+30*i+2,15+j*30-2,0);//设置渐变
	if(flag)
	{
		//画黑子
		gradient.addColorStop(0,"#0A0A0A");
		gradient.addColorStop(1,"#636766");
	}
	else{
		//画白子
		gradient.addColorStop(0,"#D1D1D1");
		gradient.addColorStop(1,"#F9F9F9");
	}
	context.fillStyle="#636766"; //填充颜色
	context.fillStyle=gradient;
	context.fill();
	changePlayer();
};

//websocket接受的数据进行判断
var wschess=function (judge) {
    //下棋状态
    if(judge[0]==6){
        var i = judge[3];
        var j = judge[2];
        if (ChessBoard[i][j] == 0) {
            oneStep(i, j, flag);
            if (flag) {
                ChessBoard[i][j] = 1;//该位置为黑子
            }
            else {
                ChessBoard[i][j] = 2;//该位置为白子
            }
            flag = !flag;
        }
    }
    //最高分提示
    else if (judge[0]==12){
        sendflag=1;
        //触发前端按钮mention方法
        mention();
        var i = judge[3];
        var j = judge[2];
        if (ChessBoard[i][j] == 0) {
            oneStep(i, j, flag);
            if (flag) {
                ChessBoard[i][j] = 1;//该位置为黑子
            }
            else {
                ChessBoard[i][j] = 2;//该位置为白子
            }
            flag = !flag;
        }
        alert("提示完毕！","您得到了开发者的指引，请继续战斗吧！",function () {

        },{type:'success',confimButtonText:'OK'});
    }     //悔棋
    else if (judge[0]==7){
        sendflag=1;
        repentfunc();
        //获胜
    }else if (judge[0]==8){
        if(judge[1]==1){
            confirm(" 黑子获胜！","是否进入下一难度的挑战？",function (isConfirm) {
                if(isConfirm){
                    window.location.href="/gobang";
                }
                else {
                    sendflag=1;
                    $.ajax({
                        type: "POST",
                        url: "/restart?sendflag="+sendflag,
                        data: {},
                        cache:"false",
                        timeout: 600000,
                        success:function (result) {
                            sendflag=result;
                        }
                    });
                    window.location.href="/guide";
                }
                },{confirmButtonText:'进入新的挑战',cancelButtonText:'回到选择页面',width:600});
        } else if(judge[1]==2){
            confirm(" 白子获胜！","是否进入下一难度的挑战？",function (isConfirm) {
                if(isConfirm){
                    window.location.href="/gobang";
                }
                else {
                    $.ajax({
                        type: "POST",
                        url: "/restart?sendflag="+sendflag,
                        data: {},
                        cache:"false",
                        timeout: 600000,
                        success:function (result) {
                            sendflag=result;
                        }
                    });
                    window.location.href="/guide";
                }

            },{confirmButtonText:'进入新的挑战',cancelButtonText:'回到选择页面',width:600});
        }
        //重新开始
    }else if (judge[0]==9){
        sendflag=1;
        restartfunc();
    }
};
   chess.onclick = function (e) {
            var x = e.offsetX;  //相对于原点的坐标
            var y = e.offsetY;
            var i = Math.floor(x / 30);
            var j = Math.floor(y / 30);
            if (ChessBoard[i][j] == 0) {
                oneStep(i, j, flag);
                if (flag) {
                    ChessBoard[i][j] = 1;//该位置为黑子
                    //判断两点的坐标值为一位数或者两位数
                    if(j<10 && i<10) {
                        var str = "0601" + "0" + j.toString() + "0" + i.toString();
                        console.log("1")
                    }
                    else if(j<10 && 10<i<26){
                        str="0601"+"0"+j.toString()+i.toString();
                        console.log("2")
                    }
                    else if(10<j<26&&i<10){
                        str="0601"+j.toString()+"0"+i.toString();
                        console.log("3");
                    }
                    else {
                        str="0601"+j.toString()+i.toString();
                        console.log("4");
                    }

                }
                else {
                    ChessBoard[i][j] = 2;//该位置为白子
                    //同上，判断i j坐标为两位还是一位数
                    if(j<10 && i<10) {
                        var str = "0602" + "0" + j.toString() + "0" + i.toString();
                        console.log("1");
                    }
                    else if(j<10 && 10<i<26){
                        str="0602"+"0"+j.toString()+i.toString();
                        console.log("2");
                    }
                    else if(10<j<26&&i<10){
                        str="0602"+j.toString()+"0"+i.toString();
                        console.log("3");
                    }
                    else {
                        str="0602"+j.toString()+i.toString();
                        console.log("4");
                    }
                }
                websocket.send(str);
                flag = !flag;
            }
        };


// 切换玩家
function changePlayer() {
    let current = $('.player li[class=active]');
    $(current).siblings().addClass('active');
    $(current).removeClass('active')
}

// 重置玩家
function resetPlayer() {
    $('.player li:first').addClass('active');
    $('.player li:last').removeClass('active');
}






