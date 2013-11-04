UnhandledRejectionErrorWrapper = require './UnhandledRejectionErrorWrapper'

module.exports = (filterStack) ->

	formatStackJumps = (rec) ->

		jumps = []

		rec = rec.parent

		while (rec)

			jumps.push(formatStackJump(rec))

			rec = rec.parent

		return jumps


	formatStackJump = (rec) ->

		return filterStack(toArray(rec.createdAt.stack).slice(1))

	toArray = (stack) ->

		return if stack then stack.split('\n') else []

	return (rec) ->

		cause = rec.reason and rec.reason.stack

		if !cause

			cause = rec.rejectedAt and rec.rejectedAt.stack

		jumps = formatStackJumps(rec)

		reason = rec.reason

		escapedAt = rec.createdAt.stack

		formatted = new UnhandledRejectionErrorWrapper reason, escapedAt, jumps

		return formatted