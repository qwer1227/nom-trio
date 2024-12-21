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
            max-width: 800px;
            margin: 30px auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-submit {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .btn-cancel {
            background-color: #e74c3c;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .btn-modify,
        .btn-delete {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .btn-modify {
            background-color: #3498db;
        }

        .btn-delete {
            background-color: #e74c3c;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/nav.jsp" %>
<div id="wrap">
    <h2>${qna.qnaNo != null ? '문의 수정' : '문의 작성'}</h2>
    <c:set value="/mypage/qna/update/${qna.qnaNo}" var="update" />
    <form action="${qna.qnaNo != null ? update : '/mypage/qna/create'}" method="post">
        <!-- 문의 카테고리 -->
        <div class="form-group">
            <label for="category">카테고리</label>
            <select id="category" name="categoryNo">
                <option value="1" <c:if test="${qna.qnaCategory.categoryNo == 1}">selected</c:if>>대여</option>
                <option value="2" <c:if test="${qna.qnaCategory.categoryNo == 2}">selected</c:if>>주문</option>
                <option value="3" <c:if test="${qna.qnaCategory.categoryNo == 3}">selected</c:if>>레슨</option>
                <option value="4" <c:if test="${qna.qnaCategory.categoryNo == 4}">selected</c:if>>건의</option>
            </select>
        </div>

        <!-- 제목 입력 -->
        <div class="form-group">
            <label for="qnaTitle">제목</label>
            <input type="text" id="qnaTitle" name="qnaTitle" value="${qna.qnaTitle != null ? qna.qnaTitle : ''}" placeholder="제목을 입력해주세요" required>
        </div>

        <!-- 내용 입력 -->
        <div class="form-group">
            <label for="qnaContent">내용</label>
            <textarea id="qnaContent" name="qnaContent" placeholder="문의 내용을 작성해주세요" required>${qna.qnaContent != null ? qna.qnaContent : ''}</textarea>
        </div>


        <c:if test="${isPosting}">
        <!-- 버튼 -->
        <div class="form-actions">
            <a href="/mypage/qna" class="btn-cancel">목록으로 돌아가기</a>
            <button type="submit" class="btn-submit">작성 완료</button>
        </div>
        </c:if>

        <%--<!-- 수정 시 수정 및 삭제 버튼 추가 -->
        <c:if test="${qna.qnaNo != null}">
            <div class="form-actions">
                <a href="/mypage/qna/update/${qna.qnaNo}" class="btn-modify">수정</a>
                <a href="/mypage/qna/delete/${qna.qnaNo}" class="btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
            </div>
        </c:if>--%>

        <!-- 수정 폼에서는 목록으로 돌아가기와 수정 완료 버튼만 표시 -->
        <c:if test="${isUpdating}">
            <div class="form-actions">
                <a href="/mypage/qna" class="btn-cancel">목록으로 돌아가기</a>
                <button type="submit" class="btn-modify">수정 완료</button>
            </div>
        </c:if>
    </form>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
