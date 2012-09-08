$(document).ready ->
  $("h5#more").click ->
    $("#hero").toggle 100
    $("#learnmore").fadeIn()
    $("h3#signup").show()
    $("h3#getstarted").hide()

$(document).ready ->
  $("h3#signup").click ->
    $("#learnmore").fadeOut 500
    $("#hero").hide().delay(1000).fadeIn()
    $("h3#blank").hide().delay(500).fadeIn()
    $("h3#signup").fadeOut 500
    $("h4#signup").fadeOut 500
    $("h5#more").fadeOut 300
    $("h5#more").fadeIn 900