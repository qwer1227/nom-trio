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

        .inquiry-detail, .answer-detail {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .inquiry-detail h3, .answer-detail h3 {
            margin: 0 0 15px;
            font-size: 24px;
            color: #333;
        }

        .inquiry-detail p, .answer-detail p {
            color: #666;
            line-height: 1.5;
        }

        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn-group-left {
            display: flex;
            justify-content: flex-start;
            flex: 1;
        }

        .btn-group-right {
            display: flex;
            justify-content: flex-end;
        }

        .btn-back, .btn-edit, .btn-delete {
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }

        .btn-back {
            background-color: #95a5a6; /* 회색 버튼 */
        }

        .btn-edit {
            background-color: #3498db;
        }

        .btn-delete {
            background-color: #e74c3c;
            border: none; /* 삭제 버튼의 검은색 테두리 제거 */
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/nav.jsp" %>
<div id="wrap">

    <!-- Header -->
    <div class="inquiry-header">
        <h2>문의 상세보기</h2>
    </div>

    <!-- Inquiry Detail -->
    <div class="inquiry-detail">
        <h3>${qna.qnaTitle}</h3>
        <p>${qna.qnaContent}</p>
        <p><strong>작성일:</strong> <fmt:formatDate value="${qna.qnaCreatedDate}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul" /></p>
        <p><strong>문의 상태:</strong> ${qna.qnaStatus}</p>
        <p><strong>카테고리:</strong> ${qna.qnaCategory.categoryName}</p>
    </div>

    <c:if test="${not empty qna.answerUserNo && qna.answerUserNo != 0}">
        <!-- Answer Detail -->
        <div class="answer-detail">
            <h3>답변</h3>
            <p>${qna.answerContent}</p>
            <p><strong>작성일:</strong> <fmt:formatDate value="${qna.answerCreatedDate}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul" /></p>
            <p><strong>답변자:</strong> ${qna.user.nickname}</p>
        </div>
    </c:if>


    <!-- Button Group -->
    <div class="btn-group">
        <!-- Left Side: "목록으로 돌아가기" button -->
        <div class="btn-group-left">
            <a href="/mypage/qna" class="btn-back">목록으로 돌아가기</a>
        </div>

        <!-- Right Side: "수정", "삭제" buttons -->
        <div class="btn-group-right">
            <c:if test="${not empty qna.answerUserNo && qna.answerUserNo == 0}">
                <a href="/mypage/qna/update/${qna.qnaNo}" class="btn-edit">수정</a>
                <form action="/mypage/qna/delete/${qna.qnaNo}" method="post" style="display:inline;">
                    <button type="submit" class="btn-delete">삭제</button>
                </form>
            </c:if>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
