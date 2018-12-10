package com.gobang.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class PageController {
    //
   @RequestMapping(value = "/guide",method = RequestMethod.GET)
    public String ToGuidePage(){
       return "Welcome";
   }
    //首页
    @RequestMapping(value = "/gobang", method = RequestMethod.GET)
    public String gobang() {
        return "index";
    }

}
