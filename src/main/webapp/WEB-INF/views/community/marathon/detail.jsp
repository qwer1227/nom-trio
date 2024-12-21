<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<script type="text/javascript"
				src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3af1f449b9175825b32af2e204b65779&libraries=services,clusterer,drawing"></script>

<!doctype html>
<html lang="ko">
<style>
    #marathon-table th {
        text-align: center;
    }

    #marathon-table tr {
        height: 40px;
    }

    #marathon-content {
        margin-left: 10px;
        margin-top: 10px;
        margin-bottom: 10px;
        padding-left: 50px;
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
</style>
<head>
	<%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
	
	<h2> 마라톤 정보 상세페이지 </h2>
	
	<input type="hidden" id="location" value="${marathon.place}">
	<div>
		<div class="col d-flex justify-content-between align-items-center">
			<div>
				<a href="main" style="text-decoration-line: none">마라톤 정보</a>
			</div>
		</div>
		<div class="title h4 d-flex justify-content-between align-items-center">
			<div>
				${marathon.title}
				<c:if test="${marathon.endDate.time < now.time}">
					<span class="badge text-bg-secondary">마감</span>
				</c:if>
			</div>
			<span><i class="bi bi-eye"></i> ${marathon.viewCnt}</span>
		</div>
		<div class="meta d-flex justify-content-between">
			<fmt:formatDate value="${marathon.createdDate}" pattern="yyyy.MM.dd hh:mm:ss"/>
		</div>
		
		<div style="margin-top: 10px; border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
		
		<div class="row mt-1">
			<table id="marathon-table" class="text-start">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
				<tr>
					<th>일시</th>
					<td><fmt:formatDate value="${marathon.marathonDate}" pattern="yyyy년 MM월 dd일"/></td>
					<th>접수기간</th>
					<td><fmt:formatDate value="${marathon.startDate}" pattern="yyyy년 MM월 dd일"/> ~ <fmt:formatDate
						value="${marathon.endDate}" pattern="yyyy년 MM월 dd일"/></td>
				</tr>
				<tr>
					<th>주최</th>
					<td>${host}</td>
					<th>주관</th>
					<td>${organizer}</td>
				</tr>
				<tr>
					<th>홈페이지</th>
					<td><a href="https://${marathon.url}" target="_blank">${marathon.url}</a></td>
				</tr>
				<tr>
					<th>장소</th>
					<td colspan="3">${marathon.place}</td>
				</tr>
				</tbody>
			</table>
			
			<div class="content m-3">
				<div>
					<img src="${marathon.thumbnail}" style="height: 350px">
				</div>
				<div id="marathon-content">
					<p>${marathon.content}</p>
				</div>
				<div class=" d-flex justify-content-center">
					<div class="col-6 mb-2" id="map" style="height: 250px; width: 500px"></div>
				</div>
			</div>
		</div>
		
		<div style="border-bottom: 1px solid #ccc; margin-bottom: 10px;"></div>
		
		<div class="row">
			<div class="col d-flex justify-content-between">
				<!-- 로그인 여부를 체크하기 위해 먼저 선언 -->
				<div class="d-flex justify-content-start">
					<security:authorize access="isAuthenticated()">
					<security:authentication property="principal" var="loginUser"/>
						<!-- principal 프로퍼티 안의 loginUser 정보를 가져옴 -->
						<!-- loginUser.no를 가져와서 조건문 실행 -->
						<c:if test="${loginUser.nickname eq '관리자'}">
							<button class="btn btn-warning" onclick="updateMarathon(${marathon.no})" style="margin-right: 10px;">수정
							</button>
							<button class="btn btn-danger" onclick="deleteMarathon(${marathon.no})" style="margin-right: 10px;">삭제
							</button>
						</c:if>
					</security:authorize>
				</div>
				<div class="d-flex justify-content-end">
					<a type="button" href="main" class="btn btn-secondary">목록</a>
				</div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
    let content = document.getElementById("content");
    if (content) {
        content.style.height = 'auto'
        content.style.height = content.scrollHeight + 'px';
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

    function updateMarathon(marathonNo) {
        let result = confirm("해당 마라톤 정보 게시글을 수정하시겠습니까?");
        if (result) {
            window.location.href = "modify?no=" + marathonNo;
        }
    }

    function deleteMarathon(marathonNo) {
        let result = confirm("해당 마라톤 정보 게시글을 삭제하시겠습니까?");
        if (result) {
            window.location.href = "delete?no=" + marathonNo;
        }
    }
</script>
</html>