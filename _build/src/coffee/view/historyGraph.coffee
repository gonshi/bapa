CanvasManager = require "./canvasManager"

$history = $( "#history" )
history = new CanvasManager $history
history.resetContext $history.width(), $history.height()
pitchHistory = []

# 自分の声をもとにおそらくこれぐらいという値
MIN_PITCH = 30

window.drawHistory = ( note )->
  history.clear()
  history.drawDivisions()
  pitchHistory.push note - MIN_PITCH
  history.drawWave pitchHistory
