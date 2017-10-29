class SystemTime extends UIElement

	offscreenPosition = settings['system-time-offscreen-pos']
	topMargin = settings['system-time-top-margin']
	timeFormat = settings['system-time-format']

	new: =>
		super!

		@line = {
			[[{\pos(]]
			[[-100,0]]
			[[)\an9%s%s}]]\format settings['default-style'], settings['system-time-style']
			[[????]]
		}
		@lastTime = -1
		@position = offscreenPosition
		@animation = Animation offscreenPosition, settings['system-time-right-margin'], @animationDuration, @\animate, nil, 0.5

	reconfigure: =>
		super!
		offscreenPosition = settings['system-time-offscreen-pos']
		topMargin = settings['system-time-top-margin']
		timeFormat = settings['system-time-format']

		@line[2] = ('%g,%g')\format @position, topMargin
		@line[3] = [[)\an9%s%s}]]\format settings['default-style'], settings['system-time-style']
		@animation = Animation offscreenPosition, settings['system-time-right-margin'], @animationDuration, @\animate, nil, 0.5


	resize: =>
		@position = Window.w - @animation.value
		@line[2] = ('%g,%g')\format @position, topMargin

	animate: ( value ) =>
		@position = Window.w - value
		@line[2] = ('%g,%g')\format @position, topMargin
		@needsUpdate = true

	redraw: =>
		if @active
			systemTime = os.time!
			timeRemaining = math.floor mp.get_property_number 'playtime-remaining', 0
			finishTime = systemTime + timeRemaining
			time_format = "%H:%M"
			if systemTime != @lastTime
				update = true
				@line[4] = ([[%s - %s]])\format os.date(time_format, systemTime), os.date(time_format, finishTime)
				@lastTime = systemTime
				@needsUpdate = true

		return @needsUpdate
