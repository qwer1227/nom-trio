<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<style>
    <%-- 폰트 스타일 --%>
    * {
        font-family: 'Noto Sans KR', sans-serif;
    }

    <%-- 푸터 간격 CSS --%>
    html,
    body {
        margin: 0;
        padding: 0;
        height: 100%;
    }

    #wrap {
        min-height: 100%;
        position: relative;
        padding-bottom: 60px;
    }

    footer {
        bottom: 0;
    }
</style>
<nav class="navbar navbar-expand-lg bg-body-tertiary mb-5"
     style="border-top: 2px solid#0064FF; border-bottom:2px solid#0064FF;">
    <div class="container-xxl" style="height: 60px;">
        <a class="navbar-brand" href="/home" style="color: #0064FF;
  font-size: 30px; font-weight: bolder;">습습후후</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup"
                aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
            <div class="navbar-nav ms-auto">
                <div class="dropdown">
                    <a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        상품
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                        <li><a class="dropdown-item" href="/product/list?topNo=10">남성</a></li>
                        <li><a class="dropdown-item" href="/product/list?topNo=20">여성</a></li>
                        <li><a class="dropdown-item" href="/product/list?topNo=30">러닝용품</a></li>
                    </ul>
                </div>

                <div class="divider" style="border-left: 1px solid #0e0d0d; margin: 0 7px;"></div>
                <a class="nav-link fw-bolder" href="/course/list">코스</a>
                <div class="divider" style="border-left: 1px solid #0e0d0d; margin: 0 7px;"></div>
                <a class="nav-link fw-bolder" href="/lesson">레슨</a>
                <div class="divider" style="border-left: 1px solid #0e0d0d; margin: 0 7px;"></div>
                                <div class="dropdown">
                    <a class="btn dropdown-toggle" href="#" role="button" id="dropdownCommunityMenu"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        커뮤
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                        <li><a class="dropdown-item" href="/community/board/main">커뮤니티 홈</a></li>
                        <li><a class="dropdown-item" href="/community/crew/main">크루 모임</a></li>
                        <li><a class="dropdown-item" href="/community/notice/main">공지사항</a></li>
                        <li><a class="dropdown-item" href="/community/marathon/main">마라톤 정보</a></li>
                    </ul>
                </div>
                <div class="divider" style="border-left: 1px solid #0e0d0d; margin: 0 7px;"></div>
                <security:authorize access="hasAuthority('ROLE_ADMIN')">
                    <a class="nav-link" href="/admin/home">관리자 홈</a>
                </security:authorize>

                <security:authorize access="!isAuthenticated()">
                    <a class="nav-link fw-bolder" href="/login">로그인</a>
                </security:authorize>
                <security:authorize access="isAuthenticated()">
                <span class="navbar-text">
						<strong>
							<security:authentication property="principal.nickname"/>
						</strong><small>님</small>
                    </span>
                <ul class="navbar-nav">
                    <a class="nav-link" href="/mypage">마이페이지</a>
                    <a class="nav-link" href="/message/list">쪽지</a>
                    <a class="nav-link " href="/logout">로그아웃</a>
                    </security:authorize>
                    <div style="padding: 0 20px;"></div>
                </ul>
            </div>
        </div>
    </div>
</nav>