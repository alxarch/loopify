module.exports = loopify = ([sleep]..., action) ->
	unless "function" is typeof action
		throw new TypeError "Invalid callback"

	sleep = +sleep
	sleep = 0 unless sleep > 0
	handle = null
	stop = no
	promise = new Promise (resolve, reject) ->
		_loop = ->
			return resolve() if stop
			try
				p = Promise.resolve action()
			catch err
				return if err? then reject(err) else resolve()
			p.then -> handle = setTimeout _loop, sleep
			p.catch (err) -> reject err
		do _loop
	promise.cancel = ->
		stop = yes
		clearTimeout handle
	promise
