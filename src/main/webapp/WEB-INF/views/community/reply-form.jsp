<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<style>
    .auto-resize {
        border: none; /* 테두리 제거 */
        box-shadow: none; /* 그림자 제거 */
        resize: none; /* 크기 조정 막기 */
        overflow: hidden; /* 스크롤바 숨기기 */
    }

    .auto-resize:focus {
        outline: none; /* 포커스 시 외곽선 제거 */
    }
</style>
<html lang="ko">
<div class="comment-form mb-4">
  <h5 style="text-align: start">댓글 작성</h5>
  <form method="post" action="add-reply">
    <input type="hidden" name="userNo" value="${loginUser.no}">
    <input type="hidden" name="type" value="board">
    <input type="hidden" name="typeNo" value="${crew.no}">
    <div class="row">
      <c:choose>
        <c:when test="${empty loginUser}">
          <div class="form-group col-11">
            <input class="form-control" disabled placeholder="로그인 후 댓글 작성이 가능합니다."/>
          </div>
          <div class="col" style="text-align: end">
            <button type="button" class="btn btn-outline-success" style="width: 85px" onclick="goLogin()">등록
            </button>
          </div>
        </c:when>
        <c:otherwise>
          <div class="form-group col-11 border rounded">
            <textarea name="content" class="form-control auto-resize" rows="3" placeholder="댓글을 작성하세요."></textarea>
          </div>
          <div class="col" style="text-align: end">
            <button type="button" id="addReply" class="btn btn-success" style="width: 85px">등록</button>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </form>
</div>

<script>
  function goLogin() {
    let result = confirm("로그인하시겠습니까?");
    if (result) {
      window.location.href = "/login";
    }
  }
  
  /* 댓글 등록 */
  document.querySelector("#addReply").addEventListener("click", function () {
      let type = document.querySelector("input[name=type]").value;
      let typeNo = document.querySelector("input[name=typeNo]").value;
      let content = document.querySelector("textarea[name=content]").value.trim();

      let cleanedContent = content.replace(/<p><br><\/p>/g, "").trim();

      // 입력값 검증
      if (!cleanedContent) {
          alert("댓글 내용을 입력해주세요.");
          return;
      }

      formData.append("type", type);
      formData.append("typeNo", typeNo);
      formData.append("content", content);


      $.ajax({
          method: "post",
          url: "/community/board/add-reply",
          data: formData,
          processData: false,
          contentType: false,
          success: function (board) {
              window.location.href = "detail?no=" + board.typeNo;
          }
      })
  });

  function autoResize(textarea) {
      // 높이를 초기화하여 스크롤 높이를 정확히 계산
      textarea.style.height = 'auto';
      // 입력된 텍스트에 따라 높이를 조정
      textarea.style.height = textarea.scrollHeight + 'px';
  }

  // DOM이 로드된 후 textarea에 자동 크기 조정 이벤트를 추가
  document.addEventListener("DOMContentLoaded", function () {
      const textareas = document.querySelectorAll(".auto-resize");
      textareas.forEach(textarea => {
          autoResize(textarea); // 초기 높이 설정
          textarea.addEventListener("input", function () {
              autoResize(textarea); // 입력 시 높이 자동 조정
          });
      });
  });

  // 페이지 로드 시 기존 값이 있다면 크기를 조정
  document.querySelectorAll('.auto-resize').forEach(textarea => {
      autoResize(textarea);
  });
</script>
</html>