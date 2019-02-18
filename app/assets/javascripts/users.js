$(function(){

  function buildGroupUserHTML(user) {
    return `
      <div class="group-user clearfix">
        <p class="group-user__name">${user.name}</p>
        <a class="user-search-add group-user__btn group-user__btn--add" data-user-id="${user.id}" data-user-name="${user.name}">追加</a>
      </div>
      `;
  }

  // fieldに変化があった時のみ非同期通信でuser候補を表示
  var prev_typed = "";
  $("#user-search-field").on("keyup", function(e){
    const typed = $(this).val();
    // shiftなどのキーが打たれた時対策
    if(typed === prev_typed) { return true; }

    // 前回の検索結果をリセット
    var resultDiv = $("#user-search-result");
    resultDiv.empty();
    prev_typed = typed;

    // 空白文字は候補が多すぎるので、通信しない
    if(!typed) { return true; }

    $.ajax({
      url: "/users",
      type: "GET",
      data: { name_cont: typed },
      dataType:"json"
    }).done(function(data){
      data.forEach(function(user){
        resultDiv.append(buildGroupUserHTML(user));
      });
    }).fail(function(data){
      alert("ユーザの検索に失敗しました")
    });
  });
});
