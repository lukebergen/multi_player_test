// Generated by CoffeeScript 1.6.2
(function() {
  var app, express, g, game, io, p, port, server, socketPlayerMap, sugar, _ref,
    _this = this;

  sugar = require('sugar');

  express = require('express');

  app = express();

  app.configure(function() {
    app.use(express.bodyParser());
    return app.use(express["static"](__dirname + '/'));
  });

  port = (typeof process !== "undefined" && process !== null ? (_ref = process.env) != null ? _ref.PORT : void 0 : void 0) || 8080;

  server = app.listen(port);

  console.log("server started on " + port);

  io = require('socket.io').listen(server);

  io.set('log level', 1);

  g = require('./js/game');

  p = require('./js/player');

  game = new g.Game();

  setInterval(function() {
    return io.sockets.emit('syncTo', game);
  }, 500);

  socketPlayerMap = {};

  io.sockets.on('connection', function(socket) {
    socket.on('keyDown', function(data) {
      io.sockets.emit('keyDown', data);
      return game.keyDown(data.playerId, data.keyCode);
    });
    socket.on('keyUp', function(data) {
      io.sockets.emit('keyUp', data);
      return game.keyUp(data.playerId, data.keyCode);
    });
    socket.on('playerJoin', function() {
      var player;

      player = new p.Player();
      console.log("adding new player: ", player.id);
      socketPlayerMap[socket.id] = player.id;
      game.addPlayer(player);
      io.sockets.emit('newPlayer', player);
      return socket.emit('playerIdentify', {
        id: player.id
      });
    });
    socket.on('disconnect', function() {
      var playerId;

      console.log("disconnecting socket/player: ", socket.id, socketPlayerMap[socket.id]);
      playerId = socketPlayerMap[socket.id];
      io.sockets.emit('playerDrop', playerId);
      game.dropPlayer(playerId);
      return delete socketPlayerMap[socket.id];
    });
    return socket.emit('init', game);
  });

}).call(this);
