module.exports = daemonize = (sleep, callback) ->
		unless "function" is typeof callback
			throw new TypeError "Invalid callback"

		stop = no
		id = null
		cycle = ->
			return if stop
			start = new Date().getTime()
			p = do ->
				try
					Promise.resolve callback()
				catch e
					Promise.reject e
			next = (err) ->
				if err
					console.error err.stack
				return if stop
				t = Math.max 0, start + sleep - new Date().getTime()
				id = setTimeout cycle, t

			p.then (-> next()), (err) -> next err

		cancel = ->
			stop = yes
			clearTimeout id
		id = setTimeout cycle, 0
		cancel