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

a = [4,2,3,4]
b = [3,2,1]
e = []
remove = (list, a) ->
	list = (t for t in list when t isnt a)
	return list

list = remove(e, 0)
console.log e[0]