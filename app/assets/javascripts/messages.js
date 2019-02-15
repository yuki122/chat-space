$(function(){
  $(".message-form").on("submit", function(e){
    const formData = new FormData(this);
    const url = $(this).attr("action");
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: "json",
      processData: false,
      contentType: false
    }).done(function(data){
      // エラーハンドリング
      if(data.alert) {
        alert(data.alert);
        return false;
      }
      console.log(data);
      $(".message-form__field__body").val("");
    }).fail(function(data){
      alert("error");
    });

    // これがないと連続でjsが実行されない（preventDefault()ではダメだった）
    return false;
  });
});
