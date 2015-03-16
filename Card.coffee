#define card type
ct = 
	magic: 1
	servant: 2
	hero: 4
	weapon: 8
	noCard: 16
	other: 32
#define aim type (just check when use)
at = 
	all: ~0
	none: 0 #can't use
	friend: 64 #
	enemy: 128 #
	hero: ct.hero
	servant: ct.servant
	friendHero: ct.friend|ct.hero
	friendServant: ct.friend|ct.servant
	enemyHero: ct.enemy|ct.hero
	enemyServant: ct.enemy|ct.servant

#storage of all the game elements
cards = {}
servants = {}
magics = {}
#to global
root = exports ? window
root.cards = cards
root.servants = servants
root.magics = magics
root.ct = ct
root.at = at
root.card = (name) ->
	cards[name]?.clone()

root.magic = (name) ->
	magics[name]?.clone()

root.servant = (name) ->
	servants[name]?.clone()

cloneCard = (card) ->
	clone = {}
	if card.constructor is Object
		clone = new card.constructor();
	else 
		clone = new card.constructor(card.valueOf())
	for i of card
		clone[i] = cloneCard(card[i]) if typeof card[i] is 'object'
		clone[i] = card[i]
	return clone

class Card
	this::gs = {
		d:'default'
		broadcast: (args...) -> console.log 'broadcast' + args
		listen: (args...) -> console.log 'listen  ' + args
	}
	this::player = {'default'} # default
	#attribute
	@cost = 0
	@currentCost = 0
	this::uid = 0
	this::aimType = at.none
	#@buffs = []
	#this::tags = [] use the same object
	#gs means the instance in wich gameScene
	constructor: (@name, @cost, initial) ->
		console.log "create a card [#{@name}]"
		@currentCost = @cost
		@buffs = []
		@tags = []
		for key, value of initial
			@tags.push key if key.indexOf('when') is 0 #create the tags by it's attribute
			this[key] = value

	activate: -> #add it to cetain tags in gs
		@gs.listen this, tag for tag in @tags

	destroy: -> #disActivate the card from the gs
		@gs.disListen this, tag for tag in @tags

	#clone this card
	clone: ->
		return cloneCard(this)

	clear: ->
		@currentCost = @cost

	update: ->
		buff.update() for buff in @buffs

	#Player use initiative, return boolean
	use: (aim) ->
		#check energy in Player
		if @cost > @player.currentEnergy
			console.log 'mana is not enough'
			return false
		#condition recall # duyao
		if @useCondition?
			return false unless @useCondition() # unless return true
		#check aimType
		alignment = at.enemy
		alignment = at.friend if aim.player is @player
		if (@aimType & (alignment|aim.type)) is 0
			console.log 'aim is illegal'
			return false
		#use mana
		@player.currentEnergy -= @cost
		console.log 'cost mana ' + @cost
		#return if trigger refuse the card
		return @gs.broadcast('whenUseCard', this, aim)


	addBuff: (buff) ->
		# if trigger('addBuff', source, this, buff)
		buff.owner = this
		buff.activate()
		@buffs.push buff

	removeBuff: (buff) ->
		buff.disActivate()
		@buffs = (t for t in @buffs when t isnt buff)

	startListen: ->
		@gs.listen(this, eventName) for eventName in @tags

	damage: (aim, v) ->
		# damage can be refuse by 'shendun' or 'mianyi'...
		if @gs.broadcast('whenDamage', this, aim, v)
			aim.beDamaged this, v

	friendHero: ->
		player.heroList[0]

	enemyHero: ->
		player.enemy.heroList[0]

class Servant extends Card
	this::type = ct.servant # default type
	this::aimType = at.all # defualt is all
	@currentAtk = 0
	@currentMaxHp = 0
	@currentHp = 0
	@attackTimes = 1
	#[name, cost, atk, maxHp]
	constructor: (@name, @cost, @atk, @maxHp, initial) ->
		super(@name, @cost, initial)
		console.log "create a servant [#{@name}]"
		@currentAtk = @atk
		@currentMaxHp = @maxHp
		@currentHp = @maxHp

	clear: ->
		super()
		@currentAtk = @atk
		@currentMaxHp = @maxHp
		@attackTimes = 1

	update: ->
		super()
		@currentHp = @currentMaxHp if @currentHp > @currentMaxHp

	beCalled: ->
		#put in to battle field

	attack: (aim) ->
		console.log 'Servant attack on the aim: #{aim}'

	#aim use to battleCry
	use: (aim) ->
		super(aim)
		#call a servant on desktop

	beDamaged: (byWho, v) ->
		#'shendun' uses after 'mianyi', use 'whenUpdate' to trigger 'rage'
		if @gs.broadcast('whenBeDamaged', this, byWho, v)
			@currenthp -= v
			@die(byWho) if @currenthp <= 0

	die: (byWho) ->
		#'minglingnuhou' will refuse this event
		if @gs.broadcast('whenDie', this, byWho)
			console.log 'die'#die

class Hero extends Servant
	constructor: (@name, @maxHp, initial) ->
		super(@name, 0, 0, @maxHp, initial)


class Magic extends Card
	this::type = ct.magic
	this::aimType = at.all
	constructor: (@name, @cost, @power, initial) ->
		super(@name, @cost, initial)
		console.log "create a magic [#{@name}]"

	use: (aim) ->
		super(aim)
		@onUse?(aim)#must be confirm

	damage: (aim) ->
		# may be a magic armor
		if @gs.broadcast('whenMagicDamage', this, aim, @power)
			#count 'magic power'
			super(aim, @power) # card damage

	changeEnergy: (player) ->

	addCurrentEnergy: (v) ->
		console.log 'add' + v + 'energy'

	addEnergy: (player, v) ->
		console.log 'add energy'

	heal: (aim, v) ->
		console.log 'heal '

	addBuff: (aim, atk, hp) ->
		#for servant

cards.tCard =
new Servant 'TestMonster', 5, 5, 5, {
	whenDie: -> console.log 'testMonster is die'
	whenCall: -> console.log 'testMonster hears a servant is called'
}

magics.dly_Yuehuoshu =
new Magic '月火术', 0, 1, {
	onUse: (aim) -> @damage(aim)
}
magics.dly_Jihuo =
new Magic '激活', 0, 0, {
	onUse: -> @addCurrentEnergy 2
}
magics.dly_Zhaoji =
new Magic '爪击', 1, 0, {
	onUse: ->
		#add one turn atk buff
		#add one add armor
}
magics.dly_Ziranpinghen =
new Magic '自然平衡', 1, 0, {
	onUse: (aim) ->
		# destroy aim
}
# 4
magics.dly_Yemanzhiji =
new Magic 'dly_Yemanzhiji', 1, 0, {
	onUse: (aim) ->
		@damage @friendHero().currentAtk
}
magics.dly_Fennu = 
new Magic 'dly_Fennu', 2, 0, {

}
servants.dly_Jixiedianduxiongzai =
new Servant 'dly_Jixiedianduxiongzai', 2, 2, 2, {

}
magics.dly_Yexingzhili =
new Magic 'dly_Yexingzhili', 2, 0, {
	#select1: new Selection(aim, condition, effect)
	#select2: new Selection
}
# 8
magics.dly_Yexingyingji =
new Magic 'dly_Yexingyingji', 2, 0, {
	# buff taun
}
magics.dly_Yexingchengzhang =
new Magic 'dly_Yexingchengzhang', 2, 0, {
	onUse: (aim) ->
		@addEnergy aim.player, 1
}
servants.dly_Conglingshuyao =
new Servant 'dly_Conglingshuyao', 3, 2, 4, {

}
magics.dly_Ziranzhichu =
new Magic 'dly_Ziranzhichu', 3, 0, {
	onUse: (aim) ->
		@heal aim, 8
}
# 12
magics.dly_ZiranYingji =
new Magic 'dly_ZiranYingji', 3, 0, {

}
magics.dly_Yemanpaoxiao =
new Magic 'dly_Yemanpaoxiao', 3, 0, {
	onUse: ->
		#get all friend
		#add 2 one turn attack buff
}
magics.dly_Conglinzhihun =
new Magic 'dly_Conglinzhihun', 4, 0, {
	onUse: ->
		#get all friend
		#add when die buff
}

# do collection
do ->
	for key, value of magics
		cards[key] = value
	for key, value of servants
		cards[key] = value


#test**************************
t = new Card 'testCard', 1, {
	whenDraw: -> console.log 'whenDraw'
}
t.player.currentEnergy = 1
t.use(cards.dly_Yuehuoshu)
console.log t.tags
console.log cards.dly_Yuehuoshu.tags
t.activate()
console.log t.gs

console.log 'load Cards..'