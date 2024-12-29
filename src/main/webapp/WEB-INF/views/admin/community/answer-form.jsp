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
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="${pageContext.request.contextPath}/resources/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        .inquiry-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .inquiry-detail {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .inquiry-detail h3 {
            margin: 0 0 15px;
            font-size: 24px;
            color: #333;
        }

        .inquiry-detail p {
            color: #666;
            line-height: 1.5;
        }
    </style>
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
                    <h1 class="h3 mb-0 text-gray-800">답변</h1>
                </div>

                <!-- Inquiry Detail -->
                <div class="inquiry-detail">
                    <h3>${qna.qnaTitle}</h3>
                    <p>${qna.qnaContent}</p>
                    <p><strong>작성일:</strong> <fmt:formatDate value="${qna.qnaCreatedDate}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul" /></p>
                    <p><strong>문의 상태:</strong> ${qna.qnaStatus}</p>
                    <p><strong>카테고리:</strong> ${qna.qnaCategory.categoryName}</p>
                </div>

                <!-- Admin Answer Form -->
                <div class="answer-form mt-4">
                    <h4>관리자 답변</h4>
                    <form action="/admin/qna/answer" method="post">
                        <!-- 답변 내용 -->
                        <div class="mb-3">
                            <label for="answerContent" class="form-label">답변 내용</label>
                            <textarea class="form-control" id="answerContent" name="answerContent" rows="4" required></textarea>
                        </div>

                        <!-- 상태 변경 -->
                        <div class="mb-3">
                            <label for="qnaStatus" class="form-label">문의 상태</label>
                            <select class="form-select" id="qnaStatus" name="qnaStatus" required>
                                <option value="0">대기</option>
                                <option value="1">완료</option>
                                <option value="2">삭제</option>
                            </select>
                        </div>

                        <!-- Qna ID (숨겨진 필드로 전송) -->
                        <input type="hidden" name="qnaNo" value="${qna.qnaNo}" />

                        <!-- 제출 버튼 -->
                        <button type="submit" class="btn btn-primary">답변 등록</button>
                    </form>
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

</body>

</html>
