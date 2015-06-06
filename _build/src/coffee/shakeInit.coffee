accelHandler = require "./controller/accelHandler"
ticker = require( "./util/ticker" )()

shakeInit = ->
  #######################
  # DECLARE
  #######################
  
  $wrapper = $( ".wrapper-common" )
  $caution_container = $( ".caution_container" )
  $qr_container = $( ".qr_container" )
  $tutorial_container = $( ".tutorial_container" )
  $sound = $( ".sound" )
  $fromSp = $( ".fromSp" )
  $shake = $( ".shake" )

  dataStore = null
  audio = []
  cur_audio = 0
  user_id = if window.isSp then null else parseInt( Math.random() * 1000 )

  #######################
  # PRIVATE
  #######################

  init = ->
    if window.isSp
      _q = window.location.search.substring 1 # remove "?"
      _param = _q.split "&"
      if _param.length > 0
        for i in [ 0..._param.length ]
          _elem = _param[ i ].split "="
          if decodeURIComponent( _elem[ 0 ] ) == "user_id"
            user_id = decodeURIComponent _elem[ 1 ]
            $fromSp.hide()
            $wrapper.addClass "hide"
            $caution_container.show()
            dataStore.send
              user_id: user_id
              action: "load"
            break

      # PCから見てね
      $fromSp.show() if $caution_container.css( "display" ) != "block"
    else
      $( "<img>" ).attr
        src: "http://chart.apis.google.com/chart?chs=480x480&cht=qr&chl=" +
              "#{ window.location.href }?user_id=#{ user_id }",
        alt: "QRコード"
      .appendTo $( ".qr" )

      dataStore.on "send", ( data )->
        if data.value.action == "load" && data.value.user_id == user_id
          $qr_container.velocity opacity: [ 0, 1 ], DUR, -> $qr_container.hide()

      dataStore.on "send", ( data )->
        if data.value.action == "ok" && data.value.user_id == user_id
          $tutorial_container.velocity opacity: [ 0, 1 ], DUR, ->
            $tutorial_container.hide()

      $sound.on "click", ( e )->
        dataStore.send
          user_id: user_id
          action: "change"
          num: $( e.currentTarget ).data "num"

  #######################
  # EVENT LISTENER
  #######################

  ticker.listen "CHECK_MILK", ->
    if window.MilkCocoa?
      ticker.clear "CHECK_MILK"

      milkcocoa = new window.MilkCocoa "juiceiajokl77.mlkcca.com"
      dataStore = milkcocoa.dataStore "shake"

      init()

  if window.isSp
    $caution_container.find( ".caution_ok" ).on "click", ->
      for i in [ 0...5 ]
        audio[ i ] = new Audio()
        audio[ i ].src = "audio/#{ i + 1 }.mp3"
        audio[ i ].play()
        audio[ i ].pause()

      $caution_container.hide()
      $wrapper.removeClass "hide"
      $shake.show()

      dataStore.send
        user_id: user_id
        action: "ok"

      dataStore.on "send", ( data )->
        if data.value.action == "change" && data.value.user_id == user_id
          cur_audio = data.value.num

      accelHandler.listen "SHAKED", ->
        audio[ cur_audio ].currentTime = 0
        audio[ cur_audio ].play()

      accelHandler.exec()

  #######################
  # INIT
  #######################
  
  $( "<script>" ).attr
    src: "https://cdn.mlkcca.com/v2.0.0/milkcocoa.js"
  .appendTo $( "head" )

  if window.isSp
    $caution_container.hide()
    $fromSp.hide()
    $shake.hide()

module.exports = shakeInit
