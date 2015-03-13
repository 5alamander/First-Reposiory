
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
		t = remove(@collectionList, random(@collectionList.length))
		@handList.push t
		t.onDraw?()# only some card

	turnStart: ->
		#get turn energy
		energy += 1 if energy < 10
		currentEnergy = energy

	turnEnd: ->
	
	useCard: (handN, aimN) ->
		#select card by handN
		#check cost
		#card.use(aimN)

	toString: ->
		


GameScene = {}
GameScene.createGameScene = ->
	gs = {}
	gs.attacker = new Player('attacker', gs)
	gs.defenser = new Player('defenser', gs)
	gs.attacker.enemy = gs.defenser # set alignment
	gs.defenser.enemy = gs.attacker
	gs.turn = 0
	gs.activePlayer = 0 # 0:attacker, 1:defender

	#init
	gs.init = (attackerCollection, defenserCollection) -> 
		@attacker.collectionList = attackerCollection
		@defenser.collectionList = defenserCollection
		#to bind all in collection
		for card in @attacker.collectionList
			card.gs = this
			card.player = @attacker
		for card in @defenser.collectionList
			card.gs = this
			card.player = @defenser
	
	gs.gameStart = ->

	gs.trigger = {}# be used by listen and broadcast

	gs.listen = (waiter, eventName) ->
		#if @trigger[eventName]? is false
		#	@trigger[eventName] = []
		@trigger[eventName] = [] unless @trigger[eventName]?
		@trigger[eventName].push waiter

	gs.broadcast = (eventName, args...) ->
		if @trigger[eventName]? is false then return false # pass it
		for waiter in @trigger[eventName]
			return false if waiter[eventName](args...) is false
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
t.startListen()
gs.broadcast('whenDie', a)
gs.broadcast('whenCall', a)
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


