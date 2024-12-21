<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
  <script type="text/javascript" src="/resources/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>
<form method="get" action="register">
  <textarea name="ir1" id="ir1" style="display:none;"></textarea>
</form>
<script type="text/javascript">
    var oEditors = [];
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "ir1",
        sSkinURI: "/resources/se2/SmartEditor2Skin_ko_KR.html",
        fCreator: "createSEditor2"
    });

    function submitContents(elClickedObj) {
        // 에디터의 내용이 textarea에 적용된다.
        oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
        // 에디터의 내용에 대한 값 검증은 이곳에서
        // document.getElementById("ir1").value를 이용해서 처리한다.
        try {
            elClickedObj.form.submit();
        } catch(e) {}
    }
</script>
</body>
</html>