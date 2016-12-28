class Stack
	-- This goofy and weird hack works because the moonscript class implementation
	-- stores all instance methods in the metatable. The class itself is used as
	-- the stack's array-like table in order to remove yet another layer of
	-- hashtable indirection as well as to improve the syntactic sugar of using
	-- the stack by composition (allows ipairs iteration without using a
	-- metamethod).

	new: ( @containmentKey ) =>

	insert: ( element, index ) =>
		table.insert @, element, index
		element[@] = index or #@
		if @containmentKey
			element[@containmentKey] = true

	removeElementMetadata = ( element ) =>
		element[@] = nil
		if @containmentKey
			element[@containmentKey] = false

	reindex = ( start = 1 ) =>
		for i = start, #@
			element[@] = i

	removeByIndex = ( index ) =>
		table.remove @, index

	remove: ( element ) =>
		removeByIndex @, element[@]
		reindex @, element[@]
		removeElementMetadata @, element

	clear: =>
		-- not sure if allocating a new stack is slower than clearing the old one.
		-- My guess is yes, for low numbers of elements.
		-- @ = Stack!
		element = table.remove @
		while element
			removeElementMetadata @, element
			element = table.remove @

	-- This function mutates the table passed to it.
	removeSortedList: ( elementList ) =>
		for i = 1, #elementList - 1
			element = table.remove elementList
			table.remove @, element[@]
			removeElementMetadata @, element

		lastElement = table.remove elementList
		reindex @, lastElement[@]
		removeElementMetadata @, lastElement

	removeList: ( elementList ) =>
		table.sort elementList, ( a, b ) ->
			a[@] < b[@]

		@removeSortedList elementList