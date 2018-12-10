package com.gobang.demo.utils;

import io.netty.channel.Channel;
import org.springframework.stereotype.Component;

import java.util.HashMap;

@Component
public class ChannelHashmap {
    private static int hashnum=0;
    private static HashMap<String, Channel> channelHashMap=null;
    //获得hashmap
    public  static HashMap<String,Channel>getHashMap(){
        return  channelHashMap;
    }
    //通过name获得对应的channel
    public  static Channel  getChannelByName(String name){
        if (channelHashMap==null){
            System.out.println("channelhashmap 找不到啊");
            return  null;
        }
        else {
            return channelHashMap.get(name);
        }
    }
    //添加新的channel
    public  static  void addChannel(String name, Channel channel){
        if(channelHashMap==null){
            channelHashMap=new HashMap<>(100);
            System.out.println("加了一个新的到hashmap");
        }
        else{
            channelHashMap.put(name,channel);
            hashnum++;

        }
    }
    public static int removeChannelByName(String name){
        if(channelHashMap.containsKey(name)){
            channelHashMap.remove(name);
            return 0;
        }
        else {
            return 1;
        }
    }



}
