$(function(){
  function buildMessageImageHTML(imageURL) {
    if(!imageURL) { return ""; }
    return `
      <div class="message__img">
        <img alt="投稿画像" src="${imageURL}">
      </div>`;
  }
  function buildMessageHTML(message) {
    return `
    <div class="message">
      <div class="message__header">
        <p class="message__header__user-name">${message.user_name}</p>
        <p class="message__header__posted-at">${message.created_at}</p>
      </div>
      <div class="message__body"><p>${message.body}</p></div>
      ${buildMessageImageHTML(message.image_url)}
    </div>
    `
  }

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
      $(".contents-main-messages").append(buildMessageHTML(data));
      $(".message-form__field__body").val("");

    }).fail(function(data){
      alert("error");
    });

    // これがないと連続でjsが実行されない（preventDefault()ではダメだった）
    return false;
  });
});
