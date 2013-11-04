module.exports = class UnhandledRejectionErrorWrapper extends Error

	self = @

	constructor: (@reason, @escapedAt, @jumps) ->

		ref = @reason or null

		@title = 'UnhandledRejectionError'

		if ref.message?

			@message = String(ref.message)

		else

			@message = 'Unhandled rejection with reason: ' + String @reason

		# Too dirty. I'll come back to that.
		if typeof ref is 'object'

			for prop in Object.getOwnPropertyNames ref

				continue if @[prop]?

				@[prop] = ref[prop]

		unless @stack?

			@stack = ''

		do @_fixStack

		do @_complimentStack

		return

	@_escapedStackLineRx: ///
		^\s+at\s
	///

	@_escapedStackLinePathRx: ///
		\(([^\)]+)\)$
	///

	@_escapedStackLineToSkipRx: ///
		node_modules[\\\/]{1}when[\\\/]{1}
	///

	@_escapedStackLineToAppendRx: ///
		^
		(\s+ at\s)
		([^\(\)]+)
		$
	///

	_fixStack: ->

		return if @stack is ''

		@stack = @stack
		.split("\n")
		.filter (l) ->

			return no if l.match self._escapedStackLineToSkipRx

			return yes

		.join("\n")

		return

	_complimentStack: ->

		return unless typeof @escapedAt is 'string'

		lines = @escapedAt.split "\n"

		toAppend = ''

		for line in lines

			continue unless line.match self._escapedStackLineRx

			continue if line.match self._escapedStackLineToSkipRx

			if m = line.match self._escapedStackLineToAppendRx

				toAppend += '\n' + m[1] + "(#{m[2]})"

			else

				toAppend += '\n' + line

		if toAppend.length > 0

			@stack += '\nRejection escaped at:' + toAppend

		return

