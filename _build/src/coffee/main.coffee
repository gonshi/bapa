###!
  *
  * VelocityJS.org (1.2.2). (C) 2014 Julian Shapiro.
  * MIT @license: en.wikipedia.org/wiki/MIT_License
  * VelocityJS.org jQuery Shim (1.0.1). (C) 2014 The jQuery Foundation.
  * MIT @license: en.wikipedia.org/wiki/MIT_License.
  *
###

###!
  *
  * Main Function
  *
###

require "../js/velocity.min.js"

if window._DEBUG
  if Object.freeze?
    window.DEBUG = Object.freeze window._DEBUG
  else
    window.DEBUG = state: true
else
  if Object.freeze?
    window.DEBUG = Object.freeze state: false
  else
    window.DEBUG = state: false

window.DUR = 500

$ ->
  path = $( ".wrapper-common" ).data "path"

  if path == "pitch"
    require( "./pitchInit" )()
  else if path == "shake"
    require( "./shakeInit" )()
