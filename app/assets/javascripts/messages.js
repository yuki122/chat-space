$(function(){
  const formClass = ".message-form";
  const bodyFieldClass = ".message-form__field__body";
  const imageFieldId = "#message_image";

  //cmdキー+エンターでフォーム送信
  $(window).keydown(function(e){
    //cmdキー+エンターの判定
    if(event.metaKey && e.keyCode === 13){
      // body入力中か、画像がアップロードされていればsubmit
      if($(':focus').is(bodyFieldClass) || $(imageFieldId).val()) {
        // formを送信
        $(formClass).submit();
        return false;
      }
    }
  });

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
      <div class="message__body"><p>${message.body.replace(/\r?\n/g, '<br>')}</p></div>
      ${buildMessageImageHTML(message.image_url)}
    </div>
    `;
  }

  $(formClass).on("submit", function(e){
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
      var messages_div = $(".contents-main-messages");
      messages_div.append(buildMessageHTML(data));
      // 一番下までスクロールする
      messages_div.animate({scrollTop: messages_div[0].scrollHeight}, "fast");

      // フォームをクリア
      $(bodyFieldClass).val("");
      $(imageFieldId).val("")

      // サイドバーのlast_messageも更新
      const sideMsg = data.body ? data.body : "画像が投稿されました"
      $(".side-bar .group--selected .group__last-message").text(sideMsg);

      // flashメッセージも取り除く
      $(".notification").empty();
    }).fail(function(data){
      alert("error");
    });

    // これがないと連続でjsが実行されない（preventDefault()ではダメだった）
    return false;
  });
});

// マイページ読み込み時に、チャット画面を即時下スクロール
// turbolinkをきることで、ページ遷移時も機能する（onだとreloadの時のみに呼ばれる）
$(function(){
  console.log(document.URL);
  console.log(!!document.URL.match(/groups\/\d+\/messages$/));
  if(document.URL.match(/groups\/\d+\/messages$/)) {
    console.log("load");
    var messages_div = $(".contents-main-messages");
    // 一番下までスクロールする
    messages_div.scrollTop(messages_div[0].scrollHeight);
  }
})
