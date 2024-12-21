<!-- 로그인 여부와 관계없이 게시글 내용을 볼 수 있도록 수정 -->
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

    #content-title:hover {
        font-weight: bold;
    }

    table td {
        padding: 5px 0; /* 위아래 간격 10px */
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
  <h2> 커뮤니티 글 상세 </h2>
  <div>
    <input type="hidden" name="type" value="board">
    <input type="hidden" name="no" value="${board.no}">
    <input type="hidden" name="typeNo" value="${board.no}">
    <div class="col d-flex justify-content-left">
      <div>
        <a href="main?category=${board.catName}" style="text-decoration-line: none">${board.catName}</a>
      </div>
    </div>
    <div class="title h4 d-flex justify-content-between align-items-center">
      <div>
        ${board.title}
      </div>
      <div class="ml-auto">
        <security:authorize access="isAuthenticated()">
          <security:authentication property="principal" var="loginUser"/>
          <c:if test="${loginUser.no ne board.user.no}">
            <button class="btn btn-outline-success btn-lg" id="scrapButton"
                    onclick="scrapButton(${board.no})">
              <i id="icon-scrap"
                 class="bi ${Scrapped == '1' ? 'bi-bookmark-fill' : (Scrapped == '0' ? 'bi-bookmark' : 'bi-bookmark')}"></i>
            </button>
          </c:if>
        </security:authorize>
      </div>
    </div>
    <div class="meta d-flex justify-content-between mb-3">
            <span>
                ${board.user.nickname} | <fmt:formatDate value="${board.createdDate}" pattern="yyyy.MM.dd hh:mm:ss"/>
            </span>
      <span>
                <i class="bi bi-eye"></i> ${board.viewCnt}
                <i class="bi bi-bookmark"></i> ${board.scrapCnt}
                <i class="bi bi-hand-thumbs-up"></i> ${board.like}
                <i class="bi bi-chat-square-text"></i> ${replyCnt}
            </span>
    </div>
    <div style="margin-top: 10px; border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
    
    <c:if test="${not empty board.uploadFile.originalName}">
      <div class="content mb-4" id="fileDown" style="text-align: end">
        <a href="filedown?no=${board.no}" class="btn btn-outline-primary btn-sm">첨부파일 다운로드</a>
        <span id="hover-box">${board.uploadFile.originalName}</span>
      </div>
    </c:if>
    
    <div class="content m-3" style="text-align: start">
      <p>${board.content}</p>
    </div>
    
    <div style="border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
    
    <div class="row mb-4">
      <div class="col d-flex justify-content-between">
        <div class="col-6 d-flex justify-content-start">
          <!-- 수정, 삭제 버튼은 로그인된 사용자만 -->
          <c:if test="${loginUser.no == board.user.no}">
            <button class="btn btn-warning mr-3" onclick="updateBoard(${board.no})" style="margin-right: 10px;">수정
            </button>
            <button class="btn btn-danger" onclick="deleteBoard(${board.no})" style="margin-right: 10px;">삭제</button>
          </c:if>
          <!-- 신고 버튼은 로그인된 사용자만 표시 -->
          <c:if test="${loginUser.no != board.user.no and not empty loginUser}">
            <button type="button" class="btn btn-danger" onclick="report('board', ${board.no})">신고</button>
          </c:if>
        </div>
        <div class="col d-flex justify-content-end">
          <!-- 좋아요 버튼은 로그인된 사용자만 표시 -->
          <c:if test="${not empty loginUser}">
            <button class="btn btn-outline-primary" id="likeCnt" style="margin-right: 10px;"
                    onclick="boardLikeButton(${board.no})">
              <i id="icon-heart"
                 class="bi ${boardLiked == '1' ? 'bi-heart-fill' : (boardLiked == '0' ? 'bi-heart' : 'bi-heart')}"></i>
            </button>
          </c:if>
          <!-- 목록 버튼은 로그인 여부와 관계없이 표시 -->
          <a type="button" href="main" class="btn btn-secondary">목록</a>
        </div>
      </div>
    </div>
    
    <!-- 이전, 다음 게시글 -->
    <div class="pb-3">
      <table style="width: 100%">
        <colgroup>
          <col width="10%">
          <col width="*">
        </colgroup>
        <tbody>
        <tr>
          <td> ▲ 이전글</td>
          <td style="text-align: start">
            <c:if test="${not empty board.prevNo}">
              <a href="hit?no=${board.prevNo}">${board.prevTitle}</a>
            </c:if>
          </td>
        </tr>
        <tr>
          <td> ▼ 다음글</td>
          <td style="text-align: start">
            <c:if test="${not empty board.nextNo}">
              <a href="hit?no=${board.nextNo}">${board.nextTitle}</a>
            </c:if>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    
    <!-- 댓글 작성 -->
    <%@include file="../reply-form.jsp" %>
    
    <!-- 댓글 목록 -->
    <c:if test="${not empty board.reply}">
      <div class="row comments rounded mb-4" style="margin-left: 2px; width: 100%; background-color: #f2f2f2">
        <!--댓글 내용 -->
        <c:forEach var="reply" items="${replies}">
          <%@include file="../reply-lists.jsp" %>
        </c:forEach>
      </div>
    </c:if>
  </div>
  <!-- 인기 게시글 -->
  <div class="rounded border" style="padding: 10px; background-color: #f2f2f2">
    <table style="width: 100%">
      <colgroup>
        <col width="15%">
        <col width="*">
        <col width="20%">
        <col width="5%">
        <col width="5%">
        <col width="5%">
      </colgroup>
      <tbody>
      <tr>
        <td colspan="6">
          <div>
            <strong>[ 실시간 인기 커뮤니티 글 ]</strong>
          </div>
        </td>
      </tr>
      <c:forEach items="${boards}" var="b">
        <tr>
          <td>${b.catName}</td>
          <td style="text-align: start">
            <a id="content-title" style="text-decoration: none" href="hit?no=${b.no}">${b.title}</a>
          </td>
          <td>${b.user.nickname}</td>
          <td><i class="bi bi-eye"></i>${b.viewCnt}</td>
          <td><i class="bi bi-hand-thumbs-up"></i>${b.like}</td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>



<!-- 신고 모달 창 -->
<%@include file="../report-modal.jsp" %>


<%@include file="/WEB-INF/views/common/footer.jsp" %>
</div>
</body>

<script type="text/javascript">
    let formData = new FormData();

    const myModalRepoter = new bootstrap.Modal('#modal-reporter')

    function updateBoard(boardNo) {
        let result = confirm("해당 게시글을 수정하시겠습니까?");
        if (result) {
            window.location.href = "modify?no=" + boardNo;
        }
    }

    function deleteBoard(boardNo) {
        let result = confirm("해당 게시글을 삭제하시겠습니까?");
        if (result) {
            window.location.href = "delete?no=" + boardNo;
        }
    }

    async function report(type, no) {
        let response = await fetch("/community/board/report-check?type=" + type + "&no=" + no, {
            // 요청방식을 지정한다.
            method: "GET",
            // 요청메세지의 바디부에 포함된 컨텐츠의 형식을 지정한다.
            headers: {
                "Content-Type": "application/json"
            }
        });

        if (response.ok) {
            let exists = await response.text();

            if (exists === "yes") {
                // 신고한 내역이 있으면
                alert("이미 신고한 내역이 있습니다");
            } else {
                // 신고한 내역이 없으면 모달창 보이기
                document.querySelector(".modal input[name=type]").value = type;
                document.querySelector(".modal input[name=no]").value = no;

                if (type === 'board') {
                    $(".modal form").attr('action', 'report-board');
                }

                if (type === 'boardReply') {
                    $(".modal form").attr('action', 'report-reply');
                }

                myModalRepoter.show();
            }
        }
    }

    function reportButton() {
        const etcReason = document.querySelector("#reason-etc");
        if (etcReason.checked) {
            etcReason.value = document.querySelector("#etc").value;
        }
        $(".modal form").trigger("submit");
    }

    function scrapButton(boardNo) {
        let scrap = document.querySelector("#icon-scrap");
        if (scrap.classList.contains("bi-bookmark")) {
            window.location.href = `update-board-scrap?no=\${boardNo}`;
        } else {
            window.location.href = `delete-board-scrap?no=\${boardNo}`;
        }
    }

    function boardLikeButton(boardNo) {
        let heart = document.querySelector("#icon-heart");
        if (heart.classList.contains("bi-heart")) {
            window.location.href = `update-board-like?no=\${boardNo}`;
        } else {
            window.location.href = `delete-board-like?no=\${boardNo}`;
        }
    }
</script>
</html>