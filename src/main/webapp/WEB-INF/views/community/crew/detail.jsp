<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<script type="text/javascript"
				src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3af1f449b9175825b32af2e204b65779&libraries=services,clusterer,drawing"></script>
<!doctype html>
<html lang="ko">
<head>
	<%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
    #inviting-table th {
        text-align: center;
    }

    #inviting-table tr {
        height: 50px;
    }

    /* 툴팁 스타일 (처음에는 숨겨져 있음) */
    #hover-box {
        display: none; /* 기본적으로 툴팁 숨김 */
        position: absolute;
        top: 100%; /* 버튼 바로 아래에 위치 */
        right: 0%;
        transform: translateX(-50%); /* 툴팁을 버튼의 중앙에 맞춤 */
        background-color: rgba(0, 0, 0, 0.7); /* 배경 색상 */
        color: white; /* 글씨 색상 */
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        white-space: nowrap; /* 내용이 길어도 줄바꿈 하지 않음 */
        z-index: 10; /* 툴팁을 다른 요소 위에 표시 */
    }

    /* 버튼에 마우스를 올렸을 때 툴팁 표시 */
    .btn-outline-primary:hover + #hover-box {
        display: block;
    }

    /* 툴팁이 나타날 때 다른 콘텐츠가 영향을 받지 않도록 */
    #fileDown:hover {
        z-index: 20; /* 버튼과 툴팁 위로 다른 요소들이 오지 않도록 설정 */
        position: relative; /* 툴팁을 버튼을 기준으로 설정 */
    }

    table th {
        text-align: center;
    }

    table tr {
        height: 50px;
    }

    .auto-resize {
        border: none; /* 테두리 제거 */
        box-shadow: none; /* 그림자 제거 */
        resize: none; /* 크기 조정 막기 */
        overflow: hidden; /* 스크롤바 숨기기 */
    }

    .auto-resize:focus {
        outline: none; /* 포커스 시 외곽선 제거 */
    }

</style>
<body>
<div>
	<%@include file="/WEB-INF/views/common/nav.jsp" %>
	<div class="container-xxl text-center" id="wrap">
		
		<h2> 크루모임 글 상세페이지 </h2>
		<input type="hidden" id="location" value="${crew.location}">
		<input type="hidden" id="typeNo" value="${crew.no}">
		<input type="hidden" id="type" value="crew">
		<div>
			<div class="col d-flex d-flex justify-content-between">
				<div>
					<a href="main?category=${crew.entered}">${crew.entered eq 'Y' ? '모집중' : '모집마감'}</a>
				</div>
			</div>
			<div class="title h4 d-flex justify-content-between align-items-center">
				<div>
					${crew.title}
				</div>
				<span class="h5">
          <i class="bi bi-eye"></i> ${crew.viewCnt}
          <i class="bi bi-chat-square-text"></i> ${replyCnt}
        </span>
			</div>
			<div class="meta d-flex justify-content-between mb-3">
      <span>
         ${crew.user.nickname} | <fmt:formatDate value="${crew.createdDate}" pattern="yyyy.MM.dd hh:mm:ss"/>
      </span>
				<div class="meta d-flex justify-content-between">
					<c:if test="${not empty crew.uploadFile.originalName}">
						<div class="content mb-4" id="fileDown" style="text-align: end">
							<a href="filedown?no=${crew.no}" class="btn btn-outline-primary btn-sm">첨부파일 다운로드</a>
							<span id="hover-box">${crew.uploadFile.originalName}</span>
						</div>
					</c:if>
				</div>
			</div>
			<div class="content mb-3" style="text-align: start">
				<div class="row">
					<div class="col-6 mb-2" id="map" style="height: 250px; width: 500px"></div>
					<div class="col-6">
						<table style="width: 100%">
							<colgroup>
								<col width="15%">
								<col width="*">
							</colgroup>
							<tbody>
							<tr>
								<th>크루명</th>
								<td>: ${crew.name}</td>
							</tr>
							<tr>
								<th>크루장</th>
								<td>: ${crew.user.nickname}</td>
							</tr>
							<tr>
								<th>일 시</th>
								<td>: ${crew.schedule}</td>
							</tr>
							<tr>
								<th>장 소</th>
								<td>: ${crew.location}</td>
							</tr>
							<tr>
								<th>가 입</th>
								<td>: ${memberCnt} / 5
									<c:if test="${memberCnt == 5}">
										<button class="btn btn-secondary">모임 마감</button>
									</c:if>
									<security:authorize access="isAuthenticated()">
										<security:authentication property="principal" var="loginUser"/>
										<c:if test="${loginUser.no ne crew.user.no}">
											<c:choose>
												<c:when test="${isExists}">
													<button id="btn-crew-leave" class="btn btn-danger btn-sm"
																	onclick="crewLeaveButton(${crew.no})">
														모임 탈퇴
													</button>
												</c:when>
												<c:otherwise>
													<button id="btn-crew_join" class="btn btn-primary btn-sm"
																	onclick="crewJoinButton(${crew.no})">
														모임 가입
													</button>
												</c:otherwise>
											</c:choose>
										</c:if>
									</security:authorize></td>
							</tr>
							</tbody>
						</table>
					</div>
					<div>
						<p>${crew.description}</p>
					</div>
				</div>
			</div>
			
			<div class="row actions mb-4">
				
				<!-- 로그인 여부를 체크하기 위해 먼저 선언 -->
				
				<div class="col-6 d-flex justify-content-start">
					<security:authorize access="isAuthenticated()">
						<!-- principal 프로퍼티 안의 loginUser 정보를 가져옴 -->
						<!-- loginUser.no를 가져와서 조건문 실행 -->
						<div>
							<c:if test="${loginUser.no eq crew.user.no}">
								<button class="btn btn-warning" onclick="updateCrew(${crew.no})">수정</button>
								<button class="btn btn-danger" style="margin-left: 5px" onclick="deleteCrew(${crew.no})">삭제</button>
							</c:if>
							<c:if test="${loginUser.no ne crew.user.no}">
								<button type="button" class="btn btn-danger" onclick="report('crew', ${crew.no})">신고</button>
							</c:if>
						</div>
					</security:authorize>
				</div>
				<div class="col-6 d-flex justify-content-end">
					<a type="button" href="main" class="btn btn-secondary">목록</a>
				</div>
			</div>
		
		</div>
		
		<!-- 댓글 작성 -->
		<%@include file="../reply-form.jsp" %>
		
		<!-- 댓글 목록 -->
		<c:if test="${not empty crew.reply}">
		
			<div class="row comments rounded" style="background-color: #f2f2f2">
				<!--댓글 내용 -->
				<c:forEach var="reply" items="${replies}">
					<%@include file="../reply-lists.jsp" %>
				</c:forEach>
			</div>
		</c:if>
	
	<!-- 신고 모달 창 -->
	<%@include file="/WEB-INF/views/community/report-modal.jsp" %>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
    let formData = new FormData();

    const myModalRepoter = new bootstrap.Modal('#modal-reporter')

    function updateCrew(crewNo) {
        let result = confirm("해당 크루 모임글을 수정하시겠습니까?");
        if (result) {
            window.location.href = "modify?no=" + crewNo;
        }
    }

    function deleteCrew(crewNo) {
        let result = confirm("해당 크루 모임글을 삭제하시겠습니까?");
        if (result) {
            window.location.href = "delete?no=" + crewNo;
        }
    }

    async function report(type, no) {
        let response = await fetch("/community/crew/report-check?type=" + type + "&no=" + no, {
            // 요청방식을 지정한다.
            method: "GET",
            // 요청메세지의 바디부에 포함된 컨텐츠의 형식을 지정한다.
            headers: {
                "Content-Type": "application/json"
            }
        });

        if (response.ok) {
            let exists = await response.text();

            if (exists === "yes") {
                // 신고한 내역이 있으면
                alert("이미 신고한 내역이 있습니다");
            } else {
                // 신고한 내역이 없으면 모달창 보이기
                document.querySelector(".modal input[name=type]").value = type;
                document.querySelector(".modal input[name=no]").value = no;

                if (type === 'crew') {
                    $(".modal form").attr('action', 'report-crew');
                }
                if (type === 'crewReply') {
                    $(".modal form").attr('action', 'report-reply');
                }

                myModalRepoter.show();
            }
        }
    }

    function reportButton() {
        if (document.querySelector("#reason-etc").checked) {
            document.querySelector("#reason-etc").value = document.querySelector("#etc").value;
        }
        $(".modal form").trigger("submit");
    }

    function replyLikeButton(crewNo, replyNo) {
        let heart = document.querySelector("#icon-thumbs-" + replyNo);
        let isLiked = heart.classList.contains("bi-hand-thumbs-up");

        // AJAX 요청 준비
        $.ajax({
            method: "POST",
            url: isLiked ? `update-reply-like` : `delete-reply-like`,
            data: {
                no: crewNo,
                rno: replyNo,
            },
            success: function (response) {
                // 서버 응답이 성공적이면 좋아요 상태를 변경
                if (isLiked) {
                    heart.classList.remove("bi-hand-thumbs-up");
                    heart.classList.add("bi-hand-thumbs-up-fill");
                } else {
                    heart.classList.remove("bi-hand-thumbs-up-fill");
                    heart.classList.add("bi-hand-thumbs-up");
                }
            }
        });
    }

    /* 버튼 클릭 시 답글 입력 폼 활성화 */
    function appendComment(replyNo) {
        let box = document.querySelector("#box-comments-" + replyNo);
        box.classList.toggle("d-none");
    }

    function crewJoinButton(crewNo) {
        let result = confirm("해당 모임에 가입하시겠습니까?");
        if (result) {
            window.location.href = "enter-crew?no=" + crewNo;
        }
    }

    function crewLeaveButton(crewNo) {
        let result = confirm("가입된 해당 모임을 탈퇴하시겠습니까?");
        if (result) {
            window.location.href = "leave-crew?no=" + crewNo;
        }
    }

    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
    var options = { //지도를 생성할 때 필요한 기본 옵션
        center: new kakao.maps.LatLng(37.572990, 126.992240), //지도의 중심좌표.
        level: 3 //지도의 레벨(확대, 축소 정도)
    };

    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
    let loc = document.querySelector("#location").value
    var ps = new kakao.maps.services.Places();
    ps.keywordSearch(loc, placesSearchCB);

    function placesSearchCB(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
            // LatLngBounds 객체에 좌표를 추가합니다
            var bounds = new kakao.maps.LatLngBounds();

            displayMarker(data[0]);
            bounds.extend(new kakao.maps.LatLng(data[0].y, data[0].x));

            // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
            map.setBounds(bounds);
        }
    }

    // 지도에 마커를 표시하는 함수입니다
    function displayMarker(place) {
        // 마커를 생성하고 지도에 표시합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: new kakao.maps.LatLng(place.y, place.x)
        });
    }
</script>
</html>