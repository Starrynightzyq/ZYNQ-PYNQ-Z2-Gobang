package com.gobang.demo.vo.handler;


import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.DelimiterBasedFrameDecoder;
import io.netty.handler.codec.string.StringEncoder;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
    public class ChildChannelHandler extends ChannelInitializer<SocketChannel> {
        @Resource
        private DiscardServerHandler discardServerHandler;

        public void initChannel(SocketChannel socketChannel) throws Exception {
            socketChannel.pipeline().addLast(new DelimiterBasedFrameDecoder(1024, Unpooled.copiedBuffer("$".getBytes())));
            socketChannel.pipeline().addLast(discardServerHandler);

        }
}

