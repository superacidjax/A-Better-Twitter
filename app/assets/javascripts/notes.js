$('#note_content').live('keyup keydown', function(e) {
    var maxLen = 200;
    var left = maxLen - $(this).val().length;
    $('#char-count').html(left);
  });