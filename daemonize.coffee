module.exports = loopify = ([condition, sleep]..., action) ->
	unless "function" is typeof condition
		sleep ?= +condition
		condition = -> yes
	unless "function" is typeof action
		throw new TypeError "Invalid callback"

	sleep = +sleep
	handle = null
	start = -Infinity
	promise = new Promise (resolve, reject) ->
		_loop = ->
			return resolve() unless condition()
			try
				p = Promise.resolve action()
			catch err
				return reject err
			p.then ->
				now = new Date().getTime()
				timeout = start + sleep - now
				start = now
				handle = setTimeout _loop, if timeout > 0 then timeout else 0
			p.catch (err) -> reject err
		promise.cancellable()
		_cancel = promise.cancel
		promise.cancel = ->
			condition = -> no
			clearTimeout handle
			_cancel.call promise
		do _loop
