<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <style>
        /*메인이미지 캐러셀*/
        .carousel-image-container {
            width: 100%;
            height: 70vh; /* 뷰포트 높이의 50%로 설정 */
        }

        /* 이미지 위에 아이콘 버튼을 겹치도록 */
        .icon-overlay {
            position: absolute;
            top: 10px;
            right: 10px;
        }

        /* 카드 제목과 텍스트를 명확히 구분 */
        .card-body h5, .card-body p {
            margin: 0;
        }

        /* 광고 팝업 스타일 */
        .ad-popup {
            position: fixed;
            bottom: 100px;
            right: 100px;
            width: 300px;
            background-color: #f8f9fa;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
        }

        .ad-popup img {
            width: 100%;
            border-radius: 8px 8px 0 0;
        }

        .ad-popup .popup-content {
            padding: 15px;
        }

        .ad-popup .popup-content h5 {
            font-size: 1.1rem;
            margin-bottom: 10px;
        }

        .ad-popup .popup-content p {
            font-size: 0.9rem;
        }

        .btn-close {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        }


    </style>
    <title>습습후후</title>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<main>
    <!-- 메인 이미지 캐러셀 -->
    <div id="main-carousel" class="carousel slide">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#main-carousel" data-bs-slide-to="0" class="active"
                    aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#main-carousel" data-bs-slide-to="1"
                    aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#main-carousel" data-bs-slide-to="2"
                    aria-label="Slide 3"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <div class="carousel-image-container">
                    <img src="../../resources/img/main3.jpg" class="d-block w-100" alt="..."
                         style="object-fit: cover; width: 100%; height: 680px;"/>
                </div>
            </div>
            <div class="carousel-item">
                <div class="carousel-image-container">
                    <img src="../../resources/img/main2.jpg" class="d-block w-100" alt="..."
                         style="object-fit: cover; width: 100%; height: 680px;"/>
                </div>
            </div>
            <div class="carousel-item">
                <div class="carousel-image-container">
                    <img src="../../resources/img/main1.jpg" class="d-block w-100" alt="..."
                         style="object-fit: cover; width: 100%; height: 680px;"/>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#main-carousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#main-carousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

    <section class="container my-5">
        <div class="row">
            <div class="col-10 d-flex align-items-center">
                <h3>베스트 상품 랭킹</h3>
            </div>
            <div class="col-2 d-flex justify-content-end">
                <button class="btn btn-outline-dark" type="button" data-bs-target="#weeklyRankingCarousel"
                        data-bs-slide="prev">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <button class="btn btn-outline-dark" type="button" data-bs-target="#weeklyRankingCarousel"
                        data-bs-slide="next">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>
        <!-- 가로 구분선 추가 -->
        <div class="border-bottom my-3"></div>

        <div id="weeklyRankingCarousel" class="carousel slide mt-3" data-bs-ride="carousel">
            <div class="carousel-inner">
                <!-- 첫 번째 페이지 -->
                <div class="carousel-item active">
                    <div class="row">
                        <c:forEach var="product" items="${bestByRating}" varStatus="status">
                            <div class="col-md-3">
                                <div class="card position-relative border-0">
                                    <a href="/product/hit?no=${product.no}&colorNo=${product.colorNum}">
                                        <img src="${product.imgThum}" class="card-img-top" alt="상품 1">
                                    </a>
                                    <div class="card-body">
                                        <!-- 상품명과 순위 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h5 class="card-title mb-0 fw-bold">${product.name}</h5>
                                            <span class="fw-bold">#${status.index + 1}</span> <!-- 순위 -->
                                        </div>

                                        <!-- 브랜드명과 상태 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>${product.brand.name}</span> <!-- 브랜드명 -->
                                            <span class="text-danger">${product.status}</span> <!-- 판매 상태 -->
                                        </div>

                                        <!-- 가격과 평점 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between">
                                            <p class="card-text fw-bold mb-0">￦${product.price}</p> <!-- 가격 -->
                                            <p class="mb-0 fw-bold text-warning">★${product.rating}</p> <!-- 평점 -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>


                <!-- 두 번째 페이지 -->
                <div class="carousel-item">
                    <div class="row">
                        <c:forEach var="product" items="${bestByRating}" varStatus="status">
                            <div class="col-md-3">
                                <div class="card position-relative border-0">
                                    <a href="/product/hit?no=${product.no}&colorNo=${product.colorNum}">
                                        <img src="${product.imgThum}" class="card-img-top" alt="상품 1">
                                    </a>
                                    <div class="card-body">
                                        <!-- 상품명과 순위 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h5 class="card-title mb-0 fw-bold">${product.name}</h5>
                                            <span class="fw-bold">#${status.index + 1}</span> <!-- 순위 -->
                                        </div>

                                        <!-- 브랜드명과 상태 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>${product.brand.name}</span> <!-- 브랜드명 -->
                                            <span class="text-danger">${product.status}</span> <!-- 판매 상태 -->
                                        </div>

                                        <!-- 가격과 평점 한 줄로 배치 -->
                                        <div class="d-flex justify-content-between">
                                            <p class="card-text fw-bold mb-0">￦${product.price}</p> <!-- 가격 -->
                                            <p class="mb-0 fw-bold text-warning">★${product.rating}</p> <!-- 평점 -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container">
        <div class="row">
            <!-- 러닝화 주간 랭킹 -->
<div class="col-md-6 mb-4">
    <h3>러닝화 주간 랭킹</h3>
    <div class="border-bottom my-3"></div>
    <ul class="list-group border-0">
        <c:forEach var="product" items="${bestByViewCount}" varStatus="status">
            <li class="list-group-item d-flex align-items-center border-0">
                <!-- 자동 순위 표시 -->
                <span class="fw-bold me-3">#${status.index + 1}</span>
                <a href="/product/hit?no=${product.no}&colorNo=${product.colorNum}"
                   class="text-decoration-none">
                    <img src="${product.imgThum}" alt="러닝화 ${status.index + 1}" width="50" class="me-3">
                    <span class="text-muted">${product.name}</span>
                </a>

                <!-- 순위 변동 아이콘 -->
                <span class="ms-auto">
                    <c:choose>
                        <c:when test="${product.rankChange > 0}">
                            <i class="bi bi-arrow-up text-success"></i> <!-- 상승 -->
                        </c:when>
                        <c:when test="${product.rankChange < 0}">
                            <i class="bi bi-arrow-down text-danger"></i> <!-- 하강 -->
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-dash text-muted"></i> <!-- 변동 없음 -->
                        </c:otherwise>
                    </c:choose>
                </span>
            </li>
        </c:forEach>
    </ul>
</div>


            <!-- 마라톤 정보 -->
            <div class="col-md-6 mb-4">
                <h3>최신 마라톤 정보</h3>
                <!-- 제목에 구분선 없이 내용에만 구분선 추가 -->
                <table class="table" style="table-layout: fixed;">
                    <tbody>
                    <c:forEach var="marathon" items="${latestMarathons}">
                        <tr>
                            <td class="w-25">
                                <fmt:formatDate value="${marathon.marathonDate}" pattern="yyyy-MM-dd"/>
                            </td>
                            <td class="w-50">${marathon.title}</td>
                            <td class="w-25">
                                <fmt:formatDate value="${marathon.startDate}" pattern="yyyy-MM-dd"/>
                                ~
                                <fmt:formatDate value="${marathon.endDate}" pattern="yyyy-MM-dd"/>
                            </td>
                            <td class="w-25">
                                <!-- 버튼에 w-100 클래스를 사용하여 버튼 너비 확장 및 줄바꿈 방지 -->
                                <a href="/community/marathon/hit?no=${marathon.no}"
                                   class="btn btn-sm btn-dark text-decoration-none w-50"
                                   style="white-space: nowrap;">확인</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <section class="container">
        <div class="row">
            <!-- 커뮤니티 게시판 -->
            <div class="col-md-9 mb-4">
                <h3>실시간 인기 게시글</h3>
                <table class="table">
                    <tbody>
                    <c:forEach var="board" items="${topViewedBoards}" varStatus="status">
                        <tr>
                            <!-- 제목 -->
                            <td class="w-50">
                                <a href="/community/board/hit?no=${board.no}" class="text-decoration-none"
                                   style="color: black;">
                                        ${board.title}
                                </a>
                            </td>
                            <!-- 작성자 -->
                            <td class="w-25 text-right">
                                <a>${board.user.nickname}</a>
                            </td>
                            <!-- 작성 날짜 -->
                            <td class="w-15 text-right">
                                <a>
                                    <fmt:formatDate value="${board.createdDate}" pattern="yyyy-MM-dd"/>
                                </a>
                            </td>
                            <!-- 조회수 -->
                            <td class="w-10 text-right">
                                <a>${board.viewCnt}</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>


            <!-- 사용자 랭킹 -->
            <div class="col-md-3 mb-4">
                <h3>최다 작성자 랭킹</h3>
                <table class="table table-borderless user-ranking-table">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>닉네임</th>
                        <th>작성글수</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="board" items="${userRankingByBoards}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${board.user.nickname}</td>
                            <td>${board.boardCnt}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>


        </div>
    </section>

    <!-- 코스 목록 -->
    <section class="container">
        <h3>추천 코스 목록</h3>
        <div class="border-bottom my-3"></div>
        <div class="row">
            <c:forEach var="course" items="${topLikedCourses}">
                <div class="col-md-4 mb-4">
                    <div class="card border-0">
                        <div class="card-body">
                            <a href="/course/detail?no=${course.no}" class="text-decoration-none">
                                <!-- 이미지와 이름 사이 여백 추가 -->
                                <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/course/${course.filename}"
                                     class="d-block w-100 mb-3" alt="SEUB2HU2 ls">
                            </a>

                            <!-- 코스 이름과 레벨을 한 줄로 배치 -->
                            <div class="d-flex justify-content-between">
                                <h5 class="card-title text-muted fw-bold mb-0">${course.name}</h5>
                                <span class="text-muted fw-bold">${course.level}단계</span>
                            </div>

                            <!-- 지역과 거리 정보를 한 줄로 배치 -->
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">${course.region.si} ${course.region.gu} ${course.region.dong}</span>
                                <span class="text-muted">${course.distance}KM</span>
                            </div>

                            <!-- 시간과 좋아요 개수를 한 줄로 배치 -->
                            <div class="d-flex justify-content-between">
                                <span class="text-muted fw-bold">#평균_완주_기록_${course.time}분</span>
                                <span class="text-danger fw-bold">♥ ${course.likeCnt}</span>
                            </div>

                            <!-- 바로가기 버튼 -->
                            <a href="/course/detail?no=${course.no}" class="btn btn-dark text-white mt-3 w-100">바로가기</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>


    <!-- 광고 팝업 -->
    <div class="ad-popup">
        <div id="lessonCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <!-- 반복문으로 슬라이드 생성 -->
                <c:forEach var="lesson" items="${ongoingLessons}" varStatus="status">
                    <div class="carousel-item ${status.first ? 'active' : ''}">
                            <img src="${s3}/resources/images/lesson/${lesson.filename}"
                                 id="Thumbnail" alt="Thumbnail" style="width: 100%; height: 300px;" class="d-block w-100"/>
                        <div class="popup-content text-center">
                            <h5>${lesson.title}</h5>
                            <p>#${lesson.subject} #${lesson.place}</p>
                            <p>${lesson.start} ~ ${lesson.end}</p>
                            <a href="/lesson/detail?lessonNo=${lesson.lessonNo}"
                               class="btn btn-dark text-white">예약하기</a>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 캐러셀 제어 버튼 -->
            <button class="carousel-control-prev" type="button" data-bs-target="#lessonCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#lessonCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
        <!-- 닫기 버튼 -->
        <div class="icon-overlay d-flex justify-content-center" style="z-index: 10 !important;">
            <button type="button" class="btn-close" aria-label="Close" id="closeAdPopup"></button>
        </div>
    </div>


    <!-- 우측 하단 세로 배치 버튼 -->
    <div class="position-fixed bottom-0 end-0 p-3">

        <!-- 탑 버튼 -->
        <a href="#top" class="btn btn-dark text-light px-3 py-2 rounded-3 d-block" style="width: 45px;" title="상단으로 가기">
            <i class="bi bi-arrow-up me-2"></i>
        </a>
    </div>


</main>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 버튼과 팝업 요소 가져오기
        const closeButton = document.getElementById("closeAdPopup");
        const adPopup = document.querySelector(".ad-popup");

        // 닫기 버튼 클릭 시 팝업 숨기기
        closeButton.addEventListener("click", function () {
            adPopup.classList.add("d-none"); // 팝업 숨기기
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        // 위시리스트 버튼 클릭 이벤트 처리
        document.body.addEventListener("click", function (event) {
            const button = event.target.closest(".wish-add"); // 클릭된 요소가 wish-add 클래스인지 확인
            if (button) {
                const form = button.closest(".form-cart"); // 버튼과 연결된 폼 가져오기
                form.setAttribute("action", "/wish"); // 폼 액션 설정
                form.submit(); // 폼 제출
            }
        });
    });


</script>
</body>
</html>
