package com.gobang.demo.vo.handler;

import com.gobang.demo.dao.Gobang;
import com.gobang.demo.utils.ByteBufDecoder;
import com.gobang.demo.utils.ChannelHashmap;
import com.gobang.demo.ws.WebsocketChess;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerAdapter;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.CharsetUtil;
import io.netty.util.ReferenceCountUtil;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.io.IOException;

@Component
@ChannelHandler.Sharable
public class DiscardServerHandler extends ChannelInboundHandlerAdapter {
    @Resource
    ByteBufDecoder decoder;
    @Resource
    WebsocketChess ws;

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {

        try {
            ByteBuf in = (ByteBuf) msg;
            System.out.println("传输内容是");
            System.out.println(in.toString(CharsetUtil.UTF_8));
            //websocket前端发送数据
            ws.sendMessage(in.toString(CharsetUtil.UTF_8));
            decoder.ByteToGobang(in, new Gobang());
            ChannelHashmap.addChannel("demo", ctx.channel());
            System.out.println(ChannelHashmap.getChannelByName("demo"));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            //释放
            ReferenceCountUtil.release(msg);
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        // 出现异常就关闭
        cause.printStackTrace();
        ctx.close();
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) {

    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) {
        ChannelHashmap.removeChannelByName("demo");
    }


}
   