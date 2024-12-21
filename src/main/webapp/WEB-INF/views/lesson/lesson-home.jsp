<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <style>
        .section-bg {
            background-image: url('${pageContext.request.contextPath}/resources/images/lesson/lesson-main.png');
            background-size: cover;
            background-position: center;
            color: white;
        }

        .image-container {
            text-align: center;
            margin-bottom: 30px;
        }

        .image-container img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl my-5" id="wrap">
    <!-- Header -->
    <header class="bg-success text-white text-center py-5">
        <h1>습습후후 러닝 클래스</h1>
        <p class="lead">호흡, 자세, 운동 - 더 나은 달리기를 위한 완벽 가이드!</p>
    </header>
    <section class="image-container">
        <div class="container">
            <h2 class="text-center text-success mb-4">우리의 러닝 클래스</h2>
        </div>
    </section>
    <div>
        <a href="/lesson/schedule" class="btn btn-success rounded-pill mb-3 text-center align-content-center"
           style="width: 100%; height:50px;">레슨 일정 보러 가기</a>
    </div>
    <!-- Breathing Section -->
    <section class="mb-5">
        <div class="card">
            <div class="card-body">
                <h2 class="card-title text-success">💨 러닝 호흡법 클래스</h2>
                <ul class="list-unstyled">
                    <li><strong>지구력 향상:</strong> 산소를 최적화 공급하여 근육 피로를 줄입니다.</li>
                    <li><strong>페이스 조절:</strong> 호흡 리듬으로 일정한 속도를 유지하세요.</li>
                    <li><strong>부상 예방:</strong> 긴장을 완화하고 효율적인 에너지 사용을 돕습니다.</li>
                </ul>
            </div>
        </div>
    </section>
    <!-- Running Posture Section -->
    <section class="mb-5">
        <div class="card">
            <div class="card-body">
                <h2 class="card-title text-success">🏃‍♂️ 러닝 자세 클래스</h2>
                <ul class="list-unstyled">
                    <li><strong>효율적인 자세 교정:</strong> 잘못된 자세를 바로잡아 에너지 낭비를 줄이세요.</li>
                    <li><strong>균형 있는 몸의 움직임:</strong> 발 디딤부터 상체까지 체계적으로 점검합니다.</li>
                    <li><strong>부상 예방:</strong> 관절과 근육 부담을 줄이고 장기적인 달리기를 돕습니다.</li>
                </ul>
            </div>
        </div>
    </section>
    <!-- Strengthening Exercises Section -->
    <section>
        <div class="card">
            <div class="card-body">
                <h2 class="card-title text-success">💪 근육 강화 운동 클래스</h2>
                <ul class="list-unstyled">
                    <li><strong>핵심 근육 강화:</strong> 다리, 코어, 허리 근육을 집중적으로 단련합니다.</li>
                    <li><strong>체계적인 훈련 프로그램:</strong> 유산소와 러닝을 결합한 트레이닝.</li>
                    <li><strong>부상 방지 운동:</strong> 관절과 근육 안정성을 높여 러닝 퍼포먼스를 향상합니다.</li>
                </ul>
            </div>
        </div>
    </section>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>