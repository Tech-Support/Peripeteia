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

		add_item(:coconut, {}, { name: "coconut",
			description: "Hm, this coconut must have fallen off a tree.\nOr perhaps a swallow brought it here...", article: "a"
		})

		add_item(:rope, {}, { name: "rope",
			description: "This rope is pretty sturdy. Perfect for life lines.",
			block: -> (this) {
				# `this` is the rope
				if this.delegate.current_scene == this.delegate.scene_manager[:west_deck]
					this.delegate.player.inventory.objects.delete(this)
					this.delegate.teleport(:shore, "Insert message here.")
				else
					puts "There is nothing to tie a rope to here."
				end
			}
		}, Rope)

		add_item(:rusty_key, {}, { name: "rusty key", alt_names: ["key"],
			description: "This key is pretty old, so the lock it belongs\nto is probably in the same condition."
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
			description: "The shore continues to stretch to the north east, but also goes back to the west."
		})

		add_scene(:shore_shack, {}, { name: "North East Shore",
			description: "The shore is cut off here by rocks. There is an old and\nrun down shack here, and it has a rusty padlock\nholding the door shut. The beach goes back to the\nsouthwest."
		})

		add_scene(:jungle_entrance, { items: ObjectManager.new([
				@items[:coconut]
			])
		}, { name: "Jungle Entrance",
			description: "The trees are very tall here, and few of the suns\nrays are able to penetrate the thick canopy of leaves.\nThe beach is back to the south. The jungle continues\nnorth."
		})

		add_scene(:jungle_main, {}, { name: "Central Jungle",
			description: "The trees continue to grow thicker as you enter the\nheart of the jungle. The Jungle continues to the East,\nNorth, West and Northeast. The beach is back to the\nsouth."
		})

		add_scene(:jungle_east, { items: ObjectManager.new([
				@items[:rusty_key]
			])
		}, { name: "Eastern Jungle",
			description: "The jungle continues to fan out around you, but the\ntrees are too thick for you to go any further. The\njungle center is back to the west."
		})

		add_scene(:jungle_north, {}, { name: "Northern Jungle",
			description: "The jungle continues on to the north, and you can see\na concrete structure in the distance. The jungle\ncenter is back to the south."
		})

		add_scene(:jungle_west, {}, { name: "Western Jungle",
			description: "The jungle is interupted by a small stream running out\nto sea. The jungle center is back to the east."
		})

		add_scene(:jungle_ne, {}, { name: "Northeast Jungle",
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