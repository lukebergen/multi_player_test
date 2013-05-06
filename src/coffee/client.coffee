class @Client
  constructor: ->

    # socket.on 'syncData', (data) ->
    #   game.syncTo(data)

    # host = 'localhost'
    host = 'node-tron.herokuapp.com'
    # host = 'vps.xoriff.com'

    socket = io.connect(host)

    socket.on 'init', (data) =>
      @game = new Game(data)
      @game.cheat = ->
        @players[0].speed = 4
      canvas = $("#gameCanvas")[0]
      @renderer = new Client.Renderer(canvas, @game)
      socket.emit 'playerJoin'

    socket.on 'newPlayer', (player) =>
      newP = new Player()
      newP.syncTo(player)
      @game.addPlayer newP

    socket.on 'playerDrop', (id) =>
      @game.dropPlayer(id)

    socket.on 'playerIdentify', (r) =>
      @player = @game.getPlayer(r.id)

    socket.on 'syncTo', (game) =>
      @game.syncTo(game)

    socket.on 'keyDown', (data) =>
      @game.keyDown(data.playerId, data.keyCode)

    socket.on 'keyUp', (data) =>
      @game.keyUp(data.playerId, data.keyCode)

    $(window).keydown (e) =>
      e.preventDefault()
      # only trigger a new event if the key isn't already down
      unless @game.isKeyDown(@player.id, e.keyCode)
        @game.keyDown(@player.id, e.keyCode)
        socket.emit "keyDown",
          playerId: @player.id
          keyCode: e.keyCode

    $(window).keyup (e) =>
      e.preventDefault()
      # only trigger a new event if the key is currently down
      if @game.isKeyDown(@player.id, e.keyCode)
        @game.keyUp(@player.id, e.keyCode)
        socket.emit "keyUp",
          playerId: @player.id
          keyCode: e.keyCode

$ ->
  window.client = new Client()