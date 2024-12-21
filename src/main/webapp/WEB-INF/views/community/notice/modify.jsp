<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<script type="text/javascript" src="/resources/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
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
  
  <h2>공지사항 글 수정</h2>
  
  <div class="row p-3">
    <form method="post" action="modify" enctype="multipart/form-data">
      <input type="hidden" name="no" value="${notice.no}">
      <input type="hidden" name="fileNo" id="fileNo" value="${notice.uploadFile.no}">
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
          <td colspan="3"><input type="text" id="title" name="title" style="width: 100%" value="${notice.title}"></td>
        </tr>
        <tr>
          <th>글내용</th>
          <td colspan="3">
            <form method="get" action="modify">
              <textarea name="ir1" id="ir1" style="display:none;">${notice.content}</textarea>
            </form>
        </tr>
        <c:if test="${not empty notice.uploadFile}">
          <c:if test="${notice.uploadFile.deleted eq 'N'}">
            <tr class="form-group">
              <th>
                <label class="form-label">기존파일명</label>
              </th>
              <td colspan="3" style="text-align: start">
                  ${notice.uploadFile.originalName}
                <button type="button" class="btn btn-outline-dark"
                        onclick="deleteUploadFile(${notice.no}, ${notice.uploadFile.no})">
                  삭제
                </button>
              </td>
            </tr>
          </c:if>
        </c:if>
        <tr>
          <th>첨부파일</th>
          <td colspan="3">
            <input type="file" class="form-control" name="upfile"/>
          </td>
        </tr>
        </tbody>
      </table>
    </form>
  </div>
  <div class="row p-3">
    <div class="col d-flex justify-content-between">
      <div class="col d-flex" style="text-align: start">
        <button type="button" class="btn btn-secondary m-1" onclick="abort(${notice.no})">취소</button>
      </div>
      <div class="col d-flex justify-content-end">
        <button type="button" id="submit" class="btn btn-primary m-1">등록</button>
      </div>
    </div>
  </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">
    var oEditors = [];
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "ir1",
        sSkinURI: "/resources/se2/SmartEditor2Skin_ko_KR.html",
        fCreator: "createSEditor2"
    });

    let formData = new FormData();

    // 등록 버튼 클릭 시, 폼에 있는 값을 전달(이미지는 슬라이싱할 때 전달했기 때문에 따로 추가 설정 안해도 됨)
    document.querySelector("#submit").addEventListener("click", function () {

        oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

        let no = document.querySelector("input[name=no]").value;
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

        formData.append("no", no);
        formData.append("first", first);
        formData.append("title", title);
        formData.append("content", content);
        if (upfile.files.length > 0) {
            formData.append("upfile", upfile.files[0]);
        }

        $.ajax({
            method: "post",
            url: "/community/notice/modify",
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

    function abort(noticeNo) {
        let result = confirm("수정 중이던 글을 취소하시겠습니까?");
        if (result) {
            window.location.href = "detail?no=" + noticeNo;
        }
    }

    function deleteUploadFile(noticeNo, fileNo) {
        let result = confirm("기존에 등록된 첨부파일을 삭제하시겠습니까?");
        if (result) {
            window.location.href = `delete-file?no=\${noticeNo}&fileNo=\${fileNo}`;
        }
    }
</script>
</html>