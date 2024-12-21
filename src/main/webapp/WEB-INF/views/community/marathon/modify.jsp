<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<script type="text/javascript" src="/resources/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<!doctype html>
<html lang="ko">
<head>
  <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
  #marathon-table th {
    text-align: center;
  }
  
  #marathon-table tr {
    height: 50px;
  }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
  
  <h2>마라톤 정보 작성</h2>
  
  <div class="row p-3">
    <form method="post" action="modify" enctype="multipart/form-data">
      <input type="hidden" name="no" value="${marathon.no}">
      <table id="marathon-table" style="width: 98%">
        <colgroup>
          <col width="10%">
          <col width="40%">
          <col width="10%">
          <col width="40%">
        </colgroup>
        <tbody>
        <tr>
          <th>마라톤 이름</th>
          <td colspan="3"><input type="text" name="title" value="${marathon.title}" style="width: 100%"></td>
        </tr>
        <tr>
          <th>일시</th>
          <td><input type="date" name="marathonDate"
                     value="<fmt:formatDate value="${marathon.marathonDate}" pattern="yyyy-MM-dd"/>" style="width: 50%">
          </td>
          <th>접수기간</th>
          <td>
            <input type="date" name="startDate"
                   value="<fmt:formatDate value="${marathon.startDate}" pattern="yyyy-MM-dd"/>" style="width: 48%">
            ~
            <input type="date" name="endDate" value="<fmt:formatDate value="${marathon.endDate}" pattern="yyyy-MM-dd"/>"
                   style="width: 48%">
          </td>
        </tr>
        <tr>
          <th>장소</th>
          <td colspan="3"><input type="text" name="place" value="${marathon.place}" style="width: 100%"></td>
        </tr>
        <tr>
          <th>주최기관</th>
          <td><input type="text" name="host" value="${host}" style="width: 100%"></td>
          <th>주관기관</th>
          <td><input type="text" name="organizer" value="${organizer}" style="width: 100%"></td>
        </tr>
        <tr>
          <th>홈페이지</th>
          <td colspan="3"><input type="text" name="url" value="${marathon.url}" style="width: 100%"></td>
        </tr>
        <tr>
          <th>게시글</th>
          <td colspan="3">
            <form method="get" action="modify">
              <textarea name="ir1" id="ir1" style="display:none;">${marathon.content}</textarea>
            </form>
          </td>
        </tr>
        <tr>
          <th>썸네일</th>
          <td colspan="3"><input type="text" name="thumbnail" value="${marathon.thumbnail}" style="width: 100%"></td>
        </tr>
        </tbody>
      </table>
      <div class="row p-3">
        <div class="col d-flex justify-content-between">
          <div class="col d-flex" style="text-align: start">
            <button type="button" class="btn btn-secondary m-1" onclick="abort(${marathon.no})">취소</button>
          </div>
          <div class="col d-flex justify-content-end">
            <button type="button" id="submit" class="btn btn-primary m-1">수정</button>
          </div>
        </div>
      </div>
    </form>
  </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
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
    let title = document.querySelector("input[name=title]").value;
    let content = document.querySelector("textarea[name=ir1]").value;
    let marathonDate = document.querySelector("input[name=marathonDate]").value;
    let startDate = document.querySelector("input[name=startDate]").value;
    let endDate = document.querySelector("input[name=endDate]").value;
    let host = document.querySelector("input[name=host]").value;
    let organizer = document.querySelector("input[name=organizer]").value;
    let url = document.querySelector("input[name=url]").value;
    let place = document.querySelector("input[name=place]").value;
    let thumbnail = document.querySelector("input[name=thumbnail]").value;
    
    
    let cleanedContent = content.replace(/<p><br><\/p>/g, "").trim();
    
    if (!title) {
      alert("제목을 입력해주세요.");
      return;
    }
    if (!marathonDate) {
      alert("마라톤 일정을 선택해주세요.");
      return;
    }
    if (!startDate) {
      alert("마라톤 모집 시작일을 선택해주세요.");
      return;
    }
    if (!endDate) {
      alert("마라톤 모집 마감일을 선택해주세요.");
      return;
    }
    if (!place) {
      alert("마라톤 장소를 입력해주세요.");
      return;
    }
    if (!host) {
      alert("주최 기관을 입력해주세요.");
      return;
    }
    if (!organizer) {
      alert("주관 기관을 입력해주세요.");
      return;
    }
    if (!url) {
      alert("마라톤 홈페이지 주소를 입력해주세요.");
      return;
    }
    if (!cleanedContent) {
      alert("내용을 입력해주세요.");
      return;
    }
    if (!thumbnail) {
      alert("마라톤 썸네일 이미지 링크를 입력해주세요.");
      return;
    }
    
    formData.append("no", no);
    formData.append("title", title);
    formData.append("content", content);
    formData.append("marathonDate", marathonDate);
    formData.append("startDate", startDate);
    formData.append("endDate", endDate);
    formData.append("host", host);
    formData.append("organizer", organizer);
    formData.append("url", url);
    formData.append("place", place);
    formData.append("thumbnail", thumbnail);
    
    $.ajax({
      method: "post",
      url: "/community/marathon/modify",
      data: formData,
      processData: false,
      contentType: false,
      success: function (board) {
        window.location.href = "detail?no=" + board.no;
      }
    })
  });
  
  function abort(marathonNo) {
    let result = confirm("수정 중이던 글을 취소하시겠습니까?");
    if (result) {
      window.location.href = "detail?no=" + marathonNo;
    }
  }
  function deleteUploadFile(marathonNo, fileNo) {
    let result = confirm("기존에 등록된 첨부파일을 삭제하시겠습니까?");
    if (result) {
      window.location.href = `delete-file?no=\${marathonNo}&fileNo=\${fileNo}`;
    }
  }
</script>
</html>