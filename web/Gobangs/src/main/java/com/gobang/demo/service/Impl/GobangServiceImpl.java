package com.gobang.demo.service.Impl;

import com.gobang.demo.dao.Gobang;
import com.gobang.demo.mapper.GobangMapper;
import com.gobang.demo.service.GobangService;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Component
@Service
public class GobangServiceImpl implements GobangService {
    @Resource
    private GobangMapper mapper;
    @Override
    public Gobang findByid(int i) {
        return mapper.selectByPrimaryKey(i);
    }

    @Override
    public void AddGobang(Gobang gobang){
        mapper.insert(gobang);
    }

    @Override
    public List<Gobang>findAll(){
        List<Gobang> list=mapper.selectAll();
        return list;
    }

    @Override
    public int countLine(){
        return mapper.count();
    }

    @Override
    public void restart(){
        mapper.deleteAll();
    }

    @Override
    public List<Gobang>findByStatus(int s){
        return  mapper.selectByStatus(s);
    }

    @Override
    public void deleteById(int i){
        mapper.deleteByPrimaryKey(i);
    }

}
