// Generated by CoffeeScript 1.8.0
(function() {
  var Buff, GameScene, Player, b, book, cards, gs, magics, random, remove, root, servants, t,
    __slice = [].slice;

  book = require('./Card.coffee');

  cards = book.cards;

  servants = book.servants;

  magics = book.magics;

  Buff = book.Buff;

  random = function(n) {
    return Math.floor(Math.random() * n);
  };

  remove = function(list, n) {
    var t;
    t = list[n];
    list.splice(n, 1);
    return t;
  };

  Player = (function() {
    Player.energy = 1;

    Player.currentEnergy = 1;

    function Player(name, gs) {
      this.name = name;
      this.gs = gs;
      this.heroList = [];
      this.collectionList = [];
      this.handList = [];
      this.servantList = [];
    }

    Player.prototype.collection_pickRandom = function() {
      var t;
      t = remove(this.collectionList, random(this.collectionList.length));
      t.activate();
      return t;
    };

    Player.prototype.servantList_clearDead = function() {
      var card;
      return this.servantList = (function() {
        var _i, _len, _ref, _results;
        _ref = this.servantList;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          card = _ref[_i];
          if (card.currenthp !== 0) {
            _results.push(card);
          }
        }
        return _results;
      }).call(this);
    };

    Player.prototype.collectionToHand = function() {
      var t;
      t = remove(this.collectionList, random(this.collectionList.length));
      t.activate();
      return t;
    };

    Player.prototype.handToCollection = function() {};

    Player.prototype.collectionToServantList = function() {
      var t;
      t = remove(this.collectionList, random(this.collectionList.length));
      t.activate();
      return t;
    };

    Player.prototype.servantListToCollection = function() {};

    Player.prototype.handToServantList = function() {};

    Player.prototype.servantListToHand = function() {};

    Player.prototype.handCreate = function() {};

    Player.prototype.handDestroy = function() {};

    Player.prototype.servantListCreate = function() {};

    Player.prototype.servantListDestroy = function() {};

    Player.prototype.collectionCreate = function() {};

    Player.prototype.collectionDestroy = function() {};

    Player.prototype.drawCard = function() {
      var t;
      t = this.collection_pickRandom();
      this.handList.push(t);
      if (typeof t.onDraw === "function") {
        t.onDraw();
      }
      this.gs.fresh();
      return t;
    };

    Player.prototype.createCard = function(cardName) {
      var t;
      t = book.card(cardName);
      t.activate();
      return t;
    };

    Player.prototype.turnStart = function() {
      var currentEnergy;
      if (energy < 10) {
        energy += 1;
      }
      currentEnergy = energy;
      this.clear();
      return this.update();
    };

    Player.prototype.turnEnd = function() {
      this.clear();
      return this.update(1);
    };

    Player.prototype.clear = function() {
      var t, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
      _ref = this.handList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        t.clear();
      }
      _ref1 = this.servantList;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        t = _ref1[_j];
        t.clear();
      }
      _ref2 = this.heroList;
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        t = _ref2[_k];
        _results.push(t.clear());
      }
      return _results;
    };

    Player.prototype.update = function(n) {
      var t, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
      _ref = this.handList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        t.update(n);
      }
      _ref1 = this.servantList;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        t = _ref1[_j];
        t.update(n);
      }
      _ref2 = this.heroList;
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        t = _ref2[_k];
        _results.push(t.update(n));
      }
      return _results;
    };

    Player.prototype.useCard = function(handN, aimN, location) {
      if (location == null) {
        location = 0;
      }
    };

    Player.prototype.echo = function() {
      var h, s, str, _i, _j, _len, _len1, _ref, _ref1, _results;
      str = '';
      str += "[" + this.heroList[0].uid + ":" + this.heroList[0].name + "] ";
      _ref = this.servantList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        str += "[" + s.uid + ":" + s.name + "] ";
      }
      str += '\n';
      _ref1 = this.handList;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        h = _ref1[_j];
        _results.push(str += "[" + h.uid + ":" + h.name + "]");
      }
      return _results;
    };

    return Player;

  })();

  GameScene = {};

  GameScene.createGameScene = function() {
    var gs;
    gs = {};
    gs.attacker = new Player('attacker', gs);
    gs.defenser = new Player('defenser', gs);
    gs.attacker.enemy = gs.defenser;
    gs.defenser.enemy = gs.attacker;
    gs.turn = 0;
    gs.activePlayer = 0;
    gs.uids = {};
    gs.uidCount = 0;
    gs.dieList = [];
    gs.init = function(attackerCollection, defenserCollection) {
      var card, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.attacker.collectionList = attackerCollection;
      this.defenser.collectionList = defenserCollection;
      _ref = this.attacker.collectionList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        card = _ref[_i];
        card.gs = this;
        card.player = this.attacker;
        this.registerCard(card);
      }
      _ref1 = this.defenser.collectionList;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        card = _ref1[_j];
        card.gs = this;
        card.player = this.defenser;
        _results.push(this.registerCard(card));
      }
      return _results;
    };
    gs.gameStart = function() {};
    gs.init1 = function() {
      var c1, c2, i;
      c1 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 30; i = ++_i) {
          _results.push(book.card('tCard'));
        }
        return _results;
      })();
      c2 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 30; i = ++_i) {
          _results.push(book.card('tCard'));
        }
        return _results;
      })();
      return this.init(c1, c2);
    };
    gs.init2 = function() {
      var c1, c2, i;
      c1 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 15; i = ++_i) {
          _results.push(book.card('tCard'));
        }
        return _results;
      })();
      c1 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 15; i = ++_i) {
          _results.push(book.card('dly_Yuehuoshu'));
        }
        return _results;
      })();
      c2 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 15; i = ++_i) {
          _results.push(book.card('tCard'));
        }
        return _results;
      })();
      c2 = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 15; i = ++_i) {
          _results.push(book.card('dly_Yuehuoshu'));
        }
        return _results;
      })();
      return this.init(c1, c2);
    };
    gs.registerCard = function(card) {
      this.uids[this.uidCount++] = card;
      card.uid = this.uidCount;
      return card;
    };
    gs.addCard = function(player, cardname) {
      var card;
      card = book.card(cardname);
      card.gs = this;
      card.player = player;
      return this.registerCard(card);
    };
    gs.addToDieList = function(card) {
      return this.dieList.push(card);
    };
    gs.fresh = function(n) {
      var card, _i, _j, _len, _len1, _ref, _ref1;
      if (n == null) {
        n = 0;
      }
      _ref = this.dieList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        card = _ref[_i];
        this.broadcast('whenDie', card);
      }
      _ref1 = this.dieList;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        card = _ref1[_j];
        card.disActivate();
      }
      this.attacker.servantList_clearDead();
      this.defenser.servantList_clearDead();
      this.attacker.clear();
      this.attacker.update(n);
      this.defenser.clear();
      return this.defenser.update(n);
    };
    gs.trigger = {};
    gs.listen = function(waitter, eventName) {
      if (this.trigger[eventName] == null) {
        this.trigger[eventName] = [];
      }
      return this.trigger[eventName].push(waitter);
    };
    gs.disListen = function(waitter, eventName) {
      var card;
      if (this.trigger[eventName] != null) {
        return this.trigger[eventName] = (function() {
          var _i, _len, _ref, _results;
          _ref = this.trigger[eventName];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            card = _ref[_i];
            if (card !== waitter) {
              _results.push(card);
            }
          }
          return _results;
        }).call(this);
      }
    };
    gs.broadcast = function() {
      var args, eventName, waitter, _i, _len, _ref;
      eventName = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (this.trigger[eventName] == null) {
        return false;
      }
      _ref = this.trigger[eventName];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        waitter = _ref[_i];
        if (waitter.isSilence) {
          continue;
        }
        if (waitter[eventName].apply(waitter, args) === false) {
          return false;
        }
      }
      return true;
    };
    return gs;
  };

  console.log('\n**test**');

  gs = GameScene.createGameScene();

  gs.init1();

  t = gs.attacker.drawCard();

  gs.attacker.update(0);

  b = new Buff({
    name: 'tbuff',
    atk: 1,
    maxHp: 2,
    whenDraw: function() {
      return console.log('draw');
    }
  });

  t.addBuff(b);

  gs.fresh();

  console.log(gs.trigger);

  console.log('load GameScene..');

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.GameScene = GameScene;


  /*
  gsTest = {}
  gsTest = GameScene.createGameScene()
  gsTest.init1()
  p1 = gsTest.attacker
  p2 = gsTest.defenser
  root.gsTest = gsTest
  root.p1 = p1
  root.p2 = p2
   */

}).call(this);
