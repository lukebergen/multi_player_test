sugar = require('sugar')
express = require('express')
app = express()

app.configure ->
  app.use(express.bodyParser())
  app.use(express.static(__dirname + '/'))

# server = app.listen 8080
port = process?.env?.PORT || 8080
server = app.listen port
console.log "server started on #{port}"

io = require('socket.io').listen(server)
io.set 'log level', 1

g = require './js/game'
p = require './js/player'

game = new g.Game()

socketPlayerMap = {}

io.sockets.on 'connection', (socket) =>
  socket.on 'keyDown', (data) ->
    io.sockets.emit 'keyDown', data
    game.keyDown(data.playerId, data.keyCode)
  socket.on 'keyUp', (data) ->
    io.sockets.emit 'keyUp', data
    game.keyUp(data.playerId, data.keyCode)
  socket.on 'playerJoin', ->
    player = new p.Player()
    console.log("adding new player: ", player.id)
    socketPlayerMap[socket.id] = player.id
    game.addPlayer(player)
    io.sockets.emit 'newPlayer', player
    socket.emit 'playerIdentify', {id: player.id}
  socket.on 'disconnect', ->
    console.log("disconnecting socket/player: ", socket.id, socketPlayerMap[socket.id])
    playerId = socketPlayerMap[socket.id]
    io.sockets.emit 'playerDrop', playerId
    game.dropPlayer(playerId)
    delete socketPlayerMap[socket.id]
  socket.emit 'init', game