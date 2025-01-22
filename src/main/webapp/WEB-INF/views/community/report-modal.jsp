<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<head>
</head>
<body>
<div class="modal" tabindex="-1" id="modal-reporter">
  <div class="modal-dialog">
    <div class="modal-content" style="text-align: start">
      <div class="modal-header">
        <h5 class="modal-title">신고 사유</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form method="post">
          <input type="hidden" name="no" value="">
          <input type="hidden" name="type" value="">
          <div class="form-check">
            <input class="form-check-input" type="radio" value="1" name="reason" checked>
            <label class="form-check-label">
              스팸홍보/도배글입니다.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" value="2" name="reason">
            <label class="form-check-label">
              불법정보를 포함하고 있습니다.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" value="3" name="reason">
            <label class="form-check-label">
              욕설/생명경시/혐오/차별적 표현입니다.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" value="4" name="reason">
            <label class="form-check-label">
              개인정보 노출 게시물입니다.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" value="5" name="reason">
            <label class="form-check-label">
              불쾌한 표현이 있습니다.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" value="6" name="reason" id="etc-reason">
            <label class="form-check-label">
              <input type="hidden" id="detail" name="detail">
              <input type="text" placeholder="신고사유를 직접 작성해주세요." id="etc-detail">
            </label>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary" onclick="reportButton()">신고</button>
      </div>
    </div>
  </div>
</div>
</body>
<script>
  function reportButton() {
    let etcReason = $("#etc-reason");
    if (etcReason.is(':checked')) {
      let detailInput = $("#etc-detail").val().trim();
      if (!detailInput){
        alert("신고 사유를 입력해주세요.");
        detailInput.focus();
        return;
      }
      
      $("#detail").val(detailInput);
    }
    $(".modal form").trigger("submit");
  }
</script>
