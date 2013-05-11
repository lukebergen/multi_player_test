class @Game
  constructor: (initialData = {}) ->
    g = if exports? then global else window
    g.UP = 0
    g.RIGHT = 1
    g.DOWN = 2
    g.LEFT = 3
    g.GAME_WIDTH = 600
    g.GAME_HEIGHT = 600

    @ticks = initialData.ticks || 0
    @startTime = initialData.startTime || Date.now()
    @keys = initialData.keys || {}
    @players = []
    for player in (initialData.players || [])
      newP = new Player()
      newP.syncTo(player)
      @players.push(newP)

    @tickInterval = 16
    @update()
    @

  update: (scheduleNext = true) =>
    @ticks++
    if (scheduleNext)
      nextInterval = (@startTime - Date.now()) + (@ticks * @tickInterval)
      setTimeout(@update, nextInterval)
    tickStartTime = Date.now()
    for player in @players
      player.update(@)
    @collisionChecks()
    del = Date.now() - tickStartTime
    if (del > 15)
      console.log("slow tick: #{@ticks}")

  collisionChecks: =>
    for player in @players
      if (player.x <= 0 || player.y <= 0 || player.x >= GAME_WIDTH || player.y >= GAME_HEIGHT)
        @collision(player, null)
      else
        for otherPlayer in @players
          for i in [1...otherPlayer.turnPoints.length]
            unless i == otherPlayer.turnPoints.length - 1 && otherPlayer.id == player.id
              tpCount = player.turnPoints.length
              c = @lineIntersect player.x, player.y,
                                 player.turnPoints[tpCount - 1][0], player.turnPoints[tpCount - 1][1]
                                 otherPlayer.turnPoints[i-1][0], otherPlayer.turnPoints[i-1][1]
                                 otherPlayer.turnPoints[i][0], otherPlayer.turnPoints[i][1]
              if c
                @collision(player, otherPlayer)

  collision: (player, otherPlayer = null) =>
    console.log("collision")
    @players.splice(@players.findIndex(player), 1)
    @player = null

  keyDown: (playerId, keyCode) =>
    @getPlayer(playerId)?.keyDown(keyCode)

  keyUp: (playerId, keyCode) =>
    if (keyCode == 68)
      @cheat?()
    @getPlayer(playerId)?.keyUp(keyCode)

  isKeyDown: (playerId, keyCode) =>
    @getPlayer(playerId)?.keys?[keyCode] || false

  syncTo: (otherGame) =>
    # so... this is broken
    # need to re-think this
    # for otherPlayer in otherGame.players
    #   myPlayer = @getPlayer(otherPlayer.id)
    #   myPlayer.syncTo(otherPlayer)
    # tickDiffs = otherGame.ticks - @ticks
    # @ticks = otherGame.ticks
    # @keys = otherGame.keys

  addPlayer: (player) =>
    @players.push(player)
    @keys[player.id] = {}
    player

  dropPlayer: (id) =>
    index = @playerIndex(id)
    if index != -1
      @players.splice(index, 1)
    index

  getPlayer: (id) =>
    index = @playerIndex(id)
    if index == -1
      null
    else
      @players[index]

  playerIndex: (id) =>
    index = @players.findIndex (p) ->
      p.id == id
    index

  lineIntersect: (x1, y1, x2, y2, x3, y3, x4, y4) ->
    x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    if isNaN(x) || isNaN(y)
      return false
    else
      if x1 >= x2
        return false  unless x2 <= x && x <= x1
      else
        return false  unless x1 <= x && x <= x2
      if y1 >= y2
        return false  unless y2 <= y && y <= y1
      else
        return false  unless y1 <= y && y <= y2
      if x3 >= x4
        return false  unless x4 <= x && x <= x3
      else
        return false  unless x3 <= x && x <= x4
      if y3 >= y4
        return false  unless y4 <= y && y <= y3
      else
        return false  unless y3 <= y && y <= y4
    true

if (exports?)
  exports.Game = @Game
