<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
	<%@include file="/WEB-INF/views/common/common.jsp" %>

</head>
<style>
    /* 툴팁 스타일 (처음에는 숨겨져 있음) */
    #hover-box {
        display: none; /* 기본적으로 툴팁 숨김 */
        position: absolute;
        top: 100%; /* 버튼 바로 아래에 위치 */
        right: 0%;
        transform: translateX(-50%); /* 툴팁을 버튼의 중앙에 맞춤 */
        background-color: rgba(0, 0, 0, 0.7); /* 배경 색상 */
        color: white; /* 글씨 색상 */
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        white-space: nowrap; /* 내용이 길어도 줄바꿈 하지 않음 */
        z-index: 10; /* 툴팁을 다른 요소 위에 표시 */
    }

    /* 버튼에 마우스를 올렸을 때 툴팁 표시 */
    .btn-outline-primary:hover + #hover-box {
        display: block;
    }

    /* 툴팁이 나타날 때 다른 콘텐츠가 영향을 받지 않도록 */
    #fileDown:hover {
        z-index: 20; /* 버튼과 툴팁 위로 다른 요소들이 오지 않도록 설정 */
        position: relative; /* 툴팁을 버튼을 기준으로 설정 */
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
	
	<h2> 공지사항 글 상세 </h2>
	
	<div>
		<div class="col d-flex justify-content-left">
			<div>
				<a href="main" style="text-decoration-line: none">공지사항</a>
			</div>
		</div>
		<div class="title h4 d-flex justify-content-between align-items-center">
			<div>
				${notice.title}
			</div>
			<span><i class="bi bi-eye"></i> ${notice.viewCnt}</span>
		</div>
		<div class="meta d-flex justify-content-between">
			<fmt:formatDate value="${notice.createdDate}" pattern="yyyy.MM.dd hh:mm:ss"/>
			
			<c:if test="${not empty notice.uploadFile.originalName}">
				<div class="content mb-4" id="fileDown" style="text-align: end">
					<a href="filedown?no=${notice.no}" class="btn btn-outline-primary btn-sm">첨부파일 다운로드</a>
					<span id="hover-box">${notice.uploadFile.originalName}</span>
				</div>
			</c:if>
		</div>
		
		<div style="margin-top: 10px; border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
		
		<div class="content m-3" style="text-align: start">
			<p>${notice.content}</p>
		</div>
		
		<div style="border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
		
		<div class="actions d-flex justify-content-between mb-4">
			<div>
				<security:authorize access="isAuthenticated()">
					<security:authentication property="principal" var="loginUser"/>
					<c:if test="${loginUser.nickname eq '관리자'}">
						<!-- 관리자만 볼 수 있는 버튼 -->
						<button class="btn btn-warning" onclick="updateNotice(${notice.no})">수정</button>
						<button class="btn btn-danger" onclick="deleteNotice(${notice.no})">삭제</button>
					</c:if>
				</security:authorize>
			</div>
			<div>
				<a type="button" href="main" class="btn btn-secondary">목록</a>
			</div>
		</div>
	</div>
	<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">
    let content = document.getElementById("content");
    if (content) {
        content.style.height = 'auto'
        content.style.height = content.scrollHeight + 'px';
    }

    function updateNotice(noticeNo) {
        let result = confirm("해당 공지사항을 수정하시겠습니까?");
        if (result) {
            window.location.href = "modify?no=" + noticeNo;
        }
    }

    function deleteNotice(noticeNo) {
        let result = confirm("해당 공지사항을 삭제하시겠습니까?");
        if (result) {
            window.location.href = "delete?no=" + noticeNo;
        }
    }
</script>
</html>