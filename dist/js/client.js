// Generated by CoffeeScript 1.6.2
(function() {
  this.Client = (function() {
    function Client() {
      var host, socket,
        _this = this;

      host = 'localhost';
      socket = io.connect(host);
      socket.on('init', function(data) {
        var canvas;

        _this.game = new Game(data);
        canvas = $("#gameCanvas")[0];
        canvas.height = GAME_HEIGHT;
        canvas.width = GAME_WIDTH;
        $("#loading").hide();
        _this.renderer = new Client.Renderer(canvas, _this.game);
        $("#gameCanvas").on('keydown', function(e) {
          e.preventDefault();
          if ((_this.player != null) && !_this.game.isKeyDown(_this.player.id, e.keyCode)) {
            _this.game.keyDown(_this.player.id, e.keyCode);
            return socket.emit("keyDown", {
              playerId: _this.player.id,
              keyCode: e.keyCode
            });
          }
        });
        $("#gameCanvas").on('keyup', function(e) {
          e.preventDefault();
          console.log("canvas key up");
          if ((_this.player != null) && _this.game.isKeyDown(_this.player.id, e.keyCode)) {
            _this.game.keyUp(_this.player.id, e.keyCode);
            return socket.emit("keyUp", {
              playerId: _this.player.id,
              keyCode: e.keyCode
            });
          }
        });
        return $("#joinGame").click(function() {
          return socket.emit('playerJoin', {
            name: $("#playerName")[0].value
          });
        });
      });
      socket.on('newPlayer', function(player) {
        var newP;

        newP = new Player();
        newP.syncTo(player);
        return _this.game.addPlayer(newP);
      });
      socket.on('playerDrop', function(id) {
        return _this.game.dropPlayer(id);
      });
      socket.on('playerIdentify', function(r) {
        return _this.player = _this.game.getPlayer(r.id);
      });
      socket.on('syncTo', function(game) {
        return _this.game.syncTo(game);
      });
      socket.on('keyDown', function(data) {
        return _this.game.keyDown(data.playerId, data.keyCode);
      });
      socket.on('keyUp', function(data) {
        return _this.game.keyUp(data.playerId, data.keyCode);
      });
    }

    return Client;

  })();

  $(function() {
    return window.client = new Client();
  });

}).call(this);
