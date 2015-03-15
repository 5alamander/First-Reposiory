
#import
book = require './Card.coffee'
cards = book.cards
servants = book.servants
magics = book.magics
trigger = book.trigger

random = (n) ->
	Math.floor(Math.random() * n)

remove = (list, n) ->
	t = list[n]
	list.splice(n, 1)
	return t

class Player
	#enemy
	@energy = 1
	@currentEnergy = 1

	constructor: (@name, @gs) ->
		@heroList = []
		@collectionList = []
		@handList = []
		@servantList = []

	#draw card from collection to hand
	drawCard: ->
		t = @pickCollection()
		@handList.push t
		t.onDraw?()# only some card
		return t # for chain

	pickCollection: ->
		t = remove(@collectionList, random(@collectionList.length))
		t.activate()
		return t

	turnStart: ->
		#get turn energy
		energy += 1 if energy < 10
		currentEnergy = energy

	turnEnd: ->

	clear: ->
		t.clear() for t in @handList
		t.clear() for t in @servantList
		t.clear() for t in heroList

	update: ->
		t.update() for t in @handList
		t.update() for t in @servantList
		t.update() for t in @heroList
	
	useCard: (handN, aimN, location = 0) ->
		#use uid
		#if use a servant, it also need a location

	echo: -> 
		#use the uid and name to echo
		str = ''
		str += "[#{@heroList[0].uid}:#{@heroList[0].name}] "
		for s in @servantList
			str += "[#{s.uid}:#{s.name}] "
		str += '\n'
		for h in @handList
			str += "[#{h.uid}:#{h.name}]"


GameScene = {}
GameScene.createGameScene = ->
	gs = {}
	gs.attacker = new Player('attacker', gs)
	gs.defenser = new Player('defenser', gs)
	gs.attacker.enemy = gs.defenser # set alignment
	gs.defenser.enemy = gs.attacker # say R(attacker, defenser) = 'enemy'
	gs.turn = 0
	gs.activePlayer = 0 # 0:attacker, 1:defender
	gs.uids = {}
	gs.uidCount = 0

	#init
	gs.init = (attackerCollection, defenserCollection) -> 
		@attacker.collectionList = attackerCollection
		@defenser.collectionList = defenserCollection
		#to bind all in collection
		for card in @attacker.collectionList
			card.gs = this
			card.player = @attacker
			@registerCard(card)
		for card in @defenser.collectionList
			card.gs = this
			card.player = @defenser
			@registerCard(card)
	
	gs.gameStart = ->

	gs.init1 = ->
		c1 = (book.card('tCard') for i in [1..30])
		c2 = (book.card('tCard') for i in [1..30])
		@init(c1, c2)

	gs.init2 = ->
		c1 = (book.card('tCard') for i in [1..15])
		c1 = (book.card('dly_Yuehuoshu') for i in [1..15])
		c2 = (book.card('tCard') for i in [1..15])
		c2 = (book.card('dly_Yuehuoshu') for i in [1..15])

	# get a uid in this gameScene
	gs.registerCard = (card) ->
		@uids[@uid++] = card
		card.uid = @uid
		return card # for chain

	gs.addCard = (player, cardname) ->
		card = book.card(cardname)
		card.gs = this
		card.player = player
		@registerCard(card)

	gs.trigger = {}# be used by listen and broadcast

	gs.listen = (waitter, eventName) ->
		unless @trigger[eventName]? then @trigger[eventName] = []
		@trigger[eventName].push waitter

	gs.disListen = (waitter, eventName) ->
		if @trigger[eventName]?
			@trigger[eventName] = (card for card in @trigger[eventName] when !(card is waitter))

	gs.broadcast = (eventName, args...) ->
		unless @trigger[eventName]? then return false # pass it
		for waitter in @trigger[eventName]
			return false if waitter[eventName](args...) is false
		return true


	return gs

	
console.log '\n**test**'
gs = GameScene.createGameScene()
a = cards.tCard.clone()
b = cards.tCard.clone()
t = book.card('tCard')
gs.init([a,t], [b])
t.use(a)
console.log t.tags
#gs.disListen t, 'whenDie'
gs.init1()
t = gs.attacker.drawCard()
#gs.attacker.drawCard()
t.destroy()
gs.attacker.update()
console.log gs.trigger
#package
console.log 'load GameScene..'
root = exports ? window
root.GameScene = GameScene

#for cmd test
gsTest = {}
gsTest = GameScene.createGameScene()
gs.init([a,b],[])
p1 = gsTest.attacker
p2 = gsTest.defenser
root.gsTest = gsTest
root.p1 = p1
root.p2 = p2


