package com.gobang.demo.utils;

import io.netty.buffer.Unpooled;
import io.netty.channel.Channel;
import io.netty.util.CharsetUtil;
import org.springframework.stereotype.Component;


@Component
public class ChannelSend {
    public void sendToFPGA(String str) {
        Channel channel = ChannelHashmap.getChannelByName("demo");
        System.out.println(ChannelHashmap.getChannelByName("demo"));
        if (channel == null) {
            System.out.println("TCP channel null啦");
        } else {
            if (channel.isActive()) {
                System.out.println(channel.isActive());
                channel.writeAndFlush(Unpooled.copiedBuffer(str, CharsetUtil.UTF_8));
            } else {
                System.out.println("连接关闭了");
            }
        }
    }
}
