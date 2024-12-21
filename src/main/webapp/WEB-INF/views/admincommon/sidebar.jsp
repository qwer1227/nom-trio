<%@ page pageEncoding="UTF-8"%>

<!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
  
  <!-- Sidebar - Brand -->
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="home">
    <div class="sidebar-brand-icon rotate-n-15">
      <i class="fas fa-running"></i>
    </div>
    <div class="sidebar-brand-text mx-3">습습후후 <sup></sup></div>
  </a>
  
  <!-- Divider -->
  <hr class="sidebar-divider my-0">
  
  <!-- Nav Item - Dashboard -->
  <li class="nav-item active">
    <a class="nav-link" href="/home">
      <i class="fas fa-fw fa-home ml-4"></i>
      <span class="ml-2"> 사용자 홈으로 </span></a>
  </li>
  
  <!-- Divider -->
  <hr class="sidebar-divider">
  
  <!-- Heading -->
  <div class="sidebar-heading">
    관리
  </div>
  
  <!-- 코스관리 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseOne"
       aria-expanded="true" aria-controls="collapseOne">
      <i class="fas fa-fw fa-route"></i>
      <span>코스관리</span>
    </a>
    <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">코스</h6>
        <a class="collapse-item" href="/admin/course">코스 전체&상세&수정</a>
        <a class="collapse-item" href="/admin/course-register-form">코스 등록하기</a>
      </div>
    </div>
  </li>
  
  <!-- 회원관리 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTwo"
       aria-expanded="true" aria-controls="collapseTwo">
      <i class="fas fa-fw fa-users"></i>
      <span>회원관리</span>
    </a>
    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">회원</h6>
        <a class="collapse-item" href="/admin/user">회원 전체</a>
      </div>
    </div>
  </li>
  
  <!-- 상품관리 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseThree"
       aria-expanded="true" aria-controls="collapseThree">
      <i class="fas fa-fw fa-box"></i>
      <span>상품관리</span>
    </a>
    <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">상품</h6>
        <a class="collapse-item" href="/admin/product?topNo=10">남성 상품 전체</a>
        <a class="collapse-item" href="/admin/product?topNo=20">여성 상품 전체</a>
        <a class="collapse-item" href="/admin/product?topNo=30">러닝용품 전체</a>
        <a class="collapse-item" href="/admin/product-register-form">상품 등록하기</a>
      </div>
    </div>
  </li>
  
  <!-- 커뮤니티 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseFour"
       aria-expanded="true" aria-controls="collapseFour">
      <i class="fas fa-fw fa-share-alt"></i>
      <span>커뮤니티</span>
    </a>
    <div id="collapseFour" class="collapse" aria-labelledby="headingFour" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">커뮤니티</h6>
        <a class="collapse-item" href="../community/board/main">커뮤니티 바로가기</a>
        <a class="collapse-item" href="../community/crew/main">크루 바로가기</a>
        <a class="collapse-item" href="../admin/notice">공지사항</a>
        <a class="collapse-item" href="../admin/marathon">마라톤</a>
        <a class="collapse-item" href="/admin/report">신고글 보기</a>
        <a class="collapse-item" href="/admin/qna">1:1 문의사항</a>
      </div>
    </div>
  </li>
  
  <!-- 재고관리 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseFive"
       aria-expanded="true" aria-controls="collapseFive">
      <i class="fas fa-fw fa-calculator"></i>
      <span>배송&재고&정산 관리</span>
    </a>
    <div id="collapseFive" class="collapse" aria-labelledby="headingFive" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">배송&재고&정산</h6>
        <a class="collapse-item" href="/admin/order-delivery">배송</a>
        <a class="collapse-item" href="/admin/product-stock?topNo=0">상품 재고 등록하기</a>
        <a class="collapse-item" href="/admin/settlement">레슨정산관리</a>
        <a class="collapse-item" href="/admin/p-settlement">상품정산관리</a>
      </div>
    </div>
  </li>
  
  <!-- 레슨관리 토글 -->
  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseSix"
       aria-expanded="true" aria-controls="collapseSix">
      <i class="fas fa-fw fa-chalkboard-teacher"></i>
      <span>레슨관리</span>
    </a>
    <div id="collapseSix" class="collapse" aria-labelledby="headingSix" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">레슨</h6>
        <a class="collapse-item" href="/admin/lesson">레슨 전체&수정</a>
        <a class="collapse-item" href="/admin/lesson-register-form">레슨 등록하기</a>
      </div>
    </div>
  </li>
  
  <!-- Divider -->
  <hr class="sidebar-divider">
  
  
  <!-- Sidebar Toggler (Sidebar) -->
  <div class="text-center d-none d-md-inline">
    <button class="rounded-circle border-0" id="sidebarToggle"></button>
  </div>

</ul>

<style>
    /* 아이콘 움직임 애니메이션 정의 */
    @keyframes moveIcon {
        0% {
            transform: translateY(0);
        }
        50% {
            transform: translateY(-5px);
        }
        100% {
            transform: translateY(0);
        }
    }

    /* 기본 스타일 설정 */
    .sidebar-brand {
        text-decoration: none;
        color: inherit;
        display: inline-block;
    }

    /* 마우스 오버 시 애니메이션 적용 */
    .sidebar-brand:hover .sidebar-brand-icon {
        animation: moveIcon 0.5s ease-in-out;
    }

    /* 아이콘 회전 유지 */
    .sidebar-brand-icon {
        display: inline-block;
        transition: transform 0.3s ease-in-out;
    }

    /* 아이콘의 기본 크기 설정 */
    .nav-link i {
        transition: transform 0.3s ease; /* 부드러운 애니메이션 효과 */
    }

    /* 마우스를 올렸을 때 아이콘 크기 증가 */
    .nav-link:hover i {
        transform: scale(1.5); /* 아이콘 크기를 1.5배로 확대 */
    }
</style>