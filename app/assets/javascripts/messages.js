$(function(){
  $(".message-form").on("submit", function(e){
    console.log("submit");

    // これがないと連続でjsが実行されない（preventDefault()ではダメだった）
    return false;
  });
});
