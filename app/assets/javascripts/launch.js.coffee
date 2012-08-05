# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Type here!
$(document).ready ->
  $body = $("body") #Cache this for performance
  setBodyScale = ->
    scaleSource = $body.width()
    scaleFactor = 0.35
    maxScale = 600
    minScale = 30 #Tweak these values to taste
    fontSize = scaleSource * scaleFactor #Multiply the width of the body by the scaling factor:
    fontSize = maxScale  if fontSize > maxScale
    fontSize = minScale  if fontSize < minScale #Enforce the minimum and maximums
    $("body").css "font-size", fontSize + "%"

  $(window).resize ->
    setBodyScale()


  #Fire it when the page first loads:
  setBodyScale()