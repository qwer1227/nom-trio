<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<%@ page import="java.util.*" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <style>
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

        /*.fc-event {*/
        /*    overflow: hidden; !* 넘치는 텍스트 숨기기 *!*/
        /*    text-overflow: ellipsis; !* 넘치는 텍스트에 '...' 표시 *!*/
        /*    white-space: nowrap; !* 텍스트가 줄 바꿈 없이 한 줄로 표시 *!*/
        /*}*/

        .fc-event {
            padding: 10px 10px;
            margin: 30px 0;
            border-radius: 8px; /* 둥근 모서리 적용 */
            background-color: #f0f8ff; /* 배경 색상 */
            font-size: 14px;
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
            text-align: left;
            white-space: nowrap;
        }

        .fc-time-grid .fc-slats td {
            display: none;
        }

        .fc-time-grid .fc-slats .fc-event {
            display: block;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl" id="wrap">
    <div class="row text-center mb-3">
        <h2>레슨 일정 보기</h2>
    </div>
    <div class="row mb-3">
        <div class="col-2">
            <label for="subject">과정 선택:</label>
            <select id="subject" class="form-select">
                <option value="전체">전체</option>
                <option value="호흡">호흡</option>
                <option value="자세">자세</option>
                <option value="운동">운동</option>
            </select>
        </div>
        <div class="col d-flex mt-2">
            <div class="m-3 d-flex">
                <div style="width: 30px; height:30px; border-radius: 5px; background: #AEDFF7"></div>
                <span class="p-1">호흡</span>
            </div>
            <div class="m-3 d-flex">
                <div style="width: 30px; height:30px; border-radius: 5px; background: #d8f6d4"></div>
                <span class="p-1">자세</span>
            </div>
            <div class="m-3 d-flex">
                <div style="width: 30px; height:30px; border-radius: 5px; background: #D9C8F2"></div>
                <span class="p-1">운동</span>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col mb-3 form-check">
            <input type="checkbox" id="completed-include">
            <label for="completed-include">마감 포함</label>
        </div>
    </div>
    <div class="row mb-3">
        <div id='calendar'></div>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            eventLimit: true,
            slotEventOverlap: false,
            slotDuration: '00:10:00',
            slotMinTime: '09:00:00',
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
            views: {
                dayGridMonth: {
                    titleFormat: {
                        year: 'numeric',
                        month: 'numeric',
                    }
                },
                dayGridWeek: {
                    titleFormat: {
                        year: 'numeric',
                        month: 'numeric',
                    }
                },
                timeGridWeek: {
                    titleFormat: {
                        year: 'numeric',
                        month: 'numeric',
                        day: 'numeric',
                    }
                }
            },
            editable: true,
            droppable: true,
            windowResize: true, // 창 크기 변경 시 자동 조정
            contentHeight: 'auto', // 높이를 자동으로 설정
            slotEventOverlap: false,

            // Load events dynamically from the database
            events: function (info, successCallback, failureCallback) {
                refreshEvents(info, successCallback, failureCallback);
            },

            eventClick: function (info) {
                lessonDetail(info.event.extendedProps.lessonNo);
            },

            eventContent: function (arg) {

                // 이벤트 상태
                var eventStatusText = arg.event.extendedProps.status;
                var eventStatus;

                if (eventStatusText === '마감') {
                    eventStatus = $('<span class="badge bg-secondary" style="display: block; margin-bottom: 5px;">' + eventStatusText + '</span>');
                } else if (eventStatusText === '모집중') {
                    eventStatus = $('<span class="badge bg-success " style="display: block; margin-bottom: 5px;">' + eventStatusText + '</span>');
                } else if (eventStatusText === '취소') {
                    eventStatus = $('<span class="badge bg-secondary" style="display: block; margin-bottom: 5px;">' + eventStatusText + '</span>');
                }

                // 이벤트 제목
                var eventTitle = $('<span style="font-size: 16px; font-family: \'Noto Sans KR\', sans-serif; font-weight: bold; color: #333; display: block;">' + arg.event.title + '</span>');

                // 시작 시간과 종료 시간을 표시
                var eventTime = $('<div style="font-size: 14px; font-family: \'Noto Sans KR\'; font-weight: bold; color: #333; margin-top: 5px; font-style: italic; display: block;">' +
                    moment(arg.event.start).format('HH:mm') + ' - ' +
                    moment(arg.event.end).format('HH:mm') +
                    '</div>');

                // 이벤트 엘리먼트에 상태, 제목, 시간을 배치
                var eventEl = $('<div style="width: auto; white-space: normal; overflow: visible; padding: 5px;"></div>');
                eventEl.append(eventStatus);  // 상태를 먼저 추가
                eventEl.append(eventTitle);   // 제목을 그 아래로 추가
                eventEl.append(eventTime);    // 시간은 그대로 추가

                return {domNodes: [eventEl[0]]};
            },

            eventDidMount: function (info) {
                $(info.el).css({
                    'border': '10px solid ' + info.borderColor, // 경계 색상과 두께 적용
                    'border-radius': '5px'  // 둥글게 만들 수도 있음
                });
            }

        });

        // Refresh events based on selected filters
        function refreshEvents(info, successCallback, failureCallback) {
            let start = moment(info.start).format("YYYY-MM-DD");
            let end = moment(info.end).format("YYYY-MM-DD");
            let subject = $('#subject').val(); // 선택된 과정 필터 값
            const includeCompleted = $('#completed-include').prop('checked');

            let param = {
                start: start,
                end: end,
                subject: subject, // subject 값을 추가
                includeCompleted: includeCompleted
            };

            $.ajax({
                type: 'get',
                url: '/lesson/list',  // Server API endpoint
                data: param,          // param 객체를 data로 전달
                dataType: 'json'
            })
                .done(function (events) {
                    console.log("Fetched Events:", events); // 데이터를 디버깅용으로 출력
                    var formattedEvents = events.map(event => {
                        // 조건별 색상 매핑
                        const colorMap = {
                            '호흡': '#8fc0e5',
                            '자세': '#bdeca2',
                            '운동': '#d19cef'
                        };

                        const backgroundColor = colorMap[event.subject] || 'black';
                        const borderColor = backgroundColor; // 테두리 색상도 동일하게 설정

                        return {
                            title: event.title,
                            start: event.start,
                            end: event.end,
                            allDay: false,
                            textColor: 'black', // 텍스트 색상
                            borderColor: borderColor,
                            backgroundColor: 'white', // 배경색
                            borderWidth: 5,
                            display: 'block',
                            extendedProps: {
                                lessonNo: event.lessonNo,  // 추가 정보
                                status: event.status,   // 레슨 상태 정보
                                subject: event.subject // subject 포함
                            },
                        };
                    });

                    console.log("Formatted Events:", formattedEvents);

                    // 캘린더에 렌더링할 이벤트 데이터 전달
                    successCallback(formattedEvents);
                })
                .fail(function () {
                    console.error("Failed to load event data.");
                    failureCallback();
                });
        }

        function lessonDetail(lessonNo) {
            if (lessonNo !== undefined && lessonNo !== null && lessonNo !== "") {  // Validate lessonNo
                console.log("LessonNo:", lessonNo); // Log to ensure lessonNo is being passed as int
                location.href = ("/lesson/detail?lessonNo=" + lessonNo);
            } else {
                console.error("Invalid lessonNo");
            }
        }

        // Subject or Completed include filter changes
        $(document).on('change', '#subject', function () {
            console.log("Subject changed:", $('#subject').val());
            calendar.refetchEvents();
        });

        $(document).on('change', '#completed-include', function () {
            console.log("Completed include changed:", $('#completed-include').prop('checked')); // 상태 확인
            calendar.refetchEvents();
        });


        $('#subject, #completed-include').on('change', function () {
            calendar.refetchEvents(); // 이벤트 다시 불러오기
        });


        // Initialize the calendar
        calendar.render();
    });
</script>
</body>
</html>