// Generated by CoffeeScript 1.6.2
(function() {
  var Client;

  this.App = {};

  Client = (function() {
    function Client() {
      var host, socket, _ref,
        _this = this;

      host = (typeof process !== "undefined" && process !== null ? (_ref = process.env) != null ? _ref.HOST : void 0 : void 0) || 'localhost';
      socket = io.connect(host);
      socket.on('init', function(data) {
        var canvas;

        _this.game = new Game(data);
        canvas = $("#gameCanvas")[0];
        _this.renderer = new App.Renderer(canvas, _this.game);
        return socket.emit('playerJoin');
      });
      socket.on('newPlayer', function(player) {
        return _this.game.addPlayer(player);
      });
      socket.on('playerDrop', function(id) {
        return _this.game.dropPlayer(id);
      });
      socket.on('playerIdentify', function(r) {
        return _this.player = _this.game.getPlayer(r.id);
      });
      socket.on('keyDown', function(data) {
        return _this.game.keyDown(data.playerId, data.keyCode);
      });
      socket.on('keyUp', function(data) {
        return _this.game.keyUp(data.playerId, data.keyCode);
      });
      $(window).keydown(function(e) {
        e.preventDefault();
        if (!_this.game.isKeyDown(_this.player.id, e.keyCode)) {
          return socket.emit("keyDown", {
            playerId: _this.player.id,
            keyCode: e.keyCode
          });
        }
      });
      $(window).keyup(function(e) {
        e.preventDefault();
        if (_this.game.isKeyDown(_this.player.id, e.keyCode)) {
          return socket.emit("keyUp", {
            playerId: _this.player.id,
            keyCode: e.keyCode
          });
        }
      });
    }

    return Client;

  })();

  $(function() {
    return window.client = new Client();
  });

}).call(this);
