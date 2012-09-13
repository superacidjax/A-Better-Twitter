$('#note_content').live('keyup keydown', function(e) {
    var maxLen = 250;
    var left = maxLen - $(this).val().length;
    $('#char-count').html(left);
  });

$('#group_description').live('keyup keydown', function(e) {
    var maxLen = 250;
    var left = maxLen - $(this).val().length;
    $('#char-count').html(left);
  });