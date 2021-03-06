module.exports.start = (interval, cb) ->

	createAggregator = require './aggregator'
	throttleReporter = require './throttledReporter'
	simpleReporter = require './reporter'
	formatter = require './formatter'
	stackFilter = require './stackFilter'
	logger = require('./logger')(cb)

	mergePromiseFrames = ->

		filteredFramesMsg

	exclude = (line) ->

		rx = attachPoint.promiseStackFilter or excludeRx

		return rx.test(line)

	filteredFramesMsg = '  ...[filtered frames]...'

	excludeRx = /when\.js|when\/monitor\//i
	filter = stackFilter(exclude, mergePromiseFrames)
	reporter = simpleReporter(formatter(filter), logger)

	aggregator = createAggregator(throttleReporter(parseInt(interval) or 250, reporter))

	attachPoint = if (typeof console isnt 'undefined') then aggregator.publish(console) else aggregator

	return