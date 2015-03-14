EventEmitter = require('events').EventEmitter
trigger = new EventEmitter()

f1 = -> console.log 'f1'
f2 = -> console.log 'f2'

trigger.on('die', ->
	console.log 'sysout die')
.on 'die', (n...) ->
	console.log 'die ' + n[1]
	console.log 'die ' + n[0]
.once 'die', ->
	console.log 'only once'
.on 'f', f1
.on 'f', f2
.on 'f', f2
.on 'f', f2
.on 'f', f2
.on 'f1', f2
.on 'f1', f2
.on 'f1', f2
.on 'f1', f2
.on 'f1', f2
.on 'f1', f2


trigger.emit('die', 1, 3)
trigger.emit('die', 1, 3)

trigger.emit('f')
trigger.removeListener('f', f2)
trigger.emit('f')



a = {
	name: 'wo shi a'
	skill: ->
		console.log @name
	skill2: ->
		console.log @nickName
}

b =
	nickName: 'wo shi b'
	nickName2 : 'wo shi b 2'

a.skill()
a.skill2()
console.log b
console.log
	a: 1
	b: 2
	c: 3
	d : 'asdf'
	e :'asdf'



class c
	this::name = 'card'
	#this::tags = []
	constructor: (initial) ->
		@tags = []
		for key, value of initial
			@tags.push key if key.indexOf('when') is 0
			this[key] = value
	fu: ->
		console.log 'function is nopro'

t = new c
	whenA:'a'
	whenB: 'c'

t = new c
	printName: ->
		console.log @name
	tName: 't name', whenUse: 't'
	whenAttack: 'd'
	fu: ->
		console.log 'kill the onwer'

console.log t
t.printName()
t.fu()
console.log t.tags

class d
	@name:'d'
	constructor: ->

console.log new d()

key = 'awhen'
console.log key.indexOf('when')

a = (i1, i2, initial, t = 1) ->
	console.log t
	console.log initial

a 1, 2, {
	a:1
	b:3
}, 4


d = ->
	console.log 'aa'
	console.log 'bb' 
d() unless false

#console.log key + ' ' + value for key, value of trigger
eval("console.log ('asdf')")

console.log 'bind'
d = {name : 'd'}
d.recall = (closure) ->
	closure()

d.recall(closure = =>console.log this.name)