// Generated by CoffeeScript 1.8.0
(function() {
  var Card, Hero, Magic, Servant, at, cards, cloneCard, ct, magics, root, servants, t,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ct = {
    magic: 1,
    servant: 2,
    hero: 4,
    weapon: 8,
    noCard: 16,
    other: 32
  };

  at = {
    all: ~0,
    none: 0,
    friend: 64,
    enemy: 128,
    hero: ct.hero,
    servant: ct.servant,
    friendHero: ct.friend | ct.hero,
    friendServant: ct.friend | ct.servant,
    enemyHero: ct.enemy | ct.hero,
    enemyServant: ct.enemy | ct.servant
  };

  cards = {};

  servants = {};

  magics = {};

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.cards = cards;

  root.servants = servants;

  root.magics = magics;

  root.ct = ct;

  root.at = at;

  cloneCard = function(card) {
    var clone, i;
    clone = {};
    if (card.constructor === Object) {
      clone = new card.constructor();
    } else {
      clone = new card.constructor(card.valueOf());
    }
    for (i in card) {
      if (typeof card[i] === 'object') {
        clone[i] = cloneCard(card[i]);
      }
      clone[i] = card[i];
    }
    return clone;
  };

  Card = (function() {
    Card.prototype.gs = {
      d: 'default',
      broadcast: function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return console.log('broadcast' + args);
      }
    };

    Card.prototype.player = {
      'default': 'default'
    };

    Card.buffs = [];

    Card.cost = 0;

    Card.currentCost = 0;

    Card.prototype.uid = 0;

    Card.prototype.aimType = at.none;

    function Card(name, cost, initial) {
      var key, value;
      this.name = name;
      this.cost = cost;
      console.log("create a card [" + this.name + "]");
      this.currentCost = this.cost;
      this.tags = [];
      for (key in initial) {
        value = initial[key];
        if (key.indexOf('when') === 0) {
          this.tags.push(key);
        }
        this[key] = value;
      }
    }

    Card.prototype.clone = function() {
      return cloneCard(this);
    };

    Card.prototype.clear = function() {
      return this.currentCost = this.cost;
    };

    Card.prototype.update = function() {};

    Card.prototype.use = function(aim) {
      var alignment;
      if (this.cost > this.player.currentEnergy) {
        console.log('mana is not enough');
        return false;
      }
      if (this.useCondition != null) {
        if (!this.useCondition()) {
          return false;
        }
      }
      alignment = at.enemy;
      if (aim.player === this.player) {
        alignment = at.friend;
      }
      if ((this.aimType & (alignment | aim.type)) === 0) {
        console.log('aim is illegal');
        return false;
      }
      this.player.currentEnergy -= this.cost;
      console.log('cost mana ' + this.cost);
      return this.gs.broadcast('whenUseCard', this, aim);
    };

    Card.prototype.addBuff = function(buff) {
      return this.buffs.push(buff);
    };

    Card.prototype.startListen = function() {
      var eventName, _i, _len, _ref, _results;
      _ref = this.tags;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        eventName = _ref[_i];
        _results.push(this.gs.listen(this, eventName));
      }
      return _results;
    };

    Card.prototype.damage = function(aim, v) {
      if (this.gs.broadcast('whenDamage', this, aim, v)) {
        return aim.beDamaged(this, v);
      }
    };

    Card.prototype.friendHero = function() {
      return player.heroList[0];
    };

    Card.prototype.enemyHero = function() {
      return player.enemy.heroList[0];
    };

    return Card;

  })();

  Servant = (function(_super) {
    __extends(Servant, _super);

    Servant.prototype.type = ct.servant;

    Servant.prototype.aimType = at.all;

    Servant.currentAtk = 0;

    Servant.currentMaxHp = 0;

    Servant.currentHp = 0;

    Servant.attackTimes = 1;

    function Servant(name, cost, atk, maxHp, initial) {
      this.name = name;
      this.cost = cost;
      this.atk = atk;
      this.maxHp = maxHp;
      Servant.__super__.constructor.call(this, this.name, this.cost, initial);
      console.log("create a servant [" + this.name + "]");
      this.currentAtk = this.atk;
      this.currentMaxHp = this.maxHp;
      this.currentHp = this.maxHp;
    }

    Servant.prototype.clear = function() {
      Servant.__super__.clear.call(this);
      this.currentAtk = this.atk;
      this.currentMaxHp = this.maxHp;
      return this.attackTimes = 1;
    };

    Servant.prototype.update = function() {
      Servant.__super__.update.call(this);
      if (this.currentHp > this.currentMaxHp) {
        return this.currentHp = this.currentMaxHp;
      }
    };

    Servant.prototype.beCalled = function() {};

    Servant.prototype.attack = function(aim) {
      return console.log('Servant attack on the aim: #{aim}');
    };

    Servant.prototype.use = function(aim) {
      return Servant.__super__.use.call(this, aim);
    };

    Servant.prototype.beDamaged = function(byWho, v) {
      if (this.gs.broadcast('whenBeDamaged', this, byWho, v)) {
        this.currenthp -= v;
        if (this.currenthp <= 0) {
          return this.die(byWho);
        }
      }
    };

    Servant.prototype.die = function(byWho) {
      if (this.gs.broadcast('whenDie', this, byWho)) {
        return console.log('die');
      }
    };

    return Servant;

  })(Card);

  Hero = (function(_super) {
    __extends(Hero, _super);

    function Hero(name, maxHp, initial) {
      this.name = name;
      this.maxHp = maxHp;
      Hero.__super__.constructor.call(this, this.name, 0, 0, this.maxHp, initial);
    }

    return Hero;

  })(Servant);

  Magic = (function(_super) {
    __extends(Magic, _super);

    Magic.prototype.type = ct.magic;

    Magic.prototype.aimType = at.all;

    function Magic(name, cost, power, initial) {
      this.name = name;
      this.cost = cost;
      this.power = power;
      Magic.__super__.constructor.call(this, this.name, this.cost, initial);
      console.log("create a magic [" + this.name + "]");
    }

    Magic.prototype.use = function(aim) {
      Magic.__super__.use.call(this, aim);
      return typeof this.onUse === "function" ? this.onUse(aim) : void 0;
    };

    Magic.prototype.damage = function(aim) {
      if (this.gs.broadcast('whenMagicDamage', this, aim, this.power)) {
        return Magic.__super__.damage.call(this, aim, this.power);
      }
    };

    Magic.prototype.changeEnergy = function(player) {};

    Magic.prototype.addCurrentEnergy = function(v) {
      return console.log('add' + v + 'energy');
    };

    Magic.prototype.addEnergy = function(player, v) {
      return console.log('add energy');
    };

    Magic.prototype.heal = function(aim, v) {
      return console.log('heal ');
    };

    Magic.prototype.addBuff = function(aim, atk, hp) {};

    return Magic;

  })(Card);

  cards.tCard = new Servant('TestMonster', 5, 5, 5, {
    whenDie: function() {
      return console.log('testMonster is die');
    },
    whenCall: function() {
      return console.log('testMonster hears a servant is called');
    }
  });

  magics.dly_Yuehuoshu = new Magic('月火术', 0, 1, {
    onUse: function(aim) {
      return this.damage(aim);
    }
  });

  magics.dly_Jihuo = new Magic('激活', 0, 0, {
    onUse: function() {
      return this.addCurrentEnergy(2);
    }
  });

  magics.dly_Zhaoji = new Magic('爪击', 1, 0, {
    onUse: function() {}
  });

  magics.dly_Ziranpinghen = new Magic('自然平衡', 1, 0, {
    onUse: function(aim) {}
  });

  magics.dly_Yemanzhiji = new Magic('dly_Yemanzhiji', 1, 0, {
    onUse: function(aim) {
      return this.damage(this.friendHero().currentAtk);
    }
  });

  magics.dly_Fennu = new Magic('dly_Fennu', 2, 0, {});

  servants.dly_Jixiedianduxiongzai = new Servant('dly_Jixiedianduxiongzai', 2, 2, 2, {});

  magics.dly_Yexingzhili = new Magic('dly_Yexingzhili', 2, 0, {});

  magics.dly_Yexingyingji = new Magic('dly_Yexingyingji', 2, 0, {});

  magics.dly_Yexingchengzhang = new Magic('dly_Yexingchengzhang', 2, 0, {
    onUse: function(aim) {
      return this.addEnergy(aim.player, 1);
    }
  });

  servants.dly_Conglingshuyao = new Servant('dly_Conglingshuyao', 3, 2, 4, {});

  magics.dly_Ziranzhichu = new Magic('dly_Ziranzhichu', 3, 0, {
    onUse: function(aim) {
      return this.heal(aim, 8);
    }
  });

  magics.dly_ZiranYingji = new Magic('dly_ZiranYingji', 3, 0, {});

  magics.dly_Yemanpaoxiao = new Magic('dly_Yemanpaoxiao', 3, 0, {
    onUse: function() {}
  });

  magics.dly_Conglinzhihun = new Magic('dly_Conglinzhihun', 4, 0, {
    onUse: function() {}
  });

  (function() {
    var key, value, _results;
    for (key in magics) {
      value = magics[key];
      cards[key] = value;
    }
    _results = [];
    for (key in servants) {
      value = servants[key];
      _results.push(cards[key] = value);
    }
    return _results;
  })();

  root.card = function(name) {
    var _ref;
    return (_ref = cards[name]) != null ? _ref.clone() : void 0;
  };

  root.magic = function(name) {
    var _ref;
    return (_ref = magics[name]) != null ? _ref.clone() : void 0;
  };

  root.servant = function(name) {
    var _ref;
    return (_ref = servants[name]) != null ? _ref.clone() : void 0;
  };

  t = new Card('testCard', 1, {
    whenDraw: function() {
      return console.log('whenDraw');
    }
  });

  t.player.currentEnergy = 1;

  t.use(cards.dly_Yuehuoshu);

  console.log(t.aimType);

  console.log(cards.dly_Yuehuoshu.type === ct.magic);

  console.log('load Cards..');

}).call(this);