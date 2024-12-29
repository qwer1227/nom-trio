<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!DOCTYPE html>
<html lang="en">

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
          <h1 class="h3 mb-0 text-gray-800">기존 상품 이미지 추가</h1>
        </div>
        <div class="container my-3">
          <div class="row mb-3">
            <div class="col-6">
              <div class="border p-2 bg-dark text-white fw-bold">이미지 등록</div>
            </div>
          </div>
          <div class="row mb-3">
            <div class="col-6">
              <form class="border bg-light p-3"
                    method="post" action="/admin/register-image"
                    enctype="multipart/form-data">
                <div class="form-group mb-3 col-4">
                  <label class="form-label">상품번호:</label>
                  <input type="text" class="form-control" name="prodNo" value="${product.no}"/>
                </div>
                <div class="form-group mb-3 col">
                  <label class="form-label">상품명:</label>
                  <input type="text" class="form-control" name="name" value="${product.name}"/>
                </div>
                <div class="form-group mb-3 col-4">
                  <label class="form-label">색상 선택</label>
                  <select name="colorNo" class="form-control" id="colorNo">
                      <c:forEach var="c" items="${colors}">
                          <option value="${c.no}">${c.name}</option>
                      </c:forEach>
                  </select>
                </div>
                <div id="imageContainer">
                  <div class="form-group col mb-3">
                    <label class="form-label mb-3">상품 이미지</label>
                    <button id="addButton" type="button" class="btn btn-primary">+</button>
                    <input type="text" class="form-control mt-2" name="image[]" placeholder="이미지 URL을 입력하세요" />
                    <button type="button" class="btn btn-danger mt-2 btn-delete">삭제</button>
                  </div>
                </div>
                <div class="row justify-content-end">
                  <div class="text-end" style="text-align: right">
                    <a type="button" class="btn btn-dark mr-2" href="/admin/register-size?no=${param.no}&colorNo=${param.colorNo}">뒤로가기</a>
                  </div>
                  <div class="text-end" style="text-align: right">
                    <button type="submit" class="btn btn-primary mr-1">등록</button>
                  </div>
                </div>
              </form>
              <div class="text-end mt-2" style="text-align: right">
                <a href="image-changeThumb?no=${param.no}&colorNo=${param.colorNo}">
                  <button class="btn btn-outline btn-success mr-2">대표 이미지 설정</button>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- end Page Content -->
    </div>
  </div>
</div>
<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->

<%@include file="/WEB-INF/views/admincommon/common.jsp" %>

</body>
<script>
  document.addEventListener('DOMContentLoaded', () => {
    const imageContainer = document.getElementById('imageContainer');
    const addButton = document.getElementById('addButton');

    // 새로운 입력 필드 추가
    const addImageInput = () => {
      const div = document.createElement('div');
      div.className = 'form-group col mb-3';
      div.innerHTML = `
      <input type="text" class="form-control mt-2" name="image[]" placeholder="이미지 URL을 입력하세요" />
      <button type="button" class="btn btn-danger mt-2 btn-delete">삭제</button>
    `;
      imageContainer.appendChild(div);
    };

    // 입력 필드 삭제
    const deleteImageInput = (button) => {
      button.parentElement.remove();
    };

    // + 버튼 클릭 이벤트
    addButton.addEventListener('click', addImageInput);

    // 삭제 버튼 클릭 이벤트 위임
    imageContainer.addEventListener('click', (e) => {
      if (e.target.classList.contains('btn-delete')) {
        deleteImageInput(e.target);
      }
    });
  });

  window.onload = function() {
    <%-- 성공 메시지 확인 --%>
    <c:if test="${not empty successMessage}">
    alert("${successMessage}");
    </c:if>

    <%-- 에러 메시지 확인 --%>
    <c:if test="${not empty errorMessage}">
    alert("${errorMessage}");
    </c:if>
  }


</script>
</html>



