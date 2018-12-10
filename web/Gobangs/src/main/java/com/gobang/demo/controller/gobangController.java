package com.gobang.demo.controller;

import com.gobang.demo.dao.Gobang;
import com.gobang.demo.service.GobangService;
import com.gobang.demo.utils.ByteBufDecoder;
import com.gobang.demo.utils.ChannelSend;
import com.gobang.demo.ws.WebsocketChess;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Controller
public class gobangController {
    @Resource
    GobangService service;
    @Resource
    WebsocketChess ws;
    @Resource
    ByteBufDecoder decoder;
    @Resource
    ChannelSend channelSend;

    //悔棋事件
    @PostMapping(value = "/previous")
    @ResponseBody
    public String PreviousChess(String sendflag) throws IOException {
        int flag=Integer.parseInt(sendflag);
        if (flag==0) {
            Gobang max2 = QueryGobang();
            Gobang max3 = QueryGobang();
            //发送剩余棋子
            ChangedGobang();
            //发送数据到下位机
            channelSend.sendToFPGA(decoder.RepentStr(max2) + "$");
        }else if (flag==1){
            Gobang max2 = QueryGobang();
            Gobang max3 = QueryGobang();
            //发送剩余棋子
            ChangedGobang();
            flag=0;
        }
        return Integer.toString(flag);
//        List<Gobang> changedlist=service.findByStatus(6);
//        for(int i=0;i<changedlist.size();i++){
//            Gobang gobang=changedlist.get(i);
//            String string=decoder.GobangToStr(gobang);
//            ws.sendMessage(string);
//        }
//
    }

    //提示当前最有价值的棋子
    @PostMapping(value = "/mention")
    @ResponseBody
    public String mentionChess(String sendflag) {
        int flag=Integer.parseInt(sendflag);
        if (flag==0) {
            channelSend.sendToFPGA("12000000$");
        }
        else if (flag==1){
            flag=0;
        }
        return Integer.toString(flag);

    }

    //进入比赛
    @PostMapping(value = "/start")
    @ResponseBody
    public String  StartGame(String sendflag){
        int flag1=Integer.parseInt(sendflag);
        if (flag1==0) {
            channelSend.sendToFPGA("10000000$");
        }else if (flag1==1){
            flag1=0;
        }
        return Integer.toString(flag1);
    }

    //重新开始比赛，清空db和主键,同时回到引导页
    @PostMapping(value = "/restart")
    @ResponseBody
    public String returnGuide(String sendflag){
        service.restart();
        int flag1=Integer.parseInt(sendflag);
        System.out.println(flag1);
        if(flag1==0){
            channelSend.sendToFPGA("09000000$");
        }else if (flag1==1){
            flag1=0;
        }
        return Integer.toString(flag1);
    }

    //AI vs AI 测试
    @PostMapping(value = "/count0")
    @ResponseBody
    public void count0(){
        channelSend.sendToFPGA("05000000$");
    }

    //人机对战白子先行
    @PostMapping(value = "/count1")
    @ResponseBody
    public void count1(){
        channelSend.sendToFPGA("01020000$");
    }

    //人机对战黑子先行
    @PostMapping(value = "/count2")
    @ResponseBody
    public void count2(){
        channelSend.sendToFPGA("01010000$");
    }

    //人人对战
    @PostMapping(value = "/count3")
    @ResponseBody
    public void count3(){
        channelSend.sendToFPGA("04000000$");
    }

    public Gobang QueryGobang(){
        List<Gobang> list = service.findByStatus(6);
        Optional<Gobang> opt = list.stream().max(Comparator.comparingInt(Gobang::getId));
        Gobang max1 = opt.get();//打印最大值
        service.deleteById(max1.getId());//删除该项
        return max1;
    }

    //遍历悔棋后的数据库并将剩余的棋子全部发送到前端
    public void ChangedGobang() throws IOException {
        List<Gobang> changedlist=service.findByStatus(6);
        for(int i=0;i<changedlist.size();i++){
            Gobang gobang=changedlist.get(i);
            String string=decoder.GobangToStr(gobang);
            ws.sendMessage(string);
        }
    }


}
