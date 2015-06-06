EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instance = null
  
class AccelHandler extends EventDispatcher
  constructor: ->
    super()
    @param = [ "x", "y", "z" ]
    @param_length = @param.length
    @last_acc = {}
    for i in [ 0...@param_length ]
      @last_acc[ @param[ i ] ] = 0

    @thr = if window.isAndroid then 12 else 8

  exec: ->
    throttle = new Throttle 50

    window.addEventListener "devicemotion", ( e )->
      throttle.exec =>
        for i in [ 0...@param_length ]
          @last_acc[ @param[ i ] ] = @last_acc[ @param[ i ] ] * 0.9 +
          Math.abs( e.accelerationIncludingGravity[ @param[ i ] ] ) * 0.1

          @dispatch "SHAKED" if @last_acc[ @param[ i ] ] > @thr

getInstance = ->
  if !instance
    instance = new AccelHandler()
  return instance

module.exports = getInstance
