
class Buff
	this::cost = 0
	this::atk = 0
	this::maxHp = 0
	this::owner = {
		removeBuff:->console.log 'temp remove'
		gs:{listen:-> console.log 'temp listen', disListen:-> console.log 'temp disListen'}
		} #a default owner to test
	this::lifeTime = 1#default lifeTime is 1
	constructor: (initial) ->
		@tags = []
		for key, value of initial
			@tags.push key if key.indexOf('when') is 0 #create the tags by it's attribute
			this[key] = value

	# the default interval is 1
	update: (n = 0) ->
		@lifeTime -= n
		unless @lifeTime
			@owner.removeBuff this
			return
		if @cost and @owner.currentCost then @owner.currentCost += @cost
		if @atk and @owner.currentAtk then @owner.currentAtk += @atk
		if @maxHp and @owner.currentMaxHp then @owner.currentMaxHp += @maxHp
		@onUpdate?(n)

	activate: -> #add it to cetain tags in gs
		@owner.gs.listen this, tag for tag in @tags

	destroy: -> #disActivate the card from the gs
		@owner.gs.disListen this, tag for tag in @tags

t = new Buff

s = new Buff

t.update(1)
console.log t.lifeTime

console.log s.lifeTime
console.log t