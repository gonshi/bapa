class Throttle
  if window.performance?.now?
    window.getNow = -> window.performance.now()
  else
    window.getNow = -> Date.now()

  constructor: ( minInterval )->
    @is_first = true
    @interval = minInterval
    @prevTime = 0
    @timer = null
 
  exec: ( callback )->
    _now = window.getNow()
    _delta = _now - @prevTime

    clearTimeout @timer
    if _delta >= @interval
      @prevTime = _now
      callback()
    else
      @timer = setTimeout ->
        callback()
      , @interval

  first: ( callback )->
    if @is_first
      @is_first = false
      callback()
    else
      clearTimeout @firstTimer
      @firstTimer = setTimeout =>
        @is_first = true
      , @interval

  last: ( callback )->
    clearTimeout @lastTimer
    @lastTimer = setTimeout ->
      callback()
    , @interval

  triggerend: ->
    @is_first = true

module.exports = Throttle
