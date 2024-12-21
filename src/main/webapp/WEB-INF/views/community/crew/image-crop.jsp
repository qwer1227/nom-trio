<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fengyuanchen.github.io/cropperjs/css/cropper.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://fengyuanchen.github.io/cropperjs/js/cropper.js"></script>
<style type="text/css">
    .box {
        margin: 20px auto;
        max-width: 640px;
        max-height: 430px;
    }

    .box img {
        max-width: 100%;
    }

    #photoBtn {
        display: none;
    }

    .them_img {
        position: relative;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        overflow: hidden; /* 박스 밖으로 나가는 이미지 숨김 */
        display: flex; /* Flexbox 활성화 */
        justify-content: center; /* 수평 중앙 정렬 */
        align-items: center; /* 수직 중앙 정렬 */
    }
</style>
<div class="modal" tabindex="-1" id="modal-thumbnail">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">크루 대표 이미지</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <button class="upload_btn btn btn-primary">
          <input type="file" accept="image/jpeg, image/png" capture="camera" id="photoBtn" onchange="readURL(this);">
          <label for="photoBtn">사진 첨부하기</label>
        </button>
        <div class="box">
          <div class="photo_them">
            <div class="them_img">
              <img src="" id="image" style="max-height: 400px">
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button id="btn-cropper" class="btn btn-primary" data-bs-dismiss="modal">설정</button>
      </div>
    </div>
  </div>
</div>
<script>
    const myModalThumbnail = new bootstrap.Modal('#modal-thumbnail')

    function thumbnail() {
        myModalThumbnail.show();
    }

    let image = document.querySelector("#image")

    let cropper = null;
    let formData = new FormData();

    // 이미지 슬라이싱 기본 설정
    function initCropper() {
        cropper = new Cropper(image, {
            dragMode: 'move',
            aspectRatio: 16 / 11,
            autoCropArea: 0.6,
            restore: false,
            guides: false,
            center: false,
            highlight: false,
            cropBoxMovable: true,
            cropBoxResizable: true,
            toggleDragModeOnDblclick: false,
        });
    }

    // 모달의 설정 버튼 클릭 시, 임시로 썸네일 이미지 저장
    $("#btn-cropper").click(function () {
        if (cropper) {
            let boxData = cropper.getCropBoxData();
            console.log(boxData);

            cropper.getCroppedCanvas({
                width: 334.30,
                height: 188.66
            }).toBlob(function (blob) {
                formData.append('image', blob, 'thumbnail.png');
            })
        }
    });

    // 첨부한 이미지 미리보기 기능을 제공
    function readURL(input) {
        if (cropper) {
            cropper.destroy()
        }

        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('image').src = e.target.result;
                initCropper();
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            document.getElementById('image').src = "";
        }
    }
</script>