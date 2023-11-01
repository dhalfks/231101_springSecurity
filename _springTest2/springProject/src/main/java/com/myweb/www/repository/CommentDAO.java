package com.myweb.www.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myweb.www.domain.CommentVO;
import com.myweb.www.domain.PagingVO;

public interface CommentDAO {

	int post(CommentVO cvo);

	List<CommentVO> getList(long bno);

	int remove(long cno);

	int update(CommentVO cvo);

	int selectOntBnoTotalCount(long bno);

	List<CommentVO> selectListPaging(@Param("bno") long bno, @Param("pgvo") PagingVO pgvo);

	int removeCommentAll(long bno);

}
