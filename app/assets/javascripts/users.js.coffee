$(document).ready ->
  $("h5#more").click ->
    $("h5#more").hide()
    $("h5#signup").show()
    $("#hero").toggle 100
    $("#learnmore").fadeIn()

$(document).ready ->
  $("h5#signup").click ->
    $("#hero").hide().delay(200).fadeIn()
    $("h3#blank").hide().delay(300).fadeIn()
    $("#effects").fadeOut 100
    $("#learnmore").fadeOut 500
    $('h5#signup').hide()
    $('h5#more').show()