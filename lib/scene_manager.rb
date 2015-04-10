class SceneManager < SavableObject

	attr_accessor :scenes

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

		@items[:coconut] ||= Item.new({ delegate: @delegate })
		@items[:coconut].load_unsaved_data({ name: "coconut",
			description: "Hm, this coconut must have fallen off a tree.\nOr perhaps a swallow brought it here...", article: "a"
		})

		@items[:rope] ||= Rope.new ({ delegate: @delegate })
		@items[:rope].load_unsaved_data({ name: "rope",
			description: "This rope is pretty sturdy. Perfect for life lines."
		})

		@items[:rusty_key] ||= Item.new ({ delegate: @delegate })
		@items[:rusty_key].load_unsaved_data({ name: "rusty key",
			description: "This key is pretty old, so the lock it belongs\nto is probably in the same condition.",
			alt_names: ["key"]
		})

		# SCENES:

		@scenes[:below_deck] ||= Scene.new({ delegate: @delegate})
		@scenes[:below_deck].load_unsaved_data({ name: "Below Deck",
			# insert something like "you wake up from a horrible nightmare"
			description: "The roar of the creaking boards and the waves crashing\nagainst the side of the hull is deafening. You hear\npeople rushing around on the deck overhead."
		}) 

		@scenes[:main_deck] ||= Scene.new({ delegate: @delegate})
		@scenes[:main_deck].load_unsaved_data({ name: "Main Deck",
			description: "Crew members are sprinting around doing various things\nin a effort to keeep the ship afloat. The Captain\nshouts at you, \"Dont just stand there, maggot! Fetch some\nline from the nest to tie off the life lines! GO!\"\nThere are pegs to tie the life lines on the western\nside of the ship. The crows nest is above."
		})

		@scenes[:west_deck] ||= Scene.new({ delegate: @delegate})
		@scenes[:west_deck].load_unsaved_data({ name: "Port Side",
			description: "As you struggle to see through the mist thrown about\nby the massive waves impacting the hull, you can make\nout the pegs for tying the life lines attached to the ships\nrailing. The main deck is back to the east."
		})

		@scenes[:crows_nest] ||= Scene.new({ delegate: @delegate,
			items: ObjectManager.new([
				@items[:rope]
			])
		})
		@scenes[:crows_nest] ||= Scene.new({ delegate: @delegate})
		@scenes[:crows_nest].load_unsaved_data({ name: "Crows Nest",
			description: "You can barely stand as the crows nest swings about\nlike a balloon in the air. As you grip the rail,\nyou can make out an increibly faint shore line.\nYour facination is quickly interupted by a sudden lurch of the ship.\nYou remember why you're there."
		})	

		@scenes[:shore] ||= Scene.new({ delegate: @delegate})
		@scenes[:shore].load_unsaved_data({ name: "Island Shore",
			# add some sort of "you wake up" before this
			description: "You are on the shore of a small, gloomy island.\nThe ocean is eerily calm, causing a thick silence\nto coat the shore. The beach continues east.\nThere is a large jungle to the north."
		})

		@scenes[:shore_east] ||= Scene.new({ delegate: @delegate })
		@scenes[:shore_east].load_unsaved_data({ name: "Eastern Island Shore",
			description: "The shore continues to stretch to the north east, but also goes back to the west."
		})

		@scenes[:shore_shack] ||= Scene.new({ delegate: @delegate })
		@scenes[:shore_shack].load_unsaved_data({ name: "North East Shore",
			description: "The shore is cut off here by rocks. There is an old and\nrun down shack here, and it has a rusty padlock\nholding the door shut. The beach goes back to the\nsouthwest."
		})

		@scenes[:jungle_entrance] ||= Scene.new({ delegate: @delegate,
			items: ObjectManager.new([
				@items[:coconut]
			])
		})
		@scenes[:jungle_entrance].load_unsaved_data({ name: "Jungle Entrance",
			description: "The trees are very tall here, and few of the suns\nrays are able to penetrate the thick canopy of leaves.\nThe beach is back to the south. The jungle continues\nnorth."
		})

		@scenes[:jungle_main] ||= Scene.new({ delegate: @delegate, })
		@scenes[:jungle_main].load_unsaved_data({ name: "Central Jungle",
			description: "The trees continue to grow thicker as you enter the\nheart of the jungle. The Jungle continues to the East,\nNorth, West and Northeast. The beach is back to the\nsouth."
		})

		@scenes[:jungle_east] ||= Scene.new({ delegate: @delegate, 
			items: ObjectManager.new([
				@items[:rusty_key]
			])	
		})
		@scenes[:jungle_east].load_unsaved_data({ name: "Eastern Jungle",
			description: "The jungle continues to fan out around you, but the\ntrees are too thick for you to go any further. The\njungle center is back to the west."
		})
		
		@scenes[:jungle_north] ||= Scene.new({ delegate: @delegate, })
		@scenes[:jungle_north].load_unsaved_data({ name: "Northern Jungle",
			description: "The jungle continues on to the north, and you can see\na concrete structure in the distance. The jungle\ncenter is back to the south."
		})

		@scenes[:jungle_west] ||= Scene.new({ delegate: @delegate, })
		@scenes[:jungle_west].load_unsaved_data({ name: "Western Jungle",
			description: "The jungle is interupted by a small stream running out\nto sea. The jungle center is back to the east."
		})

		@scenes[:jungle_ne] ||= Scene.new({ delegate: @delegate, })
		@scenes[:jungle_ne].load_unsaved_data({ name: "Northeast Jungle",
			# fix description here
			description: "We should probly insert a legit description here, but\nfor now, the jungle center is back to the sw.\nGo crazy."
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
		@scenes[:jungle_entrance].paths = { s: @scenes[:shore], n: @scenes[:jungle_main] }
		@scenes[:jungle_main].paths = { e: @scenes[:jungle_east], n: @scenes[:jungle_north], w: @scenes[:jungle_west], ne: @scenes[:jungle_ne]}
		@scenes[:jungle_east].paths = { w: @scenes[:jungle_main] }
		@scenes[:jungle_north].paths = { s: @scenes[:jungle_main] }
		@scenes[:jungle_west].paths = { e: @scenes[:jungle_main] }
		@scenes[:jungle_ne].paths = { sw: @scenes[:jungle_main] }
	end

	def [](id)
		@scenes[id]
	end

end