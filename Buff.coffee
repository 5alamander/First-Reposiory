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
		#if this[key]? then throw new Error 'the key has already exist'
		this[key] = (args...) ->
			unless @isSilence is false then return
			func.call this, args...

	decorate2: (object, key, func) ->
		unless object? then object = Buff
		#if object::[key]? then throw new Error 'the key has already exist'
		object::[key] = (args...) ->
			func.call this, args...


# handle
root = exports ? window
root.Buff = Buff


class Buff2 extends Buff

t = new Buff
f = ->console.log 'delete buff'
t.decorate2(Buff, 'delete', f)

d = new Buff2
f = ->console.log 'overrid delete buff'
d.decorate2(Buff2, 'delete', f)

t.delete()
d.delete()
