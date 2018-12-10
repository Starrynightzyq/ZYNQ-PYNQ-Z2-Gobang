package com.gobang.demo.mapper;

import com.gobang.demo.dao.Gobang;
import com.gobang.demo.dao.GobangExample;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GobangMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Gobang record);

    int insertSelective(Gobang record);

    Gobang selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Gobang record, @Param("example") GobangExample example);

    int updateByExample(@Param("record") Gobang record, @Param("example") GobangExample example);

    int updateByPrimaryKeySelective(Gobang record);

    int updateByPrimaryKey(Gobang record);

    List<Gobang>selectAll();

    int count();

    void deleteAll();

    List<Gobang>selectByStatus(Integer status);
}