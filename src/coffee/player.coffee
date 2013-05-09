class @Player
  constructor: ->
    @id = @randId()
    @x = Math.random() * GAME_WIDTH
    @y = Math.random() * GAME_HEIGHT
    @dir = Math.floor(Math.random() * 4)
    @width = 10
    @height = 10
    @speed = 1.0
    @keys = {}
    @turnPoints = [[@x, @y]]
    @color = @randColor()

  update: (game) =>
    @handleInput()
    @updateLocation()

  handleInput: =>
    if @keys[37]
      if @dir == UP || @dir == DOWN
        @dir = LEFT
        @turnPoints.push([@x, @y])
    if @keys[39]
      if @dir == UP || @dir == DOWN
        @dir = RIGHT
        @turnPoints.push([@x, @y])
    if @keys[38]
      if @dir == LEFT || @dir == RIGHT
        @dir = UP
        @turnPoints.push([@x, @y])
    if @keys[40]
      if @dir == LEFT || @dir == RIGHT
        @dir = DOWN
        @turnPoints.push([@x, @y])

  keyDown: (code) =>
    @keys[code] = true

  keyUp: (code) =>
    @keys[code] = false

  updateLocation: =>
    if @dir == UP
      @y -= @speed
    else if @dir == RIGHT
      @x += @speed
    else if @dir == DOWN
      @y += @speed
    else
      @x -= @speed

  syncTo: (other) =>
    @id = other.id
    @x = other.x
    @y = other.y
    @width = other.width
    @height = other.height
    @speed = other.speed
    @keys = other.keys
    @turnPoints = other.turnPoints

  randId: ->
    Math.random().toString(36).substr(2, 16)

  randColor: ->
    str = "rgb(#{Math.round(Math.random() * 256)}, #{Math.round(Math.random() * 256)}, #{Math.round(Math.random() * 256)})"
    str

if (exports?)
  exports.Player = @Player