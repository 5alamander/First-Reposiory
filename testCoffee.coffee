class gs
	constructor: () ->
		@a = 1
	test: () ->
		
		console.log 'this is an object'

#gs = () ->
#	console.log 'gs function'

gs.test = (str) ->
	console.log 'I am a function'

gs.test()
gs()


class t extends gs
	constructor: () ->

class d extends t
	constructor: () ->


a = 1<<2
console.log a

