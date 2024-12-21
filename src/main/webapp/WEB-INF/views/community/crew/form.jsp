<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3af1f449b9175825b32af2e204b65779&libraries=services,clusterer,drawing"></script>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fengyuanchen.github.io/cropperjs/css/cropper.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://fengyuanchen.github.io/cropperjs/js/cropper.js"></script>

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
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
  
  <h2>크루 모집글 작성</h2>
  
  <div class="row p-3">
    <form method="post" action="register" enctype="multipart/form-data" onkeydown="return event.key !== 'Enter';">
      <table id="inviting-table" style="width: 98%">
        <colgroup>
          <col width="10%">
          <col width="40%">
          <col width="5%">
          <col width="*">
        </colgroup>
        <tbody>
        <tr>
          <th>모집글 제목</th>
          <td><input class="rounded" type="text" name="title" value="" style="width: 83%"></td>
          <th>장소</th>
          <td>
            <input class="rounded" type="text" id="location" value="" name="location"
                   style="width: 90%; vertical-align: middle;">
            <a type="button" class="btn btn-outline-dark btn-sm"
               onclick="searchPlaces(event)" style="vertical-align: middle; width: 50px">검색</a>
          </td>
        </tr>
        <tr>
          <th>크루 이름</th>
          <td><input class="rounded" type="text" name="name" value="" style="width: 83%"></td>
          <th></th>
          <td rowspan="3">
            <div id="map" style="width: 100%; height: 200px" class="mb-2"></div>
          </td>
        </tr>
        <tr>
          <th>일시</th>
          <td>
            <select class="rounded" id="schedule-type" name="type">
              <option value="매월">매월</option>
              <option value="매주">매주</option>
              <option value="매일">매일</option>
              <option value="번개">입력</option>
            </select>
            <input type="text" class="rounded" id="schedule-detail" name="detail" value="" style="width: 70%"
                   placeholder="상세 모임 일시를 작성해주세요.">
          </td>
        </tr>
        <tr>
          <th>대표 이미지</th>
          <td>
            <button type="button" class="btn btn-dark" onclick="thumbnail()">등록</button>
            <input type="hidden" name="image" value="">
          </td>
        </tr>
        <tr>
          <th>게시글</th>
          <td colspan="3">
            <%@include file="../write.jsp" %>
          </td>
        </tr>
        <tr>
          <th>첨부파일</th>
          <td colspan="3">
            <input type="file" class="form-control" name="upfile"/>
        </tr>
        </tbody>
      </table>
      
      <div class="row p-3">
        <div class="col d-flex justify-content-between">
          <div class="col d-flex" style="text-align: start">
            <button type="button" class="btn btn-secondary m-1" onclick="abort()">취소</button>
          </div>
          <div class="col d-flex justify-content-end">
            <button type="button" id="submit" class="btn btn-primary m-1">등록</button>
          </div>
        </div>
      </div>
    </form>
  </div>
  
  <!-- 썸네일 이미지 편집 모달창 -->
  <%@include file="image-crop.jsp" %>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
  // 등록 버튼 클릭 시, 폼에 있는 값을 전달(이미지는 슬라이싱할 때 전달했기 때문에 따로 추가 설정 안해도 됨)
  document.querySelector("#submit").addEventListener("click", function () {
    oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
    
    let title = document.querySelector("input[name=title]").value.trim();
    let description = document.querySelector("textarea[name=ir1]").value.trim();
    let name = document.querySelector("input[name=name]").value.trim();
    let type = document.querySelector("select[name=type]").value;
    let detail = document.querySelector("input[name=detail]").value.trim();
    let location = document.querySelector("input[name=location]").value;
    let upfile = document.querySelector("input[name=upfile]")
    
    let cleanedContent = description.replace(/<p><br><\/p>/g, "").trim();
    
    // 입력값 검증
    if (!title) {
      alert("크루 모집글 제목을 입력해주세요.");
      return;
    }
    if (!cleanedContent) {
      alert("내용을 입력해주세요.");
      return;
    }
    if (!name) {
      alert("크루명을 입력해주세요.");
      return;
    }
    if (!detail) {
      alert("상세 일시를 입력해주세요.");
      return;
    }
    if (!location) {
      alert("모임 장소를 입력해주세요.");
      return;
    }
    
    
    formData.append("title", title);
    formData.append("description", description);
    formData.append("name", name);
    formData.append("type", type);
    formData.append("detail", detail);
    formData.append("location", location);
    if (upfile.files.length > 0) {
      formData.append("upfile", upfile.files[0]);
    }
    
    $.ajax({
      method: "post",
      url: "/community/crew/register",
      data: formData,
      processData: false,
      contentType: false,
      success: function (crew) {
        window.location.href = "detail?no=" + crew.no;
      }
    })
  });
  
  function abort() {
    let result = confirm("글 작성을 취소하시겠습니까? 작성중이던 글은 저장되지 않습니다.");
    if (result) {
      window.location.href = "main";
    }
  }
  
  var geocoder = new kakao.maps.services.Geocoder();
  var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
  var options = { //지도를 생성할 때 필요한 기본 옵션
    center: new kakao.maps.LatLng(37.572990, 126.992240), //지도의 중심좌표.
    level: 3 //지도의 레벨(확대, 축소 정도)
  };
  
  var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
  
  // 지도를 클릭한 위치에 표출할 마커입니다
  var marker = new kakao.maps.Marker({
    // 지도 중심좌표에 마커를 생성합니다
    position: map.getCenter()
  });
  // 지도에 마커를 표시합니다
  marker.setMap(map);
  
  
  // 지도에 클릭 이벤트를 등록합니다
  // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
  kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
    
    // 클릭한 위도, 경도 정보를 가져옵니다
    let latlng = mouseEvent.latLng;
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    
    searchDetailAddrFromCoords(latlng, function (result, status) {
      if (status === kakao.maps.services.Status.OK) {
        let detailAddr = !!result[0].road_address ? result[0].road_address.address_name : '';
        
        document.querySelector("#location").value = detailAddr;
        
      } else {
        alert("유효한 지역이 아닙니다.");
      }
    });
  });
  
  function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
  }
  
  function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
  }
  
  
  // 장소를 입력하고 검색버튼을 클릭했을 때 실행되는 함수
  function searchPlaces(event) {
    // 장소 검색 객체를 생성합니다
    var places = new kakao.maps.services.Places();
    
    // 입력필드에 입력한 장소를 조회한다.
    let keyword = document.querySelector("#location").value
    // Places객체의 keywordSearcc()함수를 실행한다.
    // 매개변수로 장소와 콜백함수를 전달한다.
    places.keywordSearch(keyword, placesSearchCB);
  }
  
  // 키워드 검색 완료 시 호출되는 콜백함수 입니다
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
  
  // 마커를 표시하고, 마커를 클릭했을 때 마커가 표시된 위치의 위경도좌표를 주소 변환해서 입력필드에 표시되게 한다.
  function displayMarker(place) {
    let latlng = new kakao.maps.LatLng(place.y, place.x)
    
    marker.setPosition(latlng);
    marker.latlng = latlng
    
    // 마커를 클릭했을 때 실행할 작업을 지정한다.
    kakao.maps.event.addListener(marker, 'click', function () {
      // 클릭한 마커의 위도 경도 좌표를 알아낸다.
      let latlng = marker.latlng;
      
      // 위도 경도좌표를 주소로 변환하는 함수를 호출한다.
      searchDetailAddrFromCoords(latlng, function (result, status) {
        if (status === kakao.maps.services.Status.OK) {
          // 조회된 주소정보를 입력필드에 표시한다.
          let detailAddr = !!result[0].road_address ? result[0].road_address.address_name : '';
          document.querySelector("#location").value = detailAddr;
        } else {
          alert("유효한 지역이 아닙니다.");
        }
      });
      console.log(marker.latlng)
    });
  }
</script>
</body>
</html>