package com.gobang.demo.ws;

import com.gobang.demo.dao.Gobang;
import com.gobang.demo.utils.ByteBufDecoder;
import com.gobang.demo.utils.ChannelSend;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

@Component
@ServerEndpoint("/websocket")
//1. 实现ApplicationContextAware接口
public class WebsocketChess implements ApplicationContextAware {

    //2. 创建容器上下文
    private static ApplicationContext applicationContext;

    //3. 填充容器上下文
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext=applicationContext;
    }

    @Resource
    ChannelSend channelSend;
    @Resource
    ByteBufDecoder decoder;
  /*  @Resource
    Gobang gobang;*/
    private static CopyOnWriteArraySet<WebsocketChess> webSocketSet = new CopyOnWriteArraySet<WebsocketChess>();
    private Session session ;




    //开启连接时的操作
    @OnOpen
    public void onOpen(Session session)  {
        this.session = session;
        System.out.println("session的内容是"+session);
        webSocketSet.add(this);
        System.out.println(webSocketSet);
    }

    /**
     * @ClassName: onClose
     * @Description: 连接关闭的操作
     */
    @OnClose
    public void onClose() {
        webSocketSet.remove(this);
    }

    /**
     * @ClassName: onMessage
     * @Description: 接收到客户端消息的回调函数
     */
    @OnMessage
    public void onMessage(String str) {
        ByteBufDecoder bean = applicationContext.getBean(ByteBufDecoder.class);
        bean.StrToGobang(str,new Gobang());
        ChannelSend send=applicationContext.getBean(ChannelSend.class);
        String string=str+"$";
        send.sendToFPGA(string);
        /*System.out.println("发生变化" + str);
        // decoder.StrToGobang(string,new Gobang());
        if (decoder == null) {
            System.out.println("decoder null啦");
        } else {
            decoder.StrToGobang(str, gobang);
        }
        if (channelSend == null) {
            System.out.println("channelsend null 啦");
        } else {
            channelSend.sendToFPGA(str);
        }*/
    }

    /**
     * @ClassName: OnError
     * @Description: 出错的操作
     */
    @OnError
    public void onError(Throwable error) {
        System.out.println(error);
        error.printStackTrace();
    }
    /*
    自定义sendmessage方法用于群发消息
     */
    public void sendMessage(String str) throws IOException {
       for (WebsocketChess ws: webSocketSet){
           ws.session.getBasicRemote().sendText(str);
           //System.out.println(ws.session);
       }
    }


}
