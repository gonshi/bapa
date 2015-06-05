class CanvasManager
  constructor: ( $dom )->
    @canvas = $dom.get 0
    if !@canvas.getContext
      return undefined
    @ctx = @canvas.getContext "2d"

  resetContext: ( width, height )->
    @canvas.width = width
    @canvas.height = height

  clear: -> @ctx.clearRect 0, 0, @canvas.width, @canvas.height

  drawDivisions: ->
    @ctx.strokeStyle = "red"
    @ctx.beginPath()
    @ctx.moveTo 0, 0
    @ctx.lineTo 0, 256
    @ctx.moveTo 128, 0
    @ctx.lineTo 128, 256
    @ctx.moveTo 256, 0
    @ctx.lineTo 256, 256
    @ctx.moveTo 384, 0
    @ctx.lineTo 384, 256
    @ctx.moveTo 512, 0
    @ctx.lineTo 512, 256
    @ctx.stroke()

  drawWave: ( history )->
    _historyLength = history.length
    @ctx.strokeStyle = "black"
    @ctx.beginPath()
    @ctx.moveTo @canvas.width - _historyLength + i,
                history[ i ] / 100 * @canvas.height
    for i in [ 0..._historyLength ]
      @ctx.lineTo @canvas.width - _historyLength + i,
                  history[ i ] / 100 * @canvas.height
    @ctx.stroke()

  getImgData: ( x, y, width, height )->
    @ctx.getImageData x, y, width, height

  getImg: -> @canvas.toDataURL()

  getContext: -> @ctx

module.exports = CanvasManager
