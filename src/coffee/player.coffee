class @Player
  constructor: ->
    @id = @randId()
    @x = 0
    @y = 0
    @width = 10
    @height = 20
    @speed = 1.0

  syncTo: (other) =>
    @id = other.id
    @x = other.x
    @y = other.y
    @width = other.width
    @height = other.height
    @speed = other.speed

  randId: ->
    Math.random().toString(36).substr(2, 16)

if (exports?)
  exports.Player = @Player