<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <!-- JSTL 사용 -->
<head>
  <script src="https://kit.fontawesome.com/dc49441f6a.js" crossorigin="anonymous"></script>
  <style>
    #weather-container {
      padding: 10px;
      background-color: #f8f9fc;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      display: inline-block;
      margin-right: 20px;
    }
    #weather-info {
      font-size: 0.9rem;
      color: #4e73df;
    }
  </style>
</head>
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

  <div class="col container mt-1" id="weather-container">
    <!-- 현재 날씨 정보 -->
    <c:choose>
      <c:when test="${not empty currentWeather}">
      <div class="row align-items-center" id="weather-info" style="gap: 10px; text-align: left;">
        <p class="col-auto mb-0"><strong>도시:</strong> ${currentWeather.name}</p>
        <p class="col-auto mb-0"><strong>온도:</strong> ${currentWeather.main.temp}°C</p>
        <p class="col-auto mb-0"><strong>날씨:</strong> ${currentWeather.weather[0].description}</p>
        <p class="col-auto mb-0"><strong>습도:</strong> ${currentWeather.main.humidity}%</p>
      </div>
      </c:when>
      <c:otherwise>
        <p>날씨 정보를 가져올 수 없습니다.</p>
      </c:otherwise>
    </c:choose>
  </div>
  <div class="col"></div>
  <!-- Sidebar Toggle (Topbar) -->
  <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
    <i class="fa fa-bars"></i>
  </button>

  <!-- Topbar Navbar -->
  <ul class="navbar-nav ml-auto">
    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
         data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="mr-2 d-none d-lg-inline text-gray-600 small">ADMIN</span>
        <img class="img-profile rounded-circle"
             src="${pageContext.request.contextPath}/resources/img/undraw_profile.svg">
      </a>
      <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
           aria-labelledby="userDropdown">
        <a class="dropdown-item" href="#">
          <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
          Profile
        </a>
        <a class="dropdown-item" href="#">
          <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
          Settings
        </a>
        <a class="dropdown-item" href="#">
          <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
          Activity Log
        </a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
          <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
          Logout
        </a>
      </div>
    </li>
  </ul>
</nav>