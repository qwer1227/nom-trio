<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
    #notice-table th {
        text-align: center;
    }

    #notice-table tr {
        height: 50px;
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
  
  <h2>공지사항 글 작성</h2>
  
  <form method="post" action="register" enctype="multipart/form-data">
    <div class="row p-3">
      <table id="notice-table" style="width: 98%">
        <colgroup>
          <col width="20%">
          <col width="*">
        </colgroup>
        <tbody>
        <tr>
          <th>상위 노출 여부</th>
          <td>
            <div class="form-check form-switch">
              <input class="form-check-input" checked type="checkbox" role="switch"
                     id="first-check" onclick="changeFirst()">
              <input type="hidden" id="first" name="first" value="true">
              <label class="form-check-label"></label>
            </div>
          </td>
        </tr>
        <tr>
          <th>글제목</th>
          <td colspan="3"><input type="text" id="title" name="title" style="width: 100%"></td>
        </tr>
        <tr>
          <th>글내용</th>
          <td colspan="3">
            <%@include file="../write.jsp" %>
          </td>
        </tr>
        <tr>
          <th>첨부파일</th>
          <td colspan="3">
            <input type="file" class="form-control" name="upfile"/>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    
    <div class="row p-3">
      <div class="col d-flex justify-content-between">
        <div class="col d-flex" style="text-align: start">
          <button type="button" class="btn btn-secondary m-1" onclick="abort()">취소</button>
        </div>
        <div class="col d-flex justify-content-end">
          <button type="button" id="submit" class="btn btn-primary m-1">등록</button>
        </div>
      </div>
    </div>
  </form>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">

    let formData = new FormData();

    // 등록 버튼 클릭 시, 폼에 있는 값을 전달(이미지는 슬라이싱할 때 전달했기 때문에 따로 추가 설정 안해도 됨)
    document.querySelector("#submit").addEventListener("click", function () {

        oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

        let first = document.querySelector("input[name=first]").value;
        let title = document.querySelector("input[name=title]").value.trim();
        let content = document.querySelector("textarea[name=ir1]").value.trim();
        let upfile = document.querySelector("input[name=upfile]")

        let cleanedContent = content.replace(/<p><br><\/p>/g, "").trim();

        // 입력값 검증
        if (!title) {
            alert("제목을 입력해주세요.");
            return;
        }
        if (!cleanedContent) {
            alert("내용을 입력해주세요.");
            return;
        }

        formData.append("first", first);
        formData.append("title", title);
        formData.append("content", content);
        if (upfile.files.length > 0) {
            formData.append("upfile", upfile.files[0]);
        }

        $.ajax({
            method: "post",
            url: "/community/notice/register",
            data: formData,
            processData: false,
            contentType: false,
            success: function (board) {
                window.location.href = "detail?no=" + board.no;
            }
        })
    });

    function changeFirst() {
        let checked = document.querySelector("#first");

        checked.value = document.querySelector("#first-check").checked ? "true" : "false";
    }

    function abort() {
        alert("글 작성을 취소하시겠습니까? 작성중이던 글은 저장되지 않습니다.");

        location.href = "main";
    }
</script>
</html>