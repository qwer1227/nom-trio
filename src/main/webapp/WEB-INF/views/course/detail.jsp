<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
    <%-- 코스 상세 정보 --%>
    <div class="row">
        <div class="col-5">
            <table class="table table-bordered">
                <div class="card">
                    <div class="card-header">${course.name}</div>
                </div>
                <tbody>
                <tr>
                    <th scope="row">코스 지역</th>
                    <td>${course.region.si} ${course.region.gu} ${course.region.dong}</td>
                </tr>
                <tr>
                    <th scope="row">코스 거리</th>
                    <td>${course.distance}KM</td>
                </tr>
                <tr>
                    <th scope="row">평균 완주 시간</th>
                    <td>${course.time}분</td>
                </tr>
                <tr>
                    <th scope="row">코스 난이도</th>
                    <td>${course.level}단계</td>
                </tr>
                </tbody>
            </table>

            <%-- 좋아요! 버튼을 클릭하면, 좋아요 수가 증가하거나 감소한다. --%>
            <div class="row mt-3 mb-3 justify-content-center">
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${isLike eq true}">
                        <a href="controlLikeCount?courseNo=${course.no}" class="btn btn-primary ${isSuccess ? "" : "disabled"}" style="width: 100px;">
                            <i class="bi bi-hand-thumbs-up">좋아요!</i>
                        </a>
                        <span>( 코스 완주자만 좋아요!를 클릭할 수 있습니다. )</span>
                    </c:if>
                    <c:if test="${isLike eq false}">
                        <a href="controlLikeCount?courseNo=${course.no}" class="btn btn-outline-primary ${isSuccess ? "" : "disabled"}" style="width: 100px;">
                            <i class="bi bi-hand-thumbs-up">좋아요!</i>
                        </a>
                        <span>( 코스 완주자만 좋아요!를 클릭할 수 있습니다. )</span>
                    </c:if>
                </sec:authorize>
                <span>좋아요 수 : ${course.likeCnt}개</span>
            </div>

            <%-- 코스 완주 시, 완주 성공 표시 --%>
            <div class="row mt-3 mb-3 justify-content-center">
                <c:if test="${isSuccess == true}">
                    <span class="badge text-bg-primary" style="width: 100px; font-size: 20px; justify-content: center; align-items: center; display: flex;">
                        완주 성공!
                    </span>
                </c:if>
            </div>

            <%-- 코스 도전 가능 여부 표시 --%>
            <div class="row justify-content-center">
                <sec:authorize access="isAuthenticated()">
                    <c:choose>
                        <%-- 현재 도전 가능한 단계(난이도)가 코스 난이도보다 적으면, 안내 문구를 표시한다. --%>
                        <c:when test="${currentUserLevel < course.level}">
                            <button class="btn btn-danger disabled" style="width: 200px;">아직 도전할 수 없습니다!</button>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <%-- 사용자가 코스 도전 등록을 했다면 등록 취소 버튼을 표시하고, 클릭하면 코스 등록을 취소한다. --%>
                                <c:when test="${isChallenge == true}">
                                    <a href="changeChallenge?courseNo=${course.no}" class="btn btn-danger"
                                       style="width: 100px;" onclick="cancelChallenge(event)">등록 취소</a>
                                </c:when>
                                <%-- 사용자가 코스 도전 등록을 하지 않았다면 등록하기 버튼을 표시하고, 클릭하면 코스를 등록한다. --%>
                                <c:otherwise>
                                    <a href="changeChallenge?courseNo=${course.no}" class="btn btn-warning"
                                       style="width: 100px;" onclick="registerChallenge(event)">등록하기</a>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </sec:authorize>
            </div>
        </div>
        <div class="col-1"></div>
        <div class="col-6">
            <div class="card">
                <div class="card-body">
                    <div class="row mb-1">
                        <div class="col">
                            <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/course/${course.filename}" class="img-thumbnail">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 코스 리뷰 목록 --%>
    <div class="card mt-5" id="review">
        <div class="card-header">
            코스 리뷰
            <div class="text-end">
                 <sec:authorize access="isAuthenticated()">
                     <sec:authentication property="principal" var="loginUser" />
                     <button class="btn btn-primary" onclick="openAddReviewFormModal()">리뷰 작성</button>
                 </sec:authorize>
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-12" id="box-reviews"></div>
            </div>
        </div>
    </div>

    <%-- 코스 리뷰 목록 - 페이징 처리 --%>
    <div class="row mb-3">
        <div class="col-12">
            <nav>
                <ul class="pagination justify-content-center" id="paging"></ul>
            </nav>
        </div>
    </div>
</div>

<%-- 코스 리뷰 등록 Modal창 --%>
<div class="modal fade" id="modal-add-review-form" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">코스 리뷰 등록하기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <%-- 리뷰 내용을 입력하고 등록한다. --%>
            <div class="modal-body">
                <form method="post" action="/addReview" enctype="multipart/form-data">
                    <input type="hidden" name="courseNo" value="${course.no }" />
                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" class="form-control" name="title"/>
                    </div>
                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea rows="4" class="form-control" name="content"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">코스 사진 업로드</label>
                        <input type="file" class="form-control" name="upfile" multiple="multiple"/>
                        <div><strong style="color:red;">＊ 컨트롤(Ctrl)을 누른 채로 사진 여러 개 클릭</strong></div>
                        <div><strong style="color:red;">＊ 한 번 등록한 리뷰는 수정할 수 없습니다.</strong></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="submit" class="btn btn-primary" onclick="submitReview()">등록</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
    // 등록하기 버튼을 클릭하면, 확인창을 표시한다.
    function registerChallenge(event) {
        if (confirm("도전할 코스 목록에 추가하시겠습니까?")) {
            alert("도전할 코스 목록에 추가되었습니다!");
        } else {
            event.preventDefault();
        }
    }

    // 등록 취소 버튼을 클릭하면, 확인창을 표시한다.
    function cancelChallenge(event) {
        if (confirm("도전할 코스 목록에서 제외하시겠습니까?")) {
            alert("도전할 코스 목록에서 제외되었습니다!");
        } else {
            event.preventDefault();
        }
    }

    // Modal창을 정의한다.
    const addReviewFormModal = new bootstrap.Modal('#modal-add-review-form');

    // 코스 리뷰 등록 Modal창을 연다.
    async function openAddReviewFormModal() {
        addReviewFormModal.show();
    }

    // 리뷰 목록이 화면에 표시된다.
    async function getReviews(page, event) {
        document.querySelector("#box-reviews").innerHTML = "";

        if (event) {
            event.preventDefault();
        }
        // 1. 코스 번호를 가져온다.
        let courseNo = document.querySelector("input[name=courseNo]").value;

        // 2. 코스에 해당하는 리뷰를 가져오고, javascript 객체로 변환한다.
        let response = await fetch("/ajax/reviews/" + courseNo + "/" + page);
        let result = await response.json();

        // 3. 리뷰 목록, 페이징 처리 기능을 화면에 표시한다.
        let reviews = result.data.data;
        let paging = result.data.paging;

        // 4. 리뷰가 있는 경우와 없는 경우를 구분해서 처리한다.
        if (reviews.length > 0) {
            for (let review of reviews) {
                appendReview(review);
            }
            pagingReviews(paging);
        } else {
            let box = document.querySelector("#box-reviews");
            box.innerHTML = "리뷰가 없습니다.";
        }

    }

    // 코스 상세 페이지에 접속할 때마다 리뷰 목록이 1페이지가 나타나게 한다.
    getReviews(1);

    // 입력한 코스 리뷰 정보(코스번호, 제목, 내용, 첨부파일)를 컨트롤러에 제출한다.
    async function submitReview() {
        // 1. 입력한 코스 리뷰 정보를 가져온다.
        let courseNo = document.querySelector("input[name=courseNo]").value;
        let title = document.querySelector("input[name=title]").value;
        let content = document.querySelector("textarea[name=content]").value;
        let upfiles = document.querySelector("input[name=upfile]").files;

        // 2. 리뷰 제목과 리뷰 내용이 없다면, 경고 메시지를 출력한다.
        if (title === "" || content === "") {
            alert("제목과 내용 작성은 필수입니다.");
            return;
        }

        // 3. 입력한 코스 리뷰 정보를 formData 객체에 저장한다.
        let formData = new FormData();

        formData.append("courseNo", courseNo);
        formData.append("title", title);
        formData.append("content", content);
        for (let i = 0; i < upfiles.length; i++) {
            let upfile = upfiles[i];
            formData.append("upfiles", upfile);
        }

        // 4. formData(입력한 코스 리뷰 정보)를 서버에 보낸다.
        let response = await fetch("/ajax/addReview", {
            method: "POST",
            body: formData
        });

        // 5. 요청 처리 성공 확인 후, 입력한 리뷰를 화면에 표시한다.
        if (response.ok) {
            let review = await response.json();
            appendReview(review);

            addReviewFormModal.hide();
        }
    }

    // 입력한 리뷰를 화면에 표시한다.
    function appendReview(review) {
        // 1. 리뷰를 화면에 표시한다.
        let content = `
            <div class="card mb-3" id="review-\${review.no}">
	            <div class="card-header">
	                <span style="float: left;">\${review.title}</span>
	                <span style="float: right;">
	                    <small><strong style="color: blue;">\${review.user.nickname}</strong></small>
	                    <small>\${review.createdDate}</small>
                        <button class="btn btn-danger btn-sm" onclick="removeReview(\${review.no})">삭제</button>
	                </span>
	            </div>
	            <div class="card-body" style="display: flex; flex-direction: column; align-items: flex-start;">
	                <div>\${review.content}</div>
	                <div id="box-images-\${review.no}"></div>
	            </div>
	        </div>
	    `;

        let box = document.querySelector("#box-reviews");
        box.insertAdjacentHTML("beforeend", content);

        // 2. 첨부파일(코스 사진)을 화면에 표시한다.
        let images = review.reviewImage;
        let imgContent = '';
        if (images != null) {
            for (let image of images) {
                imgContent += `
                    <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/courseReviewImages/\${image.name}"
                        class="img-thumbnail" style="width: 100px; height: 100px;"/>
                `;
            }

            let imagesbox = document.querySelector(`#box-images-\${review.no}`);
            imagesbox.insertAdjacentHTML("beforeend", imgContent);
        }
    }

    // 리뷰 목록의 페이징 처리 기능을 구현한다.
    function pagingReviews(paging) {
        let pages = "";

        pages += `
            <li class="page-item \${paging.first ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getReviews(\${paging.prevPage}, event)">이전</a>
            </li>
        `;

        for (let num = paging.beginPage; num <= paging.endPage; num++) {
            pages += `
                <li class="page-item">
                    <a class="page-link \${paging.page == num ? 'active' : ''}"
                       href="" onclick="getReviews(\${num}, event)">\${num}</a>
                </li>
            `;
        }

        pages += `
            <li class="page-item \${paging.last ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getReviews(\${paging.nextPage}, event)">다음</a>
            </li>
        `;

        document.querySelector("#paging").innerHTML = pages;
    }

    // 리뷰를 삭제한다.
    async function removeReview(reviewNo) {
        // 1. 리뷰 번호를 서버에 보낸다.
        let response = await fetch("/ajax/deleteReview/" + reviewNo);

        // 2. 로그인한 사용자와 리뷰 작성자가 동일한 지 확인 후, 리뷰를 삭제한다.
        let result = await response.json();
        let status = result.status;
        let message = result.message;

        if (response.ok) {
            if (status === 500) {
                alert(message); // message = "해당 리뷰 작성자만 삭제 가능합니다"
            } else {
                let div = document.querySelector("#review-" + reviewNo);
                div.remove();
            }
        } else {
            alert(message); // message = "로그인이 필요한 서비스입니다"
        }
    }
</script>
</body>
</html>