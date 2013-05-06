// Generated by CoffeeScript 1.6.2
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Game = (function() {
    function Game(initialData) {
      var newP, player, _i, _len, _ref;

      if (initialData == null) {
        initialData = {};
      }
      this.playerIndex = __bind(this.playerIndex, this);
      this.getPlayer = __bind(this.getPlayer, this);
      this.dropPlayer = __bind(this.dropPlayer, this);
      this.addPlayer = __bind(this.addPlayer, this);
      this.syncTo = __bind(this.syncTo, this);
      this.isKeyDown = __bind(this.isKeyDown, this);
      this.keyUp = __bind(this.keyUp, this);
      this.keyDown = __bind(this.keyDown, this);
      this.update = __bind(this.update, this);
      this.ticks = initialData.ticks || 0;
      this.keys = initialData.keys || {};
      this.players = [];
      _ref = initialData.players || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        newP = new Player();
        newP.syncTo(player);
        this.players.push(newP);
      }
      setInterval(this.update, 16.7);
      this;
    }

    Game.prototype.update = function() {
      var player, _i, _len, _ref, _results;

      this.ticks++;
      _ref = this.players;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        if (this.keys[player.id][37]) {
          player.x -= player.speed;
        }
        if (this.keys[player.id][39]) {
          player.x += player.speed;
        }
        if (this.keys[player.id][38]) {
          player.y -= player.speed;
        }
        if (this.keys[player.id][40]) {
          _results.push(player.y += player.speed);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Game.prototype.keyDown = function(playerId, keyCode) {
      return this.keys[playerId][keyCode] = true;
    };

    Game.prototype.keyUp = function(playerId, keyCode) {
      if (keyCode === 68) {
        if (typeof this.cheat === "function") {
          this.cheat();
        }
      }
      return this.keys[playerId][keyCode] = false;
    };

    Game.prototype.isKeyDown = function(playerId, keyCode) {
      return this.keys[playerId][keyCode];
    };

    Game.prototype.syncTo = function(otherGame) {
      var myPlayer, otherPlayer, _i, _len, _ref;

      _ref = otherGame.players;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        otherPlayer = _ref[_i];
        myPlayer = this.getPlayer(otherPlayer.id);
        myPlayer.syncTo(otherPlayer);
      }
      this.ticks = otherGame.ticks;
      return this.keys = otherGame.keys;
    };

    Game.prototype.addPlayer = function(player) {
      this.players.push(player);
      this.keys[player.id] = {};
      return player;
    };

    Game.prototype.dropPlayer = function(id) {
      var index;

      index = this.playerIndex(id);
      if (index !== -1) {
        this.players.splice(index, 1);
      }
      return index;
    };

    Game.prototype.getPlayer = function(id) {
      var index;

      index = this.playerIndex(id);
      if (index === -1) {
        return null;
      } else {
        return this.players[index];
      }
    };

    Game.prototype.playerIndex = function(id) {
      var index;

      index = this.players.findIndex(function(p) {
        return p.id === id;
      });
      return index;
    };

    return Game;

  })();

  if ((typeof exports !== "undefined" && exports !== null)) {
    exports.Game = this.Game;
  }

}).call(this);
