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

  function addNewMessage(message, isLast=true) {
    var messages_div = $(".contents-main-messages");
    messages_div.append(buildMessageHTML(message));
    // 一番下までスクロールする
    messages_div.animate({scrollTop: messages_div[0].scrollHeight}, "fast");

    if(isLast) {
      // サイドバーのlast_messageも更新
      const sideMsg = message.body ? message.body : "画像が投稿されました"
      $(".side-bar .group--selected .group__last-message").text(sideMsg);

      // flashメッセージも取り除く
      $(".notification").empty();
    }
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

      // 新しい投稿を表示
      addNewMessage(data)

      // フォームをクリア
      $(bodyFieldClass).val("");
      $(imageFieldId).val("")

    }).fail(function(data){
      alert("error");
    });

    // これがないと連続でjsが実行されない（preventDefault()ではダメだった）
    return false;
  });


  // 自動更新
  $(function(){
    const interval = 5000;//[ms]

    function getCreatedAtOfLastMessage() {
      return $(".message").last().find(".message__header__posted-at").text();
    }

    function updateMessages() {
      $.ajax({
        url: document.URL,
        type: "GET",
        data: {last_message_created_at: getCreatedAtOfLastMessage()},
        dataType: "json"
      }).done(function(data){
        console.log(data);
        // debugger
        data.forEach(function(message, index){
          let isLast = index === (data.length - 1);
          // console.log(message, isLast)
          addNewMessage(message, isLast);
        });
      }).fail(function(data) {
        console.log("自動更新に失敗しました");
      });
    }
    // 自動更新を設定
    setInterval(updateMessages, interval);
  });
});

// マイページ読み込み時に、チャット画面を即時下スクロール
// turbolinkをきることで、ページ遷移時も機能する（onだとreloadの時のみに呼ばれる）
$(function(){
  if(document.URL.match(/groups\/\d+\/messages$/)) {
    var messages_div = $(".contents-main-messages");
    // 一番下までスクロールする
    messages_div.scrollTop(messages_div[0].scrollHeight);
  }
})
