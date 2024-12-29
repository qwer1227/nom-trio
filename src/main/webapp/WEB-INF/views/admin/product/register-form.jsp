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
          <h1 class="h3 mb-0 text-gray-800">새 상품 등록</h1>
        </div>
        <div class="container my-3">
          <div class="row mb-3">
            <div class="col">
              <div class="border p-2 bg-dark text-white fw-bold">새 상품 등록폼</div>
            </div>
          </div>
          <div class="row mb-3">
            <div class="col-12">
              <form name="form" action="/admin/product-register-form" enctype="multipart/form-data" method="post">
                <div class="row p-3">
                  <div class="col-6">
                    <label for="name">상품명</label>
                    <input type="text" class="form-control" name="name" id="name">
                  </div>
                </div>
                <div class="row row-cols-1 p-3">
                  <div class="col-2">
                    <label for="price">가격</label>
                    <div class="input-group">
                      <input type="number" class="form-control" name="price" id="price">
                      <span class="input-group-text">원</span>
                    </div>
                  </div>
                </div>
                <div class="row p-3">
                  <div class="col-2">
                    <label for="brand">브랜드</label>
                    <select name="brandNo" class="form-control" id="brand">
                      <option value="100">호카</option>
                      <option value="200">나이키</option>
                      <option value="300">브룩스</option>
                    </select>
                  </div>
                </div>
                <div class="row row-cols-1 p-3">
                  <div class="col-3">
                    <label for="category">카테고리</label>
                    <select name="categoryNo" class="form-control" id="category" <%--onchange="updateSize()"--%>>
                      <option value="11">남성 로드러닝화</option>
                      <option value="12">남성 상의</option>
                      <option value="13">남성 하의</option>
                      <option value="14">남성 아우터</option>
                      <option value="21">여성 로드러닝화</option>
                      <option value="22">여성 상의</option>
                      <option value="23">여성 하의</option>
                      <option value="24">여성 아우터</option>
                      <option value="31">양말</option>
                      <option value="32">모자</option>
                    </select>
                  </div>
                </div>
                <div class="row row-cols-1 p-3">
                  <div class="col-2 pb-3">
                    상품설명
                  </div>
                  <div class="col">
                    <textarea class="form-control" rows="10" cols="10" name="content"></textarea>
                  </div>
                </div>
                <div class="row p-3 ">
                  <div class="col-8">
                    <label for="thumbnail">썸네일 이미지(url경로)</label>
                    <input type="text" class="form-control" name="thumbnail" id="thumbnail"/>
                  </div>
                </div>
                <div class="row p-3">
                  <div class="col d-flex justify-content-end">
                    <a href="/admin/product?topNo=10" class="btn btn-secondary m-1">취소</a>
                    <button type="submit" class="btn btn-primary m-1">등록</button>
                  </div>
                </div>
              </form>
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

<script>
  const categoryDetails = {
    "10": [
      { value: "11", text: "남성 로드러닝화" },
      { value: "12", text: "남성 상의" },
      { value: "13", text: "남성 하의" },
      { value: "14", text: "남성 아우터" }
    ],
    "20": [
      { value: "21", text: "여성 로드러닝화" },
      { value: "22", text: "여성 상의" },
      { value: "23", text: "여성 하의" },
      { value: "24", text: "여성 아우터" }
    ],
    "30": [
      { value: "31", text: "양말" },
      { value: "32", text: "모자" }
    ]
  };

  const sizes = {
    "10": [
      { value: "11", text: "남성 로드러닝화" },
      { value: "12", text: "남성 상의" },
      { value: "13", text: "남성 하의" },
      { value: "14", text: "남성 아우터" }
    ],
    "20": [
      { value: "21", text: "여성 로드러닝화" },
      { value: "22", text: "여성 상의" },
      { value: "23", text: "여성 하의" },
      { value: "24", text: "여성 아우터" }
    ],
    "30": [
      { value: "31", text: "양말" },
      { value: "32", text: "모자" }
    ],
    "11": [
      { value: "250", text: "250"},
      { value: "255", text: "255"},
      { value: "260", text: "260"},
      { value: "265", text: "265"},
      { value: "270", text: "270"},
      { value: "275", text: "275"},
      { value: "280", text: "280"},
      { value: "285", text: "285"},
      { value: "290", text: "290"},
      { value: "295", text: "295"},
      { value: "300", text: "300"},
    ],
    "12": [
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"},
      { value: "3XL", text: "3XL"}
    ],
    "13": [
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"},
      { value: "3XL", text: "3XL"}
    ],
    "14": [
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"},
      { value: "3XL", text: "3XL"}
    ],

    "21": [
      { value: "220", text:"220"},
      { value: "225", text:"225"},
      { value: "230", text:"230"},
      { value: "235", text:"235"},
      { value: "240", text:"240"},
      { value: "245", text:"245"},
      { value: "250", text:"250"},
      { value: "255", text:"255"},
      { value: "260", text:"260"},
    ],
    "22": [
      { value: "XS", text: "XS"},
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"}
    ],
    "23": [
      { value: "XS", text: "XS"},
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"}
    ],
    "24": [
      { value: "S", text: "S"},
      { value: "M", text: "M"},
      { value: "L", text: "L"},
      { value: "XL", text: "XL"},
      { value: "XXL", text: "XXL"},
    ],
    "31": [
      { value: "FREE", text:"FREE"}
    ]

  }

  function updateCategoryDetails() {
    const topCategory = document.getElementById("topCategory").value; // 선택된 카테고리 값
    const category = document.getElementById("category");

    // 기존 옵션 초기화
    category.innerHTML = "";

    // 선택된 카테고리의 상세 옵션 추가
    if (categoryDetails[topCategory]) {
      categoryDetails[topCategory].forEach(detail => {
        const option = document.createElement("option");
        option.value = detail.value;
        option.textContent = detail.text;
        category.appendChild(option);

        updateSize();
      });
    }
  }

  function updateSize() {
    const category = document.getElementById("category").value;
    const size = document.getElementById("size");

    size.innerHTML = "";

    if (sizes[category]) {
      sizes[category].forEach(detail => {
        const option = document.createElement("option");
        option.value = detail.value;
        option.textContent = detail.text;
        size.appendChild(option);
      });
    }
  }

  // 페이지 로드 시 초기화
  document.addEventListener("DOMContentLoaded", updateCategoryDetails);

  document.forms['form'].addEventListener('submit', function (event) {
    const fields = [
      { id: 'name', message: '상품명을 입력하세요.' },
      { id: 'price', message: '가격을 입력하세요.' },
      { id: 'brand', message: '브랜드를 선택하세요.' },
      { id: 'category', message: '카테고리를 선택하세요.' },
      { id: 'thumbnail', message: '썸네일 URL를 입력하세요.' }
    ];

    // 필수 항목 확인
    for (const field of fields) {
      const input = document.getElementById(field.id);
      if (!input.value) {
        alert(field.message);
        input.focus();
        event.preventDefault();
        return;
      }
    }

    // 숫자 입력 필드 확인
    const numericFields = [
      { id: 'price', message: '가격은 숫자로 입력하세요.' }
    ];
    for (const field of numericFields) {
      const input = document.getElementById(field.id);
      if (isNaN(input.value)) {
        alert(field.message);
        input.focus();
        event.preventDefault();
        return;
      }
    }
  });

</script>

</body>

</html>



