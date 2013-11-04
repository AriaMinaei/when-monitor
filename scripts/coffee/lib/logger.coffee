listeners = []

callListeners = (rejections) ->

	for listener in listeners

		listener rejections

	return

module.exports = (listener) ->

	listeners.push listener

	return (rejections) ->

		callListeners rejections