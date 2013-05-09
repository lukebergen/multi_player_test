class @Client
  constructor: ->

    # socket.on 'syncData', (data) ->
    #   game.syncTo(data)

    host = 'localhost'
    # host = 'node-tron.herokuapp.com'
    # host = 'vps.xoriff.com'

    socket = io.connect(host)

    socket.on 'init', (data) =>
      @game = new Game(data)
      canvas = $("#gameCanvas")[0]
      canvas.height = GAME_HEIGHT
      canvas.width = GAME_WIDTH
      $("#loading").hide()
      @renderer = new Client.Renderer(canvas, @game)

      $("#gameCanvas").on 'keydown', (e) =>
        e.preventDefault()
        # only trigger a new event if the key isn't already down
        if @player? && not @game.isKeyDown(@player.id, e.keyCode)
          @game.keyDown(@player.id, e.keyCode)
          socket.emit "keyDown",
            playerId: @player.id
            keyCode: e.keyCode

      $("#gameCanvas").on 'keyup', (e) =>
        e.preventDefault()
        # only trigger a new event if the key is currently down
        if @player? && @game.isKeyDown(@player.id, e.keyCode)
          @game.keyUp(@player.id, e.keyCode)
          socket.emit "keyUp",
            playerId: @player.id
            keyCode: e.keyCode

      $("#joinGame").click ->
        socket.emit 'playerJoin',
          name: $("#playerName")[0].value

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

$ ->
  window.client = new Client()
