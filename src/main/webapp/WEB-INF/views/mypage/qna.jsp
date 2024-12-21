<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        #wrap {
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
        }

        .inquiry-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .category-tabs {
            display: flex;
            gap: 15px;
        }

        .category-tab {
            padding: 10px 20px;
            background-color: #f0f0f0;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            cursor: pointer;
        }

        .category-tab.active {
            background-color: #3498db;
            color: white;
        }

        .inquiry-list {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .inquiry-item {
            padding: 5px ;
            border-bottom: 1px solid #e0e0e0;
        }

        .inquiry-item:last-child {
            border-bottom: none;
        }

        .inquiry-item h4 {
            margin: 0 0 5px;
            font-size: 18px;
            color: #333;
        }

        .inquiry-item p {
            margin: 0;
            color: #666;
        }

        .no-inquiry {
            text-align: center;
            color: #888;
            padding: 20px 0;
        }

        .btn-detail {
            background-color: #3498db;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-create {
            background-color: #27ae60;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 20px;
            display: block;
            width: fit-content;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 10px;
        }

        .btn-pagination {
            background-color: #f0f0f0;
            color: #333;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-pagination.active {
            background-color: #3498db;
            color: white;
        }

        .btn-pagination:hover {
            background-color: #3498db;
            color: white;
        }

        .search-form {
            margin-bottom: 20px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 10px;
        }

        .search-select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        .search-input {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            width: 200px;
            font-size: 14px;
        }

        .btn-search {
            padding: 8px 15px;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-search:hover {
            background-color: #2980b9;
        }

    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/nav.jsp" %>
<div id="wrap">

    <!-- Header -->
    <div class="inquiry-header">
        <h2>문의 내역</h2>
        <div class="category-tabs">
            <a href=/mypage/qna class="category-tab">전체</a>
            <a href="?category=대여&opt=${param.opt}&keyword=${param.keyword}&page=1"
               class="category-tab ${param.category == '대여' ? 'active' : ''}">대여</a>
            <a href="?category=주문&opt=${param.opt}&keyword=${param.keyword}&page=1"
               class="category-tab ${param.category == '주문' ? 'active' : ''}">주문</a>
            <a href="?category=레슨&opt=${param.opt}&keyword=${param.keyword}&page=1"
               class="category-tab ${param.category == '레슨' ? 'active' : ''}">레슨</a>
            <a href="?category=건의&opt=${param.opt}&keyword=${param.keyword}&page=1"
               class="category-tab ${param.category == '건의' ? 'active' : ''}">건의</a>
        </div>
    </div>

    <!-- 검색 폼 -->
    <div class="search-form">
        <form action="/mypage/qna" method="get">
            <div>
                <select name="opt" class="search-select">
                    <option value="title" ${param.opt == 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${param.opt == 'content' ? 'selected' : ''}>내용</option>
                </select>
                <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요"
                       value="${param.keyword}">
                <button type="submit" class="btn-search">검색</button>
            </div>
        </form>
    </div>

    <!-- Inquiry List -->
    <div class="inquiry-list">
        <c:if test="${empty qna}">
            <div class="no-inquiry">등록된 문의가 없습니다.</div>
        </c:if>
        <c:forEach var="qna" items="${qna}">
            <div class="inquiry-item">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="qna-title">${qna.qnaTitle}</h4>
                    <a href="qna/detail/${qna.qnaNo}" class="btn-detail">상세보기</a>
                </div>
                <p>${qna.qnaContent}</p>
                <c:choose>
                    <c:when test="${qna.qnaUpdatedDate != null}">
                        <p><small><fmt:formatDate value="${qna.qnaUpdatedDate}" pattern="yyyy-MM-dd"
                                                  timeZone="Asia/Seoul"/></small></p>
                    </c:when>
                    <c:otherwise>
                        <p><small><fmt:formatDate value="${qna.qnaCreatedDate}" pattern="yyyy-MM-dd"
                                                  timeZone="Asia/Seoul"/></small></p>
                    </c:otherwise>
                </c:choose>
                <br>
            </div>
        </c:forEach>

        <!-- Pagination -->
        <nav aria-label="Page navigation example">
            <ul class="pagination justify-content-center">

                <!-- "이전" 버튼 -->
                <c:if test="${pagination.first}">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>
                <c:if test="${!pagination.first}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${pagination.prevPage}&opt=${param.opt}&keyword=${param.keyword}"
                           aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>

                <!-- 페이지 번호 -->
                <c:forEach var="pageNum" begin="${pagination.beginPage}" end="${pagination.endPage}">
                    <li class="page-item ${pageNum == pagination.page ? 'active' : ''}">
                        <a class="page-link"
                           href="?page=${pageNum}&opt=${param.opt}&keyword=${param.keyword}">
                                ${pageNum}
                        </a>
                    </li>
                </c:forEach>

                <!-- "다음" 버튼 -->
                <c:if test="${pagination.last}">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
                <c:if test="${!pagination.last}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${pagination.nextPage}&opt=${param.opt}&keyword=${param.keyword}"
                           aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>

            </ul>
        </nav>
    </div>

    <!-- 문의 작성 버튼 -->
    <a href="/mypage/qna/create" class="btn-create">문의 작성</a>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
