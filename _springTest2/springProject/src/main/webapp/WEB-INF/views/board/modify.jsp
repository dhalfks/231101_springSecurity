<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/nav.jsp" />
<!-- 게시글 편집란 시작 -->
<c:set value="${bdto.bvo }" var="bvo" />
<div class="container my-3">
      <div class="col-md-7 col-lg-8">
        <h4 class="mb-3">Board information Modify</h4>
        <form action="/board/modify" method="post" enctype="multipart/form-data">
        <input type="hidden" name="bno" value="${bvo.bno }">
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
               id="title" placeholder="Title" value="${bvo.title }" >              
            </div>

            <div class="col-12">
              <label for="cont" class="form-label">Content</label>
              <textarea class="form-control" name="content" 
               id="cont" placeholder="Content">${bvo.content }</textarea>              
            </div>
            
            <!-- 새파일 등록 라인 -->
            
            <div class="mb-3">
			  <input type="file" class="form-control" name="files" id="files" style="display:none;" multiple="multiple">
			  <!-- input button trigger 용도의 button -->
			  <button type="button" id="trigger" class="btn btn-outline-primary">File Upload</button>
			</div>
			<div class="mb-3" id="fileZone">
				<!-- 첨부파일 표시될 영역 -->
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
            							<!-- file 아이콘 추가 -->
            						</div>
            					</c:otherwise>
            				</c:choose>
            				<div class="ms-2 me-auto">
            					<div class="fw-bold"> ${fvo.fileName }</div>
            					<span class="badge bg-secondary rounded-pill">${fvo.fileSize }Byte</span>
            					<button type="button" data-uuid="${fvo.uuid }" class="btn btn-sm btn-danger py-0 file-x">X</button>
            				</div>
            			</li>
            		</c:forEach>
            	</ul>
            </div>

    		<button type="submit" class="btn btn-outline-warning" id="regBtn">Submit</button>
        </div>
        </form>
      </div>
</div>
<script type="text/javascript" src="/resources/js/boardModify.js"></script>
<script type="text/javascript" src="/resources/js/boardRegister.js"></script>
<jsp:include page="../common/footer.jsp" />
</body>
</html>