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
	end

	def handle_input(input)
		case input
		when /^look$/
			@current_scene.look
		when /^quit$/
			# save game
			exit
		end

		Readline::HISTORY.pop if Readline::HISTORY.to_a[-1].to_s.match(/^\s*$/)
	end

end
