<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/nav.jsp" />
<!-- 게시글상세정보란 시작 -->
<c:set value="${bdto.bvo }" var="bvo"></c:set>
<div class="container my-3">
      <div class="col-md-7 col-lg-8">
        <h4 class="mb-3">Board information</h4>
          <div class="row g-3">

            <div class="col-12">
              <label for="email" class="form-label">Writer</label>
              <div class="input-group has-validation">
                <span class="input-group-text">@</span>
                <input type="email" class="form-control" name="writer"
                id="writer" value="${bvo.writer }" readonly>              
              </div>
            </div>
            
            <div class="col-12">
              <label for="regAt" class="form-label">Reg At</label>
              <input type="text" class="form-control" value="${bvo.regAt }" readOnly>              
            </div>
            <div class="col-12">
              <label for="modAt" class="form-label">Mod At</label>
              <input type="text" class="form-control" value="${bvo.modAt }" readOnly>              
            </div>
            <div class="col-12">
              <label for="readCount" class="form-label">Read Count</label>
              <input type="text" class="form-control" value="${bvo.readCount }" readOnly>              
            </div>
            <div class="col-12">
              <label for="title" class="form-label">Title</label>
              <input type="text" class="form-control" name="title"
               id="title" placeholder="Title" value="${bvo.title }" readOnly>              
            </div>

            <div class="col-12">
              <label for="cont" class="form-label">Content</label>
              <textarea class="form-control" name="content" readOnly
               id="cont" placeholder="Content">${bvo.content }</textarea>              
            </div>
            <!-- 파일 표시란 -->
            <c:set value="${bdto.flist }" var="flist"></c:set>
            <div class="col-12">
            <label for="fi" class="form-label">file</label>
            	<ul class="list-group list-group-flush">
            		<c:forEach items="${flist }" var="fvo">
            			<li class="list-group-item d-flex justify-content-between align-items-start">
            				<c:choose>
            					<c:when test="${fvo.fileType > 0 }">
            						<div>
            							<img alt="없음." src="/upload/${fn:replace(fvo.saveDir,'\\','/')}/${fvo.uuid}_th_${fvo.fileName}">
            						</div>
            					</c:when>
            					<c:otherwise>
            						<div> 
            							<a download="${fvo.fileName }" href="/upload/${fn:replace(fvo.saveDir,'\\','/')}/${fvo.uuid}_th_${fvo.fileName}">
            								
            							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-medical-fill" viewBox="0 0 16 16">
										  <path d="M12 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM8.5 4.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5a.5.5 0 1 1 1 0zM5.5 9h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1 0-1zm0 2h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1 0-1z"/>
										</svg>
            							</a>
            						</div>
            					</c:otherwise>
            				</c:choose>
            				<div class="ms-2 me-auto">
            					<div class="fw-bold"> ${fvo.fileName }</div>
            					<span class="badge bg-secondary rounded-pill">${fvo.fileSize }Byte</span>
            				</div>
            			</li>
            		</c:forEach>
            	</ul>
            </div>
			<sec:authorize access="isAuthenticated()">
			<sec:authentication property="principal.mvo.email" var="authEmail"/>
			<c:if test="${authEmail eq  bvo.writer}">
    	   	<a href="/board/modify?bno=${bvo.bno }" id="modBtn" class="btn btn-outline-warning">MOD</a>
    	   	<a href="/board/remove?bno=${bvo.bno }" id="delBtn" class="btn btn-outline-danger">DEL</a>
    	   	</c:if>
    	   	<a href="/board/list"  class="btn btn-outline-info">LIST</a>
    		</sec:authorize>
        </div>
      </div>
</div>
<!-- 댓글라인 -->
<div class="container">
	<!-- 댓글 등록 라인 -->
	<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.mvo.email" var="authEmail"/>
	<div class="input-group mb-3">
	  <span class="input-group-text" id="cmtWriter">${authEmail }</span>
	  <input type="text" class="form-control" placeholder="Test Comment" id="cmtText">
	  <button type="button" class="btn btn-success" id="cmtPostBtn">Post</button>
	</div>
	</sec:authorize>
	
	<!-- 댓글 표시 라인 -->
	<ul class="list-group list-group-flush" id="cmtListArea">
	  <li class="list-group-item">
	  	<div class="mb-3">
	  		<div class="fw-bold">Wirter</div>
	  		Content
	  	</div>
	  	<span class="badge rounded-pill text-bg-dark">modAt</span>
	  </li>
	  
	</ul>
	<!-- 댓글 페이징 라인 -->
	<div>
		<div>
			<button type="button" id="moreBtn" data-page="1" 
			 class="btn btn-outline-dark" style="visibility:hidden">MORE+</button>
		</div>
	</div>
	<!-- 모달창 라인 -->
	<div class="modal" id="myModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <div class="modal-header">
        <h5 class="modal-title">${authEmail }</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      
      <div class="modal-body">
        <div class="input-group mb-3">
	        <input type="text" class="form-control" placeholder="Test Comment" id="cmtTextMod">
		  	<button type="button" class="btn btn-success" id="cmtModBtn">Post</button>
        </div>
      </div>
      
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

</div>
<script>
let isMod = `<c:out value="${isMod}"/>`;
if (parseInt(isMod)) {
	alert('게시글 수정 성공~');
}
let bnoVal = `<c:out value="${bdto.bvo.bno}" />`;
console.log(bnoVal);

</script>
<script type="text/javascript" src="/resources/js/boardComment.js"></script>
<script type="text/javascript">
getCommentList(bnoVal);
</script>
<jsp:include page="../common/footer.jsp" />
</body>
</html>