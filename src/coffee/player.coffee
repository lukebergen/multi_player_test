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
    @previousKeys = {}
    @turnPoints = [[@x, @y]]
    @color = @randColor()

  update: (game) =>
    @handleInput(game)
    @updateLocation()

  handleInput: (game) =>
    turnedThisUpdate = false
    if @keys[37]
      if (@dir == UP || @dir == DOWN) && !@previousKeys[37] && !turnedThisUpdate
        @dir = LEFT
        @turnPoints.push([@x, @y])
        turnedThisUpdate = true
      @previousKeys[37] = true
    else
      @previousKeys[37] = false
    if @keys[39]
      if (@dir == UP || @dir == DOWN) && !@previousKeys[39] && !turnedThisUpdate
        @dir = RIGHT
        @turnPoints.push([@x, @y])
        turnedThisUpdate = true
      @previousKeys[39] = true
    else
      @previousKeys[39] = false
    if @keys[38]
      if (@dir == LEFT || @dir == RIGHT) && !@previousKeys[38] && !turnedThisUpdate
        @dir = UP
        @turnPoints.push([@x, @y])
        turnedThisUpdate = true
      @previousKeys[38] = true
    else
      @previousKeys[38] = false
    if @keys[40]
      if (@dir == LEFT || @dir == RIGHT) && !@previousKeys[40] && !turnedThisUpdate
        @dir = DOWN
        @turnPoints.push([@x, @y])
        turnedThisUpdate = true
      @previousKeys[40] = true
    else
      @previousKeys[40] = false

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