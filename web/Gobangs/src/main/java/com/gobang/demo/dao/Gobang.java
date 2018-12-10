package com.gobang.demo.dao;

import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Date;

@Component
public class Gobang implements Serializable {
    private Integer id;

    private Integer status;

    private Integer color;

    private Integer coordinatey;

    private Integer coordinatex;

    private Date createtime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getColor() {
        return color;
    }

    public void setColor(Integer color) {
        this.color = color;
    }

    public Integer getCoordinatey() {
        return coordinatey;
    }

    public void setCoordinatey(Integer coordinatey) {
        this.coordinatey = coordinatey;
    }

    public Integer getCoordinatex() {
        return coordinatex;
    }

    public void setCoordinatex(Integer coordinatex) {
        this.coordinatex = coordinatex;
    }

    public Date getCreatetime() {
        return createtime;
    }

    public void setCreatetime(Date createtime) {
        this.createtime = createtime;
    }

    public void InitialGobang(Integer id,Integer color,Integer status,Integer coordinatey,Integer coordinatex){
        this.id=id;
        this.color=color;
        this.status=status;
        this.coordinatey=coordinatey;
        this.coordinatex=coordinatex;
    }
}