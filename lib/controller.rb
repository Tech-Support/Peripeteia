class Controller < SavableObject

	def marshal_dump
		super.merge({ player: @player, scene_manager: @scene_manager, current_scene: @current_scene })
	end

	def setup(data)
		super
		@player = data[:player] || Player.new({ delegate: self })
		@scene_manager = data[:scene_manager] || SceneManager.new(self)
		@current_scene = data[:current_scene] || @scene_manager[:below_deck]
		
		@current_scene = @scene_manager[:shore]

		@current_scene.enter
	end

	def handle_input(input)

		directions = "n|north|e|east|s|south|w|west|ne|north ?east|se|south ?east|sw|south ?west|nw|north ?west|u|up|d|down"

		case input
		when /^((go|walk) )?(?<direction>#{directions})$/
			walk(symbol_for_direction($~[:direction]))

		# todo: allow look to also be used for items
		when /^look$/
			@current_scene.look
		when /^inspect( (?<thing>[A-Za-z0-9 ]+))?$/
			_inspect($~[:thing])
		when /^inv(entory)?$/
			@player.look_in_inventory
		when /^(?<word>get|take|grab)( (?<thing>[A-Za-z0-9 ]+))?$/
			if thing = $~[:thing]
				take(thing)
			else
				puts "#{$~[:word].capitalize} what?"
			end
		when /^quit|exit$/
			save
			exit
		when /^\s*$/
		else
			if $developer_mode
				case input
				when /^teleport( (?<room_name>[A-Za-z0-9_]+))?$/
					teleport($~[:room_name])
				else
					puts "What?"
				end
			else
				puts "What?"
			end
		end

		Readline::HISTORY.pop if Readline::HISTORY.to_a[-1].to_s.match(/^\s*$/)
	end

	def teleport(key)
		if key != nil && scene = @scene_manager[key.to_sym]
			@current_scene = scene
			@current_scene.enter
		else
			puts "Error: no room with the key \"#{key}\" "
		end
	end

	def walk(direction)
		if new_scene = @current_scene[direction]
			@current_scene = new_scene
			new_scene.enter
		else
			puts "You can't go that way."
		end
	end

	def _inspect(thing)
		if !thing
			puts "Inspect what?"
		elsif item = @current_scene.items[thing]
			item.inspect
		elsif item = @player.inventory[thing]
			item.inspect
		else
			puts "That isn't here"
		end
	end

	def take(thing)
		if item = @current_scene.items[thing]
			@current_scene.remove_item(item)
			@player.give_item(item)
		else
			puts "That isn't here."
		end
	end

	def save
		data = Marshal.dump(self)
		f = File.open(SAVE_FILE, "w")
		f.write(data)
		f.close
	end

end
