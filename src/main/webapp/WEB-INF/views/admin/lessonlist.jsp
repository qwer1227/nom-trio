<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="ko">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SB Admin 2 - Dashboard</title>

  <!-- Custom fonts for this template-->
  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link
          href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
  <!-- Bootstrap CSS 링크 예시 페이지네이션-->
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <!-- 모달창 x표시(아이콘 같은) 보임 대신 select option 화살표 표시 안보이고 courselist radio버튼 문제 생김-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="${pageContext.request.contextPath}/resources/css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

  <!-- Sidebar -->
  <%@include file="/WEB-INF/views/admincommon/sidebar.jsp" %>
  <!-- End of Sidebar -->

  <!-- Content Wrapper -->
  <div id="content-wrapper" class="d-flex flex-column">

    <!-- Main Content -->
    <div id="content">

      <!-- Topbar -->
      <%@include file="/WEB-INF/views/admincommon/topbar.jsp" %>
      <!-- End of Topbar -->

      <!-- Begin Page Content -->
      <div class="container-fluid">
        <!-- Page Heading -->
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
          <h1 class="h3 mb-0 text-gray-800">레슨</h1>
        </div>
        <form id="form-search" method="get" action="/admin/lesson">
          <input type="hidden" name="page"/>
          <div class="row g-3 d-flex">

              <div class="row col-3 pt-3 align-items-center">
                <label for="dateInput" class="col-auto col-form-label">날짜</label>
                <div class="col-8">
                  <%
                    // 현재 날짜 가져오기
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    String currentDate = sdf.format(new Date()); // 현재 날짜를 "yyyy-MM-dd" 형식으로 변환
                  %>
                  <input
                          type="date"
                          name="day"
                          id="dateInput"
                          value="${param.day != null ? param.day : currentDate}"
                          class="form-control form-control-sm rounded-pill border-gray"
                  />
                </div>
              </div>

            <div class="col-1">
              <select class="form-control" name="opt">
                <option value="name">강사명</option>
                <option value="lessonname">레슨명</option>
                <option value="course">과목</option>
              </select>
            </div>
            <div class="col-3">
              <!-- Search -->
              <%@include file="/WEB-INF/views/admincommon/searchbar.jsp" %>

            </div>
          </div>
        </form>
      </div>
      <!-- 레슨 목록시작 -->
      <div class="row mb-3">
        <div class="col">
          <div class="border-bottom pt-4 pr-4 pl-4 bg-light">
            <table class="table">
              <colgroup>
                <col width="12%">
                <col width="7%">
                <col width="*%">
                <col width="10%">
                <col width="10%">
                <col width="13%">
                <col width="8%">
                <col width="7%">
              </colgroup>
              <thead>
                <tr>
                  <th>날짜</th>
                  <th>시간</th>
                  <th>레슨명</th>
                  <th>강사명</th>
                  <th>가격</th>
                  <th>예약인원</th>
                  <th>모집상태</th>
                  <th>수정</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="l" items="${lessons}">
                  <tr>
                    <td>
                      ${l.startDate}
                    </td>
                    <td>
                      ${l.startTime}
                    </td>
                    <td>${l.title}</td>
                    <td>${l.lecturer.name}</td>
                    <td>${l.price}</td>
                    <td>${l.participant}/5
                      <button class="btn btn-outline btn-success btn-sm "
                              onclick="previewUser(${l.lessonNo})">회원보기</button>
                    </td>
                    <td>${l.status}</td>
                    <td>

                      <button class="btn btn-outline btn-warning btn-sm"
                              onclick="lessonEdit(${l.lessonNo})">수정</button>

                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>

          </div>

        </div>

      </div>
      <!-- 레슨 목록끝 -->
      <!-- end Page Content -->
    </div>
  </div>
</div>
<!-- 모달 창 -->
<div class="modal fade" id="modal-preview-user" tabindex="-1" aria-labelledby="modal-preview-user" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modal-title-preview-user">예약회원 보기</h1>
        <button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close">
        </button>
      </div>
      <div class="modal-body">
        <table class="table" id="table-rev">
          <colgroup>
            <col width="15%">
            <col width="15%">
            <col width="15%">
            <col width="*%">
            <col width="25%">
          </colgroup>
          <thead>
            <tr>
              <th>아이디</th>
              <th>이름</th>
              <th>닉네임</th>
              <th>이메일</th>
              <th>전화번호</th>
            </tr>
          </thead>
         <tbody>

         </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>

  </div>


</div>

<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->

<%@include file="/WEB-INF/views/admincommon/common.jsp" %>
<script>
  const form =document.querySelector("#form-search");
  const pageInput = document.querySelector("input[name=page]");

  async function previewUser(lessonNo) {
    let response = await fetch("/admin/lesson/preview?no=" + lessonNo);
    let data = await response.json();

    console.log("data: ", data);

    let rows = "";

    if (data.length === 0) {
      rows = `
      <tr>
        <td colspan="5" class="text-center">등록된 회원이 없습니다.</td>
      </tr>
    `;
    } else {
      for (let rev of data) {
        const formattedPhone = formatPhoneNumber(rev.tel);

        rows += `
        <tr>
            <td><span>\${rev.id}</span></td>
            <td><span>\${rev.name}</span></td>
            <td><span>\${rev.nickname}</span></td>
            <td><span>\${rev.email}</span></td>
            <td><span>\${formattedPhone}</span></td>
          </tr>
      `;
      }
    }
    function formatPhoneNumber(phoneNumber) {
      // 전화번호 정규식 (010-1234-5678 형식으로)
      const phoneRegex = /^(01[0-9])(\d{3,4})(\d{4})$/;

      // 정규식에 맞는 경우 포맷팅
      if (phoneRegex.test(phoneNumber)) {
        return phoneNumber.replace(phoneRegex, '$1-$2-$3');
      } else {
        // 형식에 맞지 않는 경우 그대로 반환
        return phoneNumber;
      }
    }

    document.querySelector("#table-rev tbody").innerHTML = rows;

    const myModal = new bootstrap.Modal('#modal-preview-user');

    myModal.show();
  }

  // 검색어를 입력하고 검색버튼을 클릭했을 때
  function searchValue() {
    pageInput.value = 1;		// 정렬방식이 바뀌면
    form.submit();
  }

  // 오늘 날짜를 얻기
  const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
  const dd = String(today.getDate()).padStart(2, '0');

  const dateInput = document.getElementById('dateInput');
  if (!dateInput.value) { // 날짜 값이 비어 있으면 오늘 날짜를 기본값으로 설정
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const dd = String(today.getDate()).padStart(2, '0');

    // 'yyyy-mm-dd' 형식으로 변환
    const formattedDate = `${yyyy}-${mm}-${dd}`;
    if (!dateInput.value) {
      dateInput.value = formattedDate;
    }
  }

  // 기본값 설정
  document.getElementById('dateInput').value = formattedDate;

  function lessonEdit(lessonNo) {
    if (lessonNo !== undefined && lessonNo !== null && lessonNo !== "") {  // Validate lessonNo
      console.log("LessonNo:", lessonNo); // Log to ensure lessonNo is being passed as int
      location.href =("/admin/lesson-edit-form?lessonNo="+lessonNo);
    } else {
      console.error("Invalid lessonNo");
    }
  }

</script>

</body>

</html>

