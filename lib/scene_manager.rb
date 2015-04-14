class SceneManager < SavableObject

	attr_reader :scenes, :items

	def initialize(delegate)
		super({ delegate: delegate })
	end

	def marshal_dump
		super.merge({ scenes: @scenes, items: @items })
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		super
		@scenes = data[:scenes] || {}
		@items = data[:items] || {}
		setup_scenes
	end

	def setup_scenes

		# ITEMS:

		add_item(:coconut, {}, { name: "coconut", article: "a",
			description: "Hm, this coconut must have fallen off a tree.\nOr perhaps a swallow brought it here..."
		})

		add_item(:rope, {}, { name: "rope",
			description: "This rope is pretty sturdy. Perfect for life lines.",
			block: -> (this) {
				# `this` is the rope
				if this.delegate.current_scene.key == :west_deck
					this.delegate.player.inventory.delete(this)
					this.delegate.teleport(:shore, "Insert message here.")
				else
					puts "There is nothing to tie a rope to here."
				end
			}
		}, Rope)

		add_item(:rusty_key, {}, { name: "rusty key", alt_names: ["key"], article: "a",
			description: "This key is pretty old, so the lock it belongs\nto is probably in the same condition."
		})

		add_item(:wooden_sword, {}, { name: "wooden sword", alt_names: ["sword"], article: "a",
			description: "A cheap wooden sword, but it gets the job done!",
			cost: 10
		})

		# SCENES:

		add_scene(:below_deck, {}, { name: "Below Deck",
			# insert something like "you wake up from a horrible nightmare"
			description: "The roar of the creaking boards and the waves crashing\nagainst the side of the hull is deafening. You hear\npeople rushing around on the deck overhead."
		})

		add_scene(:main_deck, {}, { name: "Main Deck",
			description: "Crew members are sprinting around doing various things\nin a effort to keeep the ship afloat. The Captain\nshouts at you, \"Dont just stand there, maggot! Fetch some\nline from the nest to tie off the life lines! GO!\"\nThere are pegs to tie the life lines on the western\nside of the ship. The crows nest is above."
		})

		add_scene(:west_deck, {}, { name: "Port Side",
			description: "As you struggle to see through the mist thrown about\nby the massive waves impacting the hull, you can make\nout the pegs for tying the life lines attached to the ships\nrailing. The main deck is back to the east."
		})

		add_scene(:crows_nest, { items: ObjectManager.new([
				@items[:rope]
			])
		}, { name: "Crows Nest",
			description: "You can barely stand as the crows nest swings about\nlike a balloon in the air. As you grip the rail,\nyou can make out an increibly faint shore line.\nYour facination is quickly interupted by a sudden lurch of the ship.\nYou remember why you're there."
		})	

		add_scene(:shore, {}, { name: "Island Shore",
			# add some sort of "you wake up" before this
			description: "You are on the shore of a small, gloomy island.\nThe ocean is eerily calm, causing a thick silence\nto coat the shore. The beach continues east.\nThere is a large jungle to the north."
		})

		add_scene(:shore_east, {}, { name: "Eastern Island Shore",
			description: "The shore continues to stretch northeast,\nbut it also goes back to the west."
		})

		add_scene(:shore_shack, {}, { name: "North East Shore",
			description: "The shore is cut off here by rocks. There is an old and\nrun down shack here, and it has a rusty padlock\nholding the door shut. The beach goes back southwest."
		})

		add_scene(:jungle_entrance, { items: ObjectManager.new([
				@items[:coconut]
			])
		}, { name: "Jungle Entrance",
			description: "The trees are very tall here, and few of the suns rays\nare able to penetrate the thick canopy of leaves.\nThe beach is back to the south. The jungle continues north."
		})

		add_scene(:north_jungle, {}, { name: "Northern Jungle",
			description: "The trees continue to grow thicker as you enter the jungle.\nThe jungle continues north, northeast, east, and west.\nThe beach is back south."
		})

		add_scene(:jungle_ne, {}, { name: "Jungle Pond",
			# you should be able to fish here
			description: "There is a small, clear pond surrended by tall, magnificent\nbanyan trees. There are also a few flowers growing near by.\nYou can go southwest."
		})

		add_scene(:jungle_east, { items: ObjectManager.new([
				@items[:rusty_key]
			])
		}, { name: "Eastern Jungle",
			description: "The jungle continues to fan out around you, but the\ntrees are too thick for you to go any further. The\njungle center is back west."
		})

		add_scene(:jungle_far_north, {}, { name: "Far North Jungle",
			description: "The jungle continues on north, and you can see a concrete\nstructure in the distance. The jungle continues south."
		})

		add_scene(:jungle_west, {}, { name: "Western Jungle",
			# eh?
			# also, should there be a comma here?           ↓
			# todo: add a path to the west
			description: "The forest is getting denser and darker; it is getting\nharder to see things, but you notice a small path going west."
		})

		add_scene(:jungle_path, {}, { name: "Jungle Path",
			description: "You are on a pathway made from cleared branches and plants.\nThe path continues northwest, and it ends to the east."
		})

		add_scene(:jungle_path_west, {}, { name: "Jungle Path",
			description: "Strange... It sounds like there's music coming from somewhere.\nThe path goes on northwest and southeast."
		})

		add_scene(:almost_village, {}, { name: "Jungle Path",
			description: "There is a joyful village over west with loud music\ncoming from it. The path returns southeast."
		})

		add_scene(:village, {}, { name: "Village Center",
			# add more here
			# make this a haiku, idk maybe not
			description: "You are in the middle of a village, and there are\npeople singing and dancing all around. There is a\nblacksmith to the northeast, a small hut to the west,\nand a path leading into the forest to the east."
		})

		add_scene(:blacksmith, {
			inventory: ObjectManager.new([
				@items[:wooden_sword]
			])
		}, { name: "Blacksmith",
			description: "Wow, there are some excellent weapons and tools here."
		}, Shop)

		add_scene(:small_hut, {}, { name: "Small Hut",
			# add a person here that says to get out
			description: "What a cozy home, it's nice in here. The exit is east."
		})

		# boat:
		@scenes[:main_deck].paths = { d: @scenes[:below_deck], u: @scenes[:crows_nest], w: @scenes[:west_deck] }
		@scenes[:below_deck].paths = { u: @scenes[:main_deck] }
		@scenes[:crows_nest].paths = { d: @scenes[:main_deck] }
		@scenes[:west_deck].paths = { e: @scenes[:main_deck] }

		# island:
			# shore:
		@scenes[:shore].paths = { n: @scenes[:jungle_entrance], e: @scenes[:shore_east] }
		@scenes[:shore_east].paths = { w: @scenes[:shore], ne: @scenes[:shore_shack] }
		@scenes[:shore_shack].paths = { sw: @scenes[:shore_east] }
			# jungle:
		@scenes[:jungle_entrance].paths = { s: @scenes[:shore], n: @scenes[:north_jungle] }
		@scenes[:north_jungle].paths = { e: @scenes[:jungle_east], n: @scenes[:jungle_far_north], w: @scenes[:jungle_west], ne: @scenes[:jungle_ne], s: @scenes[:jungle_entrance]}
		@scenes[:jungle_ne].paths = { sw: @scenes[:north_jungle] }
		@scenes[:jungle_east].paths = { w: @scenes[:north_jungle] }
		@scenes[:jungle_far_north].paths = { s: @scenes[:north_jungle] }
		@scenes[:jungle_west].paths = { e: @scenes[:north_jungle], w: @scenes[:jungle_path] }
		@scenes[:jungle_path].paths = { e: @scenes[:jungle_west], nw: @scenes[:jungle_path_west] }
		@scenes[:jungle_path_west].paths = { se: @scenes[:jungle_path], nw: @scenes[:almost_village] }
		@scenes[:almost_village].paths = { w: @scenes[:village], se: @scenes[:jungle_path_west] }
				# village:
		@scenes[:village].paths = { e: @scenes[:almost_village], ne: @scenes[:blacksmith], w: @scenes[:small_hut] }
		@scenes[:small_hut].paths = { e: @scenes[:village] }
		@scenes[:blacksmith].paths = { sw: @scenes[:village] }
	end

	def add_scene(key, saved_data, unsaved_data, klass = Scene)
		@scenes[key] ||= klass.new({ delegate: @delegate }.merge(saved_data))
		@scenes[key].load_unsaved_data({ key: key }.merge(unsaved_data))
	end

	def add_item(key, saved_data, unsaved_data, klass = Item)
		@items[key] ||= klass.new({ delegate: @delegate }.merge(saved_data))
		@items[key].load_unsaved_data({ key: key }.merge(unsaved_data))
	end

	def [](id)
		@scenes[id]
	end

end