<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <title>쪽지 작성</title></head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">

    <h2> 쪽지 상세 </h2>

    <div>
        <div class="col d-flex justify-content-left">
            <div>
                <a href="" style="text-decoration-line: none">쪽지 상세</a>
            </div>
        </div>
        <div class="title h4 d-flex justify-content-left">
            <div>
                ${message.title}
            </div>
        </div>
        <!-- 보낸사람과 날짜 사이에 공백 추가 -->
        <div class="meta d-flex justify-content-left mb-3">
            <span>보낸사람: ${message.senderNickname}</span>
            <span class="mx-2">/</span> <!-- 공백 역할을 하는 클래스 추가 -->
            <span>날짜: <fmt:formatDate value="${message.createdDate}" pattern="yyyy-MM-dd"/></span>
        </div>

        <!-- 내용 좌측 정렬 -->
        <div class="content mb-4 text-start">
            <p>${message.content}</p>
        </div>

        <!-- 첨부파일과 다운로드 버튼을 한 줄로 배치 -->
        <c:if test="${not empty message.messageFile.savedName}">
            <div class="content mb-4 text-start d-flex align-items-center">
                <span>첨부파일: ${message.messageFile.originalName}</span>
                <a href="/message/download?no=${message.messageNo}" class="btn btn-outline-dark btn-sm ms-2">
                    다운로드
                </a>
            </div>
        </c:if>

        <div class="actions d-flex justify-content-end mb-4">
            <div>
                <!-- 삭제 버튼 -->
                <form action="/message/delete" method="post" style="display: inline;">
                    <input type="hidden" name="messageNo" value="${message.messageNo}"/>
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>

                <!-- 답장 버튼 -->
                <a type="button" href="/message/add?receiver=${message.senderNickname}"
                   class="btn btn-outline-dark">답장</a>

                <!-- 목록 버튼 -->
                <a type="button" href="/message/list" class="btn btn-dark">목록</a>
            </div>
        </div>
    </div>

</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>