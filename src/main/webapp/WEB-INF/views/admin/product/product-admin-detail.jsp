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
    <%@include file="/WEB-INF/views/common/common.jsp" %>
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
              <h1 class="h3 mb-0 text-gray-800">상품 상세 페이지</h1>
            </div>
            <div class="container" style="margin-top: 100px;">
                <div class="row mb-3">
                    <%--상품의 사진을 화면에 표시한다.--%>
                    <div class="col-6">
                        <div class="mb-3 box-big-img">
                            <img src="${prodImagesDto.images.get(0).url}" width="100%" id="big-img"/>
                        </div>
                        <div class="row">
                            <c:choose>
                                <c:when test="${not empty prodImagesDto.images}">
                                    <c:forEach var="imgs" items="${prodImagesDto.images}">
                                        <div class="col-2 box-small-img">
                                            <img class="img-fluid" src="${imgs.url}" data-big-img-path="${imgs.url}"/>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12">
                                        <p>해당 이미지가 없습니다.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>상품 상세 정보</h4>
                                    </div>
                                    <div class="card-body">
                                        <table class="table">
                                            <colgroup>
                                                <col width="15%" />
                                                <col width="35%" />
                                                <col width="15%" />
                                                <col width="35%" />
                                            </colgroup>
                                            <tr>
                                                <th>상품 이름</th>
                                                <td colspan="3">${prodDetailDto.name}</td>
                                            </tr>
                                            <tr>
                                                <th>상품 가격</th>
                                                <td colspan="3"><fmt:formatNumber value="${prodDetailDto.price }"/> 원</td>
                                            </tr>
                                            <tr>
                                                <th>브랜드명</th>
                                                <td>${prodDetailDto.brand.name}</td>
                                                <th>카테고리</th>
                                                <td>${prodDetailDto.category.name}</td>
                                            </tr>
                                            <tr>
                                                <th>평점</th>
                                                <td>${prodDetailDto.rating}</td>
                                                <th>조회수</th>
                                                <td>${prodDetailDto.cnt}</td>
                                            </tr>
                                            <tr>
                                                <th>상품 설명</th>
                                                <td colspan="3">${prodDetailDto.content}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>상품 옵션</h4>
                                    </div>
                                    <div class="p-4">색상을 선택하세요:</div>
                                    <div class="card-body">
                                        <div class="mb-4">
                                            <c:forEach var="p" items="${colorProdImgDto}">
                                                    <c:forEach var="im" items="${p.images}">
                                                        <a href="product-detail?no=${p.product.no}&colorNo=${p.no}"><img src="${im.url}" width=15%/></a>
                                                    </c:forEach>
                                            </c:forEach>
                                        </div>
                                            <div class="mb-4">
                                                <div class="mb-4">
                                                    <label class="form-label d-block">사이즈:</label>
                                                    <div class="row row-cols-5 g-3">
                                                        <c:choose>
                                                            <c:when test="${not empty sizeAmountDto.sizes}">
                                                                <c:forEach var="size" items="${sizeAmountDto.sizes}" varStatus="loop">
                                                                    <div class="col">
                                                                        <input type="radio" class="btn-check" name="size" id="size${size.size}" value="${size.size}" required
                                                                        onchange="fn(this)"
                                                                        data-name="${prodDetailDto.name}"
                                                                        data-size="${size.size}"
                                                                        data-size-no="${loop.count}"
                                                                        data-color="${sizeAmountDto.name}"
                                                                        data-no="${prodDetailDto.no}"
                                                                        >
                                                                        <label class="${size.amount == 0 ? 'btn btn-outline-danger fixed-size w-100 d-flex align-items-center justify-content-between disabled' : 'btn btn-outline-secondary fixed-size w-100 d-flex align-items-center justify-content-between'}" for="size${size.size}">
                                                                            <span class="ms-2">${size.size}</span>
                                                                            <span class="badge bg-secondary">재고:${size.amount}</span>
                                                                        </label>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="col-12">
                                                                    <p>해당 사이즈가 없습니다.</p>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row m-2">
                            <div class="mr-2">
                              <a href="register-color?no=${param.no}&colorNo=${param.colorNo}">
                                <button class="btn btn-outline btn-success btn-sm">상품 색상&사이즈&이미지 추가</button>
                              </a>
                            </div>
                        </div>
                        <div class="row m-2">
                            <div class="mr-2">
                                <a href="delete-size?no=${param.no}&colorNo=${param.colorNo}">
                                    <button class="btn btn-outline btn-success btn-sm">상품 사이즈 편집</button>
                                </a>
                            </div>
                        </div>
                        <div class="row m-2">
                            <div class="mr-2">
                                <a href="image-editform?no=${param.no}&colorNo=${param.colorNo}">
                                    <button class="btn btn-outline btn-success btn-sm">상품 이미지 편집</button>
                                </a>
                            </div>
                        </div>
                        <div class="row m-2">
                            <div class="mr-2">
                                <a href="/admin/product-stock?topNo=0">
                                    <button class="btn btn-outline btn-success btn-sm">재고현황보기</button>
                                </a>
                            </div>
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

    function fn(el) {
        let sizeAmount = el.getAttribute("data-amount");
        if (sizeAmount == 0) {
            alert("해당 사이즈는 재고가 없습니다.");
            return; // 더 이상 진행하지 않음
        }

        let prodNo = el.getAttribute("data-no");
        let size = el.getAttribute("data-size");
        let sizeNo = el.getAttribute("data-size-no");
        let name = el.getAttribute("data-name");
        let color = el.getAttribute("data-color");
        let colorNum = el.getAttribute("data-color-no");

        let content = `
         <div id="item-\${sizeNo}">
              <input type="hidden" name="prodNo" value="\${prodNo}"/>
              <input type="hidden" name="size" value="\${size}"/>
              <input type="hidden" name="sizeNo" value="\${sizeNo}"/>
              <input type="hidden" name="colorNo" value="\${colorNum}"/>
             <span><small>\${name} </small></span>
             <p><small>- \${color} / \${size}</small></p>
             <input type="button" value=" - " name="minus" data-no="\${sizeNo}">
             <input type="text" name="stock" value="1" id="stock-\${sizeNo}" size="3" max="" style="width: 3rem; text-align: center">
             <input type="button" value=" + " name="plus" data-no="\${sizeNo}">
             <div class="text-end">
                <small><strong id="price-\${sizeNo}"><fmt:formatNumber value="${prodDetailDto.price }"/></strong>원</small>
                <button type="button" class="btn btn-lg delete-button" data-target-id="#item-\${sizeNo}"><i class="bi bi-x"></i></button>
             </div>
             <hr class="bg-primary border border-1">
         </div>
    `;

        $("#cart").append(content);
        updateTotals();
    }

    // 이미지 클릭시 화면 대표 이미지 변경
    $(".box-small-img img").click(function () {
        let bigImgPath = $(this).data("big-img-path");
        console.log(bigImgPath);
        $("#big-img").attr("src", bigImgPath);
    });
</script>


</html>


