stdin = process.openStdin()
stdin.setEncoding 'utf8'

isInteger = (num) ->
	num is Math.round(num)

stdin.on 'data', (input) ->
	halves = input.split(',')
	nums = (parseInt(t) for t in halves)
	console.log 'your input is : ' + nums
	#check the input
	if nums.length < 4 # (player, source, aim[, selection[, location]])
		console.log 'need more arguments'
		return
	for index in nums
		if !isInteger(index)
			console.log 'plaese input numbers'
			return
	console.log 'check passed, send instruction to gs\n'
	sendInstruction(nums...)

###*
 * send
 * @param  {string}
 * @param  {[type|string]}
 * @param  {[type]}
 * @param  {[type]}
 * @param  {[type]}
 * @return {[type]}
###	
sendInstruction = (player, source, aim, selection = 0, location = 0) ->
	console.log player + ' ' + source + ' ' + aim + ' ' + selection

selectPlayer = (gs, n) ->
	if n = 0
		return gs.attacker
	else
		return gs.defenser

selectServant = (player, n) ->
	tarray = [player.heroList..., player.servantList]
	#select n

selectLocation = (player, n) ->
	tarray = player.servantList
	#insert

echo = (gs, n) ->
	

