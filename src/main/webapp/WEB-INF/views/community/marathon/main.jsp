<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
	<%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
    .category-nav a {
        font-size: 20px;
        font-weight: bolder;
        color: #0064FF;
        padding: 10px 20px;
        border: 2px solid #0064FF;
        border-radius: 5px;
        text-decoration: none;
        margin: 0 10px;
    }

    .category-nav a:hover {
        background-color: #0064FF;
        color: white;
    }

    .overlay-text {
        position: absolute; /* 부모 기준으로 절대 위치 설정 */
        top: 40%; /* 컨테이너의 세로 중심 */
        left: 50%; /* 컨테이너의 가로 중심 */
        transform: translate(-50%, -50%); /* 정확히 중앙으로 이동 */
        color: white; /* 텍스트 색상 */
        font-size: 1.5rem; /* 텍스트 크기 */
        font-weight: bold; /* 텍스트 굵기 */
        text-align: center; /* 텍스트 가운데 정렬 */
        background-color: rgba(0, 0, 0, 0.5); /* 텍스트 배경 반투명 설정 */
        padding: 10px; /* 텍스트 주변 여백 추가 */
        border-radius: 5px; /* 배경의 모서리 둥글게 처리 (선택 사항) */
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
	
	<h2> 마라톤 정보 </h2>
	
	<form id="form-search" method="get" action="main">
		<input type="hidden" name="page" value="${param.page != null ? param.page : 1}">
		<input type="hidden" name="category" id="categoryInput" value="${param.category }">
		
		<div class="category-nav d-flex justify-content-center mb-4">
			<a href="main">전체</a>
			<a href="javascript:void(0)" onclick="changeCategory('진행중')">접수가능</a>
			<a href="javascript:void(0)" onclick="changeCategory('종료')">종료</a>
		</div>
		
		<c:choose>
			<c:when test="${empty marathons}">
				<div class="col p-5" style="justify-content: center; text-align: center;">
					<strong>해당 검색 조건에 해당하는 마라톤 정보가 없습니다.</strong>
				</div>
			</c:when>
			<c:otherwise>
				<div class="row row-cols-1 row-cols-md-3 g-4">
					<!-- 카드 1 -->
					<c:forEach var="marathon" items="${marathons}">
						<div class="col">
							<a href="hit?no=${marathon.no}" style="text-decoration-line: none">
								<div class="card">
									<img src="${marathon.thumbnail}" class="card-img-top" alt="마라톤 이미지"
											 style="height: 200px; filter: ${marathon.marathonDate.time > now.time ? 'grayscale(0%)' : 'grayscale(100%)'};">
									<c:if test="${marathon.marathonDate.time < now.time}">
										<div class="overlay-text ">종료</div>
									</c:if>
									<div class="card-body text-center">
										<h5 class="card-title">${marathon.title}</h5>
										<p class="card-text"><fmt:formatDate value="${marathon.marathonDate}" pattern="yyyy-MM-dd"/></p>
									</div>
								</div>
							</a>
						</div>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
		
		<c:if test="${paging.totalRows > 6}">
			<div class="mt-3">
				<ul class="pagination justify-content-center">
					<li class="page-item ${paging.first ? 'disabled' : '' }">
						<a class="page-link"
							 onclick="changePage(${paging.prevPage}, event)"
							 href="javascript:void(0)"><<</a>
					</li>
					
					<c:forEach var="num" begin="${paging.beginPage }" end="${paging.endPage }">
						<li class="page-item ${paging.page eq num ? 'active' : '' }">
							<a class="page-link"
								 onclick="changePage(${num }, event)"
								 href="javascript:void(0)">${num }</a>
						</li>
					</c:forEach>
					
					<li class="page-item ${paging.last ? 'disabled' : '' }">
						<a class="page-link"
							 onclick="changePage(${paging.nextPage}, event)"
							 href="javascript:void(0)">>></a>
					</li>
				</ul>
			</div>
		</c:if>
		
		<div class="row p-3 d-flex justify-content-left">
			<div class="col-2">
				<select class="form-control" name="opt">
					<option value="all" ${param.opt eq 'all' ? 'selected' : ''}> 제목+내용</option>
					<option value="title" ${param.opt eq 'title' ? 'selected' : ''}> 제목</option>
					<option value="content" ${param.opt eq 'content' ? 'selected' : ''}> 내용</option>
					<option value="organ" ${param.opt eq 'organ' ? 'selected' : ''}> 주최/주관 기관</option>
				</select>
			</div>
			<div class="col-4">
				<input type="text" class="form-control" name="keyword" value="${param.keyword}">
			</div>
			<div class="col-1">
				<button class="btn btn-outline-primary" onclick="searchKeyword()">검색</button>
			</div>
			<div class="col d-flex justify-content-center"></div>
			<div class="col d-flex justify-content-end">
				<security:authorize access="isAuthenticated()">
					<security:authentication property="principal" var="loginUser"/>
					<c:if test="${loginUser.nickname eq '관리자'}">
						<a href="form" type="button" class="btn btn-primary">글쓰기</a>
					</c:if>
				</security:authorize>
			</div>
		</div>
	</form>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
    function changeCategory(category) {
        let form = document.querySelector("#form-search");
        let catInput = document.querySelector("#categoryInput");
        let pageInput = document.querySelector("input[name=page]");

        catInput.value = category;
        pageInput.value = 1;

        form.submit();
    }

    function changePage(page, event) {
        event.preventDefault();
        let form = document.querySelector("#form-search");
        let pageInput = form.querySelector("input[name=page]");
        pageInput.value = page;
        form.submit();
    }

    function searchKeyword() {
        pageInput.value = 1;
        form.submit();
    }
</script>
</html>