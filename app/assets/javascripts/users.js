$(function(){

  function buildSearchResultHTML(user) {
    return `
      <div class="group-user clearfix">
        <p class="group-user__name">${user.name}</p>
        <a class="user-search-add group-user__btn group-user__btn--add" data-user-id="${user.id}" data-user-name="${user.name}">追加</a>
      </div>
      `;
  }

  function buildSelectedGroupUserHTML(user) {
    return `
    <div class='group-user clearfix js-chat-member' id='group-user-${user.id}'>
      <input name='group[user_ids][]' type='hidden' value='${user.id}'>
      <p class='group-user__name'>${user.name}</p>
      <a class='user-search-remove group-user__btn group-user__btn--remove js-remove-btn'>削除</a>
    </div>
    `
  }

  function getSelectedGroupUserIds() {
    return $("input[name='group[user_ids][]']").get().map(function(input){
      return ($(input).val() - 0); //intに変換
    });
  }

  function getSearchResultDiv(userId) {
    // 階層が入れ子になってもいいように、find, closestを使う（parent, parentsでも動く）
    return $("#user-search-result").find(`a[data-user-id='${userId}']`).closest(".group-user");
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

    // 該当userを非同期で問い合わせ
    $.ajax({
      url: "/users",
      type: "GET",
      data: { name_cont: typed },
      dataType:"json"
    }).done(function(data){
      // 検索結果に表示
      data.forEach(function(user){
        resultDiv.append(buildSearchResultHTML(user));
      });
      // すでに選択されているものはあらかじめ非表示にする
      getSelectedGroupUserIds().forEach(function(selectedId){
        getSearchResultDiv(selectedId).hide();
      });
    }).fail(function(data){
      alert("ユーザの検索に失敗しました")
    });
  });

  // group-userが追加されるときのイベント
  $("#user-search-result").on("click", ".user-search-add", function(){
    const userId = $(this).attr("data-user-id");
    const userName = $(this).attr("data-user-name");

    // 検索一覧から消す
    getSearchResultDiv(userId).hide();

    // 選択欄に表示する
    $("#group-users").append(buildSelectedGroupUserHTML({id: userId, name: userName}));
  });

  // group-userが削除されるときのイベント
  $("#group-users").on("click", ".user-search-remove", function(){
    const userId = $(this).siblings("input[name='group[user_ids][]']").val();
    // 選択欄から削除
    $(this).closest(".group-user").remove();

    // 検索一覧に再表示
    getSearchResultDiv(userId).show();
  });
});
