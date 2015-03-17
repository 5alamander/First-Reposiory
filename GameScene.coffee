
#import
book = require './Card.coffee'
cards = book.cards
servants = book.servants
magics = book.magics
Buff = book.Buff

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

	collection_pick: ->
		t = remove(@collectionList, random(@collectionList.length))
		t.activate()
		return t

	servantList_remove: (card) ->
		#TODO

	#draw card from collection to hand
	drawCard: ->
		t = @collection_pick()
		@handList.push t
		t.onDraw?()# only some card
		#a tick
		@clear()
		@update()
		return t # for chain

	createCard: (cardName) ->
		t = book.card(cardName)
		t.activate()
		return t

	turnStart: ->
		#get turn energy
		energy += 1 if energy < 10
		currentEnergy = energy
		#a tick
		@clear()
		@update()

	turnEnd: ->
		@clear()
		@update(1)

	clear: ->
		t.clear() for t in @handList
		t.clear() for t in @servantList
		t.clear() for t in @heroList

	update: (n = 0) ->

		t.update(n) for t in @handList
		t.update(n) for t in @servantList
		t.update(n) for t in @heroList
	
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
	gs.dieList = []

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
		@init(c1, c2)

	# get a uid in this gameScene
	gs.registerCard = (card) ->
		@uids[@uidCount++] = card
		card.uid = @uidCount
		return card # for chain

	gs.addCard = (player, cardname) ->
		card = book.card(cardname)
		card.gs = this
		card.player = player
		@registerCard(card)

	# may not neccessary
	gs.addToDieList = (card) ->
		@dieList.push card

	gs.fresh = (n = 0) ->
		#clear die list
		#for dieList broadcast
		@broadcast('whenDie', card) for card in dieList

		@attacker.clear()
		@attacker.update(n)
		@defenser.clear()
		@defenser.update(n)

	gs.trigger = {}# be used by listen and broadcast

	gs.listen = (waitter, eventName) ->
		unless @trigger[eventName]? then @trigger[eventName] = []
		@trigger[eventName].push waitter

	gs.disListen = (waitter, eventName) ->
		if @trigger[eventName]?
			@trigger[eventName] = (card for card in @trigger[eventName] when card isnt waitter)

	gs.broadcast = (eventName, args...) ->
		unless @trigger[eventName]? then return false # pass it
		for waitter in @trigger[eventName]
			return false if waitter[eventName](args...) is false
		return true


	return gs

	
console.log '\n**test**'
gs = GameScene.createGameScene()

gs.init1()
t = gs.attacker.drawCard()
gs.attacker.update()

b = new Buff
	name:'tbuff'
	atk:1
	maxHp:2
	whenDraw:->
		console.log 'draw'
t.addBuff b
console.log gs.trigger



#package
console.log 'load GameScene..'
root = exports ? window
root.GameScene = GameScene

#for cmd test
###
gsTest = {}
gsTest = GameScene.createGameScene()
gsTest.init1()
p1 = gsTest.attacker
p2 = gsTest.defenser
root.gsTest = gsTest
root.p1 = p1
root.p2 = p2
###


