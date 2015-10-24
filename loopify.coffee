module.exports = loopify = ([sleep]..., action) ->
	unless "function" is typeof action
		throw new TypeError "Invalid callback"

	sleep = +sleep
	handle = null
	start = -Infinity
	stop = no
	promise = new Promise (resolve, reject) ->
		_loop = ->
			return resolve() if stop
			try
				p = Promise.resolve action()
			catch err
				return if err? then reject(err) else resolve()
			p.then ->
				if sleep > 0
					now = new Date().getTime()
					timeout = start + sleep - now
					start = now
					handle = setTimeout _loop, if timeout > 0 then timeout else 0
				else
					handle = setTimeout _loop, 0
			p.catch (err) -> reject err
		do _loop
	promise.cancel = ->
		stop = yes
		clearTimeout handle
	promise
