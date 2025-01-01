<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
	<%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
    #marathon-table th {
        text-align: center;
    }

    #marathon-table tr {
        height: 50px;
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
	
	<h2>마라톤 정보 작성</h2>
	
	<div class="row p-3">
		<form method="post" action="register" enctype="multipart/form-data">
			<table id="marathon-table" style="width: 98%">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
				<tr>
					<th>마라톤 이름</th>
					<td colspan="3"><input type="text" name="title" id="title" style="width: 100%"></td>
				</tr>
				<tr>
					<th>일시</th>
					<td style="text-align: start"><input type="date" name="marathonDate" id="marathonDate" style="width: 40%"></td>
					<th>접수기간</th>
					<td style="text-align: start">
						<input type="date" name="startDate" id="startDate" style="width: 40%">
						~
						<input type="date" name="endDate" id="endDate" style="width: 40%">
					</td>
				</tr>
				<tr>
					<th>장소</th>
					<td colspan="3"><input type="text" name="place" id="place" style="width: 100%"></td>
				</tr>
				<tr>
					<th>주최기관</th>
					<td><input type="text" name="host" id="host" style="width: 100%"></td>
					<th>주관기관</th>
					<td><input type="text" name="organizer" id="organizer" style="width: 100%"></td>
				</tr>
				<tr>
					<th>홈페이지</th>
					<td colspan="3"><input type="text" name="url" id="url" style="width: 100%"></td>
				</tr>
				<tr>
					<th>게시글</th>
					<td colspan="3">
						<%@include file="../write.jsp" %>
					</td>
				</tr>
				<tr>
					<th>썸네일</th>
					<td colspan="3"><input type="text" name="thumbnail" id="thumbnail" style="width: 100%"></td>
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
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">
    let formData = new FormData();

    // 등록 버튼 클릭 시, 폼에 있는 값을 전달(이미지는 슬라이싱할 때 전달했기 때문에 따로 추가 설정 안해도 됨)
    document.querySelector("#submit").addEventListener("click", function (event) {
      event.preventDefault();

        oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

        const fields = [
            {id: "title", message: "제목을 입력하세요."},
            {id: "marathonDate", message: "마라톤 일정을 선택해주세요."},
            {id: "startDate", message: "마라톤 모집 시작일을 선택해주세요."},
            {id: "endDate", message: "마라톤 모집 마감일을 선택해주세요."},
            {id: "place", message: "마라톤 장소를 입력해주세요."},
            {id: "host", message: "주최 기관을 입력해주세요."},
            {id: "organizer", message: "주관 기관을 입력해주세요."},
            {id: "url", message: "마라톤 홈페이지 주소를 입력해주세요."},
            {id: "thumbnail", message: "마라톤 썸네일 이미지 링크를 입력해주세요."},
        ];

        for (const field of fields) {
            const input = document.getElementById(field.id);
            if (!input.value) {
                alert(field.message);
                input.focus();
                return;
            }
            formData.append(field.id, input.value);
        }

        let content = document.querySelector("textarea[name=ir1]").value.trim();
        let cleanedContent = content.replace(/<p><br><\/p>/g, "").trim();

        if (!cleanedContent) {
            alert("내용을 입력해주세요.");
            return;
        }

        formData.append("content", content);

        $.ajax({
            method: "post",
            url: "/community/marathon/register",
            data: formData,
            processData: false,
            contentType: false,
            success: function (marathon) {
                window.location.href = "detail?no=" + marathon.no;
            }
        })
    });

    function abort() {
        alert("글 작성을 취소하시겠습니까? 작성중이던 글은 저장되지 않습니다.");

        location.href = "main";
    }

</script>
</html>