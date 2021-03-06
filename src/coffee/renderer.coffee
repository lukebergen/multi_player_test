class Client.Renderer
  constructor: (canvas, game) ->
    @canvas = canvas
    @ctx = @canvas.getContext("2d")
    @game = game
    @renderStartTime = Date.now()
    @renderTicks = 0
    @rendererStartTime = Date.now()
    @tickInterval = 16
    @draw()
    @

  draw: =>
    @renderTicks++
    nextInterval = (@rendererStartTime - Date.now()) + (@renderTicks * @tickInterval)
    setTimeout(@draw, nextInterval)
    s = Date.now()
    @ctx.fillStyle = "rgb(0, 0, 0)"
    @ctx.fillRect(0, 0, @canvas.width, @canvas.height)
    for id, player of @game.players
      @drawObject("Player", player)
    if (s - Date.now() > @tickInterval)
      console.log("slow draw")
    @

  drawObject: (type, obj) ->
    if type == "Player"
      @ctx.fillStyle = obj.color
      @ctx.fillRect(obj.x - (obj.width / 2.0), obj.y - (obj.height / 2.0), obj.width, obj.height)
      @ctx.beginPath()
      tp = obj.turnPoints[0]
      @ctx.moveTo(tp[0], tp[1])
      for i in [1...obj.turnPoints.length]
        tp = obj.turnPoints[i]
        @ctx.lineTo(tp[0], tp[1])
      @ctx.lineTo(obj.x, obj.y)
      @ctx.strokeStyle = obj.color
      @ctx.stroke()
    obj