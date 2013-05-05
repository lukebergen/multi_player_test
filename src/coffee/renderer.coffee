class App.Renderer
  constructor: (canvas, game) ->
    @canvas = canvas
    @ctx = @canvas.getContext("2d")
    @game = game
    setInterval(@draw, 0.0167)
    @

  draw: =>
    @ctx.fillStyle = "rgb(0, 0, 0)"
    @ctx.fillRect(0, 0, @canvas.width, @canvas.height)
    for id, player of @game.players
      @drawObject("Player", player)
    @

  drawObject: (type, obj) ->
    if type == "Player"
      @ctx.fillStyle = "rgb(0,300,0)"
      @ctx.fillRect(obj.x, obj.y, obj.width, obj.height)
    obj