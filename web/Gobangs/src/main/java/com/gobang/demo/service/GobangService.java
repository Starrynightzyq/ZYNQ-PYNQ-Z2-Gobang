package com.gobang.demo.service;

import com.gobang.demo.dao.Gobang;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface GobangService {

    public Gobang findByid(int i);
    public void  AddGobang(Gobang gobang);
    public List<Gobang>findAll();
    public int countLine();
    public void restart();
    public List<Gobang>findByStatus(int s);
    public void deleteById(int i);


}
