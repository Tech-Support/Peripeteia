class Controller

	def initialize
		setup({})
	end

	def marshal_dump
		{ player: @player, scene_manager: @scene_manager, current_scene: @current_scene }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@player = data[:player] || Player.new({ delegate: self })
		@scene_manager = data[:scene_manager] || SceneManager.new(self)
		@current_scene = data[:current_scene] || @scene_manager[:start]

		@current_scene.enter
	end

	def handle_input(input)

		directions = "n|north|e|east|s|south|w|west|ne|north ?east|se|south ?east|sw|south ?west|nw|north ?west|u|up|d|down"

		case input
		when /^((go|walk) )?(?<direction>#{directions})$/
			walk(symbol_for_direction($~[:direction]))
		when /^look$/
			@current_scene.look
		when /^quit$/
			# save game
			exit
		end

		Readline::HISTORY.pop if Readline::HISTORY.to_a[-1].to_s.match(/^\s*$/)
	end

	def walk(direction)
		if new_scene = @current_scene[direction]
			@current_scene = new_scene
			new_scene.enter
		else
			puts "You can't go that way"
		end
	end

end
