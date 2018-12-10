package com.gobang.demo.utils;


import com.gobang.demo.dao.Gobang;
import com.gobang.demo.service.GobangService;
import io.netty.buffer.ByteBuf;
import io.netty.util.CharsetUtil;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;


@Component
public class ByteBufDecoder{
    @Resource
    GobangService service;

    //Bytebuf类型转化为Gobang类型
    public void  ByteToGobang(ByteBuf bf, Gobang gobang) {
        //Bytebuf转字符串
        String dat = bf.toString(CharsetUtil.UTF_8);
        //将字符串转换为Gobang
        StrToGobang(dat,new Gobang());
    }
    public static byte[] IntToByte(int a){
        byte[] src = new byte[4];
        src[0] = (byte) ((a>>24) & 0xFF);
        src[1] = (byte) ((a>>16)& 0xFF);
        src[2] = (byte) ((a>>8)&0xFF);
        src[3] = (byte) (a & 0xFF);
        return src;
    }
   public static int[] StringToInt( String str){
        int m = str.length() / 2;
        if (m * 2 < str.length()) {
            m++;
        }
        int[] cache = new int[m];
        int j = 0;
        //字符串切割存入int类型数组
        for (int i = 0; i < str.length(); i++) {
            if (i % 2 == 0) {
                cache[j] = Integer.parseInt(str.substring(i, i + 2));
                j++;
            }
        }
        return cache;
    }
    public static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder();
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
            stringBuilder.append(' ');
        }
        return stringBuilder.toString();
    }

    protected static byte[] combine2Byte(byte[] bt1, byte[] bt2){
        byte[] byteResult = new byte[bt1.length+bt2.length];
        System.arraycopy(bt1, 0, byteResult, 0, bt1.length);
        System.arraycopy(bt2, 0, byteResult, bt1.length, bt2.length);
        return byteResult;
    }

    public void StrToGobang(String str, Gobang gobang){
       int cache1[]=StringToInt(str);
        //给gobang赋值，写入数据库
        gobang.setStatus(cache1[0]);
        gobang.setColor(cache1[1]);
        gobang.setCoordinatey(cache1[2]);
        gobang.setCoordinatex(cache1[3]);
        service.AddGobang(gobang);
        System.out.println("测试");
    }


    public String GobangToStr(Gobang gobang){
        //最终生成的字符串类型
        String str="";
        //status属性的字符串，需要判断是一位还是两位数
        String str1;
        if (gobang.getStatus()/10!=1)
        {
           str1="0"+gobang.getStatus().toString();
        }
        else{
            str1=gobang.getStatus().toString();
        }
        //color 属性的字符串
        String str2="0"+gobang.getColor().toString();

        //Y轴坐标(需要判断是一位还是两位)
        String str3;
        if(gobang.getCoordinatey()/10==0){
           str3="0"+gobang.getCoordinatey().toString();
        }
        else {
            str3 = gobang.getCoordinatey().toString();
        }

        //X轴坐标（需要判断是一位还是两位）
        String str4;
        if(gobang.getCoordinatex()/10==0){
            str4="0"+gobang.getCoordinatex().toString();
        }
        else {
            str4 = gobang.getCoordinatex().toString();
        }

        str=str1+str2+str3+str4;
        return str;
    }

    public String RepentStr(Gobang gobang){
        //最终生成的字符串类型
        String str="";
        //status属性的字符串，需要判断是一位还是两位数
        String str1;
        str1="07";
        //color 属性的字符串
        String str2="0"+gobang.getColor().toString();

        //Y轴坐标(需要判断是一位还是两位)
        String str3;
        if(gobang.getCoordinatey()/10==0){
            str3="0"+gobang.getCoordinatey().toString();
        }
        else {
            str3 = gobang.getCoordinatey().toString();
        }

        //X轴坐标（需要判断是一位还是两位）
        String str4;
        if(gobang.getCoordinatex()/10==0){
            str4="0"+gobang.getCoordinatex().toString();
        }
        else {
            str4 = gobang.getCoordinatex().toString();
        }

        str=str1+str2+str3+str4;
        return str;
    }


}
