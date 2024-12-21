<%@ page pageEncoding="UTF-8"%>
<!-- Search -->
<form
        class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
  <div class="input-group">
    <input type="text" class="form-control bg-light-secondary border-0 small" name="value" value="${param.value }" placeholder="검색"
           aria-label="Search" aria-describedby="basic-addon2">
    <div class="input-group-append">
      <button class="btn btn-primary" type="button" onclick="searchValue()">
        <i class="fas fa-search fa-sm"></i>
      </button>
    </div>
  </div>
</form>
