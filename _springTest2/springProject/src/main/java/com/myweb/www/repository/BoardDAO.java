package com.myweb.www.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myweb.www.domain.BoardVO;
import com.myweb.www.domain.PagingVO;

public interface BoardDAO {

	int insert(BoardVO bvo);

	List<BoardVO> getList(PagingVO pagingVO);

	BoardVO getDetail(long bno);

	int update(BoardVO bvo);

	int delete(long bno);

	void readCount(@Param("bno")long bno, @Param("cnt")int cnt);

	int getTotalCount(PagingVO pagingVO);

	long selectOneBno();

	int updateCommentCount();

	int updateFileCount();

}
