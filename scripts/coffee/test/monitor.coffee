require './_prepare'

caught = []

mod('monitor').start 1, (rejections) ->

	caught.push rejections

	return

UnhandledRejectionErrorWrapper = mod 'UnhandledRejectionErrorWrapper'

wn = require 'when'

describe "monitor"

it "should work (more or less)", ->

	wn().then -> throw Error "a"

	after 50, ->

		caught.length.should.equal 1

		firstList = caught[0]

		firstList.should.be.an 'array'
		firstList.length.should.equal 1

		rejection = firstList[0]

		rejection.should.be.instanceOf UnhandledRejectionErrorWrapper

		rejection.should.have.deep.property 'reason.message', 'a'

		return