describe "loopify", ->
	assert = require "assert"
	loopify = require "../src/index"
	it "Cancels loops", ->
		sum = 0
		p = loopify ->
			sum++
			if sum is 4
				p.cancel()
		p.then -> assert.equal sum, 4

	it "Respects rejection in actions", ->
		sum = 0
		expect = new Error "OK"
		actual = null
		loopify ->
			sum++
			if sum is 4
				throw expect
		.catch (err) -> actual = err
		.then -> assert.ok expect is actual

	it "Stops looping on throw null", ->
		sum = 0
		expect = new Error "OK"
		actual = null
		loopify ->
			sum++
			if sum is 4
				throw null
		.catch -> sum = -1
		.then -> assert.equal sum, 4

	it "Sleeps between loops", ->
		diff = []
		n = 0
		start = process.hrtime()
		loopify 10, ->
			diff.push[process.hrtime start]
			start = process.hrtime()
			n++
			if n > 5
				throw null
		.then ->
			diff.map (d) ->
				dt = diff[0] * 1e9 + diff[1]
				assert.ok dt >= 1e7
