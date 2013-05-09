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
    @keys = initialData.keys || {}
    @players = []
    for player in (initialData.players || [])
      newP = new Player()
      newP.syncTo(player)
      @players.push(newP)
    setInterval(@update, 16)
    @

  update: =>
    startTime = Date.now()
    @ticks++
    for player in @players
      player.update(@)
    del = Date.now() - startTime
    if (del > 15)
      console.log("slow tick: #{@ticks}")

  keyDown: (playerId, keyCode) =>
    @getPlayer(playerId).keyDown(keyCode)

  keyUp: (playerId, keyCode) =>
    if (keyCode == 68)
      @cheat?()
    @getPlayer(playerId).keyUp(keyCode)

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

if (exports?)
  exports.Game = @Game
