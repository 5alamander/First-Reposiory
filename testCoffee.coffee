Function::property = (prop, desc) ->
	Object.defineProperty @prototype, prop, desc

class gs
	this::name = 'a'
	constructor: () ->
		@a = 1
	test: () ->
		console.log 'this is an object'
	@property 'fullName',
		get: ->"#{@fisrtName}, #{@lastName}"
		set: (name) -> [@fisrtName, @lastName] = name.split ' '
	@property 'atk',
		get: ->
			console.log 'get atk'
			return @_atk
		set: (v) ->
			console.log 'set atk'
			@_atk = v
	console.log 'run'
	console.log this::name
	that = this
	that::['temp'] = 1

#gs = () ->
#	console.log 'gs function'

o = {id: 1}
a = [4,2,3,4, o, o]
b = [3,2,1]
e = []

remove = (list, a) ->
	list = (t for t in list when t isnt a)
	return list

Array::delete = (o) ->
	n = @indexOf o
	if n is -1 then return null
	@splice(n, 1)
	@delete(o)
	return this

a.delete 5
console.log a

checkTime = (cb) ->
	console.time('checkTime')
	cb() for i in [0..10000]
	console.timeEnd('checkTime')

# checkTime ->
# 	o = {id: 1}
# 	a = [4, 2, 3, 4, o]
# 	a.delete(o)

# checkTime ->
# 	o = {id: 1}
# 	a = [4, 2, 3, 4, o]
# 	a = (t for t in a when t isnt o)

# checkTime ->
# 	o = {id: 1}
# 	a = [4, 2, 3, 4, o]
# 	a.delete(4)

checkAtan = (x, y) ->
	console.log Math.atan2(x, y) / Math.PI * 180 | 0

