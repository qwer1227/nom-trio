<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        h2 {
            margin-bottom: 20px;
        }

        .fc-day a {
            color: black;
            text-decoration: none;
        }

        .fc-day-sun a {
            color: red;
            text-decoration: none;
        }

        /* 토요일 날짜 파란색 */
        .fc-day-sat a {
            color: blue;
            text-decoration: none;
        }

    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>

<div class="container-xxl text-center" id="wrap">
    <h2>운동일지</h2>

    <!-- FullCalendar를 표시할 영역 -->
    <div id="calendar"></div>

    <!-- 운동일지 모달 (추가 및 수정) -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eventModalLabel">운동일지</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="eventCategory" class="form-label">운동 카테고리:</label>
                        <select id="eventCategory" name="category" class="form-select" required>
                            <option value="1">무산소</option>
                            <option value="2">유산소</option>
                        </select>
                    </div>
                    <form id="eventForm">
                        <div class="mb-3">
                            <label for="eventTitle" class="form-label">운동 제목:</label>
                            <input type="text" id="eventTitle" name="title" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="eventDescription" class="form-label">운동 내용:</label>
                            <textarea id="eventDescription" name="description" class="form-control" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary" id="saveEvent">저장</button>
                    <button type="button" class="btn btn-danger" id="deleteEvent" style="display: none;">삭제</button>
                    <button type="button" class="btn btn-secondary" id="closeModal" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        let calendarEl = document.getElementById('calendar');
        let calendar = new FullCalendar.Calendar(calendarEl, {
            headerToolbar: {
                left: 'prev,next,today',
                center: 'title',
                right: 'dayGridMonth,dayGridWeek,timeGridWeek'
            },
            buttonText: {
                today: '현재날짜',
                month: '월별',
                week: '주별',
                timeGridWeek: '주별시간',
                day: '일별',
                list: '목록',
            },
            initialView: 'dayGridMonth',
            selectable: true,
            editable: true,
            // events 옵션을 AJAX 호출을 통해 가져오는 함수로 수정
            events: function (fetchInfo, successCallback, failureCallback) {
                $.ajax({
                    url: '/mypage/getworkout',
                    type: 'GET',
                    success: function (data) {
                        let events = data.map(function (workout) {
                            return {
                                id: workout.id,
                                title: workout.title,
                                start: workout.start,
                                end: workout.end,
                                className: workout.categoryNo === 1 ? 'anaerobic' : 'aerobic' // 카테고리에 따라 색상 클래스 설정
                            };
                        });
                        successCallback(events); // 이벤트 데이터를 FullCalendar에 전달
                    },
                    error: function () {
                        failureCallback(); // 실패 시 콜백
                    }
                });
            },
            displayEventTime: false,
            locale: 'ko',
            dayHeaderFormat: { weekday: 'short'},
            dateClick: function (info) {
                openModal(info.dateStr);
            },
            eventClick: function (info) {
                // 이벤트 클릭 시 서버에서 상세 정보 가져오기
                $.ajax({
                    url: '/mypage/getworkoutdetail/' + info.event.id, // 이벤트 ID를 사용해 서버 요청
                    type: 'GET',
                    success: function (response) {
                        if (response.message === "성공") {
                            let workoutDetail = response.workoutDetail;

                            // 모달 내용 설정
                            $('#eventTitle').val(workoutDetail.title);
                            $('#eventDescription').val(workoutDetail.description);
                            $('#eventCategory').val(workoutDetail.categoryNo); // 카테고리 설정
                            $('#deleteEvent').show();

                            // 모달 표시
                            var myModal = new bootstrap.Modal(document.getElementById('eventModal'));
                            myModal.show();

                            // 저장 버튼 클릭 핸들러 설정
                            $('#saveEvent').off('click').on('click', function () {
                                let title = $('#eventTitle').val();
                                let description = $('#eventDescription').val();
                                let categoryNo = $('#eventCategory').val();

                                // 수정 요청
                                $.ajax({
                                    url: '/mypage/putworkout/' + info.event.id,
                                    type: 'PUT',
                                    contentType: 'application/json',
                                    data: JSON.stringify({
                                        title: title,
                                        description: description,
                                        categoryNo: categoryNo
                                    }),
                                    success: function () {
                                        calendar.refetchEvents(); // 이벤트 갱신
                                    }
                                });

                                myModal.hide();
                            });

                            // 삭제 버튼 클릭 핸들러 설정
                            $('#deleteEvent').off('click').on('click', function () {
                                $.ajax({
                                    url: '/mypage/deleteworkout/' + info.event.id,
                                    type: 'PUT',
                                    success: function () {
                                        calendar.refetchEvents(); // 이벤트 갱신
                                    }
                                });

                                myModal.hide();
                            });
                        } else {
                            alert('이벤트 정보를 불러오는 데 실패했습니다.');
                        }
                    },
                    error: function () {
                        alert('서버 오류가 발생했습니다.');
                    }
                });
            }
        });

        calendar.render();

        // Modal 관련 로직
        function openModal(date, event = null) {
            $('#eventForm')[0].reset(); // 폼 초기화
            if (event) {
                $('#eventTitle').val(event.title);
                $('#eventDescription').val(event.extendedProps.description);
                $('#deleteEvent').show();
            } else {
                $('#deleteEvent').hide();
            }

            // 모달 표시
            var myModal = new bootstrap.Modal(document.getElementById('eventModal'));
            myModal.show();

            // 저장
            $('#saveEvent').off('click').on('click', function () {
                let title = $('#eventTitle').val();
                let description = $('#eventDescription').val();
                let categoryNo = $('#eventCategory').val(); // 카테고리 값 추가

                if (event) {
                    event.setProp('title', title);
                    event.setExtendedProp('description', description);

                    // 수정 요청
                    $.ajax({
                        url: '/mypage/putworkout/' + event.id, // 이벤트 ID를 통해 수정
                        type: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            title: title,
                            description: description,
                            categoryNo: categoryNo // 카테고리 정보도 전송
                        }),
                        success: function () {
                            calendar.refetchEvents(); // 서버 데이터 재로드
                        }
                    });
                } else {
                    // 새로운 이벤트 추가
                    $.ajax({
                        url: '/mypage/postworkout',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            title: title,
                            startDate: date,
                            description: description,
                            categoryNo: categoryNo // 카테고리 정보도 전송
                        }),
                        success: function (response) {
                            calendar.refetchEvents(); // 서버 데이터 재로드
                        }
                    });
                }

                myModal.hide();
            });

            // 삭제
            $('#deleteEvent').off('click').on('click', function () {
                if (event) {
                    event.remove();
                }
                myModal.hide();
            });

            // 취소
            $('#closeModal').off('click').on('click', function () {
                myModal.hide();
            });
        }
    });
</script>
</body>
</html>
