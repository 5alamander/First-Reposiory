class Buff
	this::cost = 0
	this::atk = 0
	this::maxHp = 0
	this::isSilence = false
	this::owner = {
		removeBuff:->console.log 'temp remove'
		gs:{listen:-> console.log 'temp listen', disListen:-> console.log 'temp disListen'}
		} #a default owner to test
	this::lifeTime = 1#default lifeTime is 1
	constructor: (initial) ->
		@turnCount = 0
		@tags = []
		for key, value of initial
			@tags.push key if key.indexOf('when') is 0 #create the tags by it's attribute
			@decorateBySilence key, value

	# the default interval is 1
	update: (n) ->
		@lifeTime -= n
		@turnCount += n
		unless @lifeTime > 0
			@owner.removeBuff this
			return
		unless @isSilence is false
			return
		if @cost and @owner.currentCost then @owner.currentCost += @cost
		if @atk and @owner.currentAtk then @owner.currentAtk += @atk
		if @maxHp and @owner.currentMaxHp then @owner.currentMaxHp += @maxHp
		@onUpdate?(n)

	# should be used by card
	activate: -> #add it to cetain tags in gs
		@owner.gs.listen this, tag for tag in @tags

	destroy: -> #disActivate the card from the gs
		@owner.gs.disListen this, tag for tag in @tags

	# higher order function? to decorate the func and add to this
	decorateBySilence: (key, func) ->
		if this[key]? then throw new Error 'the key has already exist'
		this[key] = (args...) ->
			unless @isSilence is false then return
			func.call this, args...

	decorate2: (key, func) ->
		if Buff::[key]? then throw new Error 'the key has already exist'
		Buff::[key] = (args...) ->
			console.log key + ' ' + [args...]


# handle
root = exports ? window
root.Buff = Buff

t = new Buff
	whenAdd: -> console.log 'when add'

s = new Buff

t.update(1)
console.log t.lifeTime

console.log s.lifeTime
console.log t

t.whenAdd(1,2,3)
t.isSilence = true
t.whenAdd(1)

t.decorate2('delete', ->)
s.decorate2('dle', ->)
s.delete('asd')
console.log t

a = (name) ->
	->
		console.log name

b = a('asdf')
c = a('csdf')

b()
c()