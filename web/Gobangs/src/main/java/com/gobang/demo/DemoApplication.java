package com.gobang.demo;

import com.gobang.demo.vo.GobangServer;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.web.socket.config.annotation.EnableWebSocket;

import javax.annotation.Resource;

@SpringBootApplication
@MapperScan(basePackages = "com.gobang.demo.mapper")
@ServletComponentScan
@EnableWebSocket
public class DemoApplication implements CommandLineRunner {

    @Resource
    GobangServer gobangServer;


    public static void main(String[] args) throws Exception {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        gobangServer.run(8088);
    }
}
