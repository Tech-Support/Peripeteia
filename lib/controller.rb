class Controller < SavableObject

	attr_accessor :save_file, :scene_manager, :player, :current_scene

	def initialize(save_file, opts = {})
		@save_file = save_file
		super(opts)
	end

	def marshal_dump
		super.merge({ player: @player, scene_manager: @scene_manager, current_scene: @current_scene })
	end

	def setup(data)
		super
		@player = data[:player] || Player.new({ delegate: self })
		@scene_manager = data[:scene_manager] || SceneManager.new(self)
		@current_scene = data[:current_scene] || @scene_manager[:below_deck]

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
		when /^look( at)?( (?<thing>[A-Za-z0-9 ]+))?$/
			if thing = $~[:thing]
				look_at(thing)
			else
				puts "Look at what?"
			end
		when /^inspect( (?<thing>[A-Za-z0-9 ]+))?$/
			if thing = $~[:thing]
				look_at(thing)
			else
				puts "Inspect what?"
			end
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
		when /^i(nfo)?$/
			@player.print_info
			print_info
		when /^\?|help$/
			print_help
		when /^(buy|purchase)( (?<item_name>[A-Za-z0-9_]+))?$/
			item_name = $~[:item_name]
			if @current_scene.is_a?(Shop)
				@current_scene.buy(item_name)
			else
				puts "You can't buy things here."
			end
		when /^tie rope( to pegs?)?$/
			if rope = @player.inventory["rope"]
				rope.tie
			else
				puts "You have no rope"
			end
		when /^\s*$/
		else
			if $developer_mode
				case input
				when /^teleport( (?<room_name>[A-Za-z0-9_]+))?$/
					teleport($~[:room_name])
				when /^receive( (?<item_name>[A-Za-z0-9_]+))?$/
					if item_name = $~[:item_name]
						if item = @scene_manager.items[item_name.to_sym]
							@player.give_item(item)
						else
							puts "That item doesn't exist."
						end
					else
						puts "Usage: receive [item key]"
					end
				when /^>>( (?<code>.+))?$/
					if code = $~[:code]
						eval(code)
					else
						puts "Usage: >> [Ruby code]"
					end
				else
					puts "What?"
				end
			else
				puts "What?"
			end
		end

		Readline::HISTORY.pop if Readline::HISTORY.to_a[-1].to_s.match(/^\s*$/)
	end

	def print_info
		if $developer_mode
			puts "Developer Mode:".magenta
			puts "Save File: #@save_file"
		end
	end

	def teleport(key, message = nil)
		if key != nil && scene = @scene_manager[key.to_sym]
			@current_scene = scene
			puts message if message
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

	def look_at(thing)
		if item = @current_scene.items[thing]
			item.inspect
		elsif item = @player.inventory[thing]
			item.inspect
		else
			puts "That isn't here"
		end
	end

	def take(thing)
		if item = @current_scene.items[thing]
			@current_scene.items.delete(item)
			@player.give_item(item)
		else
			puts "That isn't here."
		end
	end

	def save
		if @save_file
			data = Marshal.dump(self)
			f = File.open(@save_file, "w")
			f.write(data)
			f.close
		end
	end

	def print_help
		puts "Welcome to Peripéteia!"
		puts
		puts "You will have to figure out many of the commands your self,"
		puts "but here are some to help you out:"
		puts "north, east, south, west, northeast, southeast... and so on."
		puts "You can also abbreviate them as n, e, w, s, ne, se..."
		puts
		puts "Also the info command is very helpful, it lets you see your"
		puts "health among other usefull things."
		puts
		puts "Good luck!"
	end

end
