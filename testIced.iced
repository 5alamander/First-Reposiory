console.log 'iced'

class A
	constructor: (aim) ->
		aim = aim
		console.log 'init a'

new A()

for i in [0..10]
  await 
    setTimeout defer(), 1000
    setTimeout defer(), 10
  console.log ("hello");