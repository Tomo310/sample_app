# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# フォームの残り入力可能文字数を表示（参考（というかパクリ）：http://tkymtk.hatenablog.com/entry/2014/01/06/151300）
$ ->
  $('#micropost_content').on('keyup keydown keypress change',->
      thisValueLength = $(this).val().length
      limit = 140
      if thisValueLength < limit
        $('.count').html("残り"+(limit - thisValueLength)+"文字").removeClass("text-danger")
      else
        $('.count').html("残り"+(limit - thisValueLength)+"文字").addClass("text-danger")
  ).keyup()